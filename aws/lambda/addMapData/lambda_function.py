import sys
import logging
import addMapData.package.pymysql as pymysql
import json
import os
import re

# rds settings
user_name = os.environ['USER_NAME']
password = os.environ['PASSWORD']
rds_proxy_host = os.environ['RDS_PROXY_HOST']
db_name = os.environ['DB_NAME']

logger = logging.getLogger()
logger.setLevel(logging.INFO)

# create the database connection outside of the handler to allow connections to be
# re-used by subsequent function invocations.
try:
        conn = pymysql.connect(host=rds_proxy_host, user=user_name, passwd=password, db=db_name, connect_timeout=5)
except pymysql.MySQLError as e:
    logger.error("ERROR: Unexpected error: Could not connect to MySQL instance.")
    logger.error(e)
    sys.exit()

logger.info("SUCCESS: Connection to RDS for MySQL instance succeeded")

def lambda_handler(event, context):
    """
    This function creates a new RDS database table and writes records to it
    """
    message = event['Records'][0]['body']
    data = json.loads(message)
    UniversityData = data['University']
    FeaturesData = data['Features']
    BusTimesData = data['BusTimes']
    BusStopOrderData = data['BusStopOrder']
    NationalHolidayData = data['NationalHoliday']
    TermDatesData = data['TermDates']


    university_sql_string = 'insert into university (University_ID, University_Name) values("{UniversityID}", "{UniversityName}")'
    features_sql_string = 'insert into feature (University_ID, Feature_ID, Feature_Name, Longitude, Latitude) values("{UniversityID}", "{FeatureID}", "{FeatureName}", {Longitude}, {Latitude})'
    bus_times_sql_string = 'insert into bus_times (Bus_Stop_ID, Bus_Time_ID, Arrive_Time, Depart_Time, Route) values("{BusStopID}", "{BusTimeID}", "{ArriveTime}", "{DepartTime}", {Route})'
    bus_stop_order_sql_string = 'insert into bus_stop_order (Bus_Stop_ID, Bus_Stop_Order) values("{BusStopID}", {Order})'
    national_holidays_sql_string = 'insert into national_holiday (Date) values("{Date}")'
    term_dates_sql_string = 'insert into term_dates (University_ID, Start_Date, End_Date) values("{UniversityID}", "{StartDate}", "{EndDate}")'

    create_schema()

    item_count = 0

    with conn.cursor() as cur:
        for university in UniversityData:
            try:
                cur.execute(university_sql_string.format(UniversityID = escape_sql_string(university['university_id']), UniversityName = escape_sql_string(university['university_name'])))
                item_count += 1
            except pymysql.MySQLError as e:
                logger.error(e)
            conn.commit()

        for features in FeaturesData:
            try:
                cur.execute(features_sql_string.format(UniversityID = escape_sql_string(features['university_id']), FeatureID = escape_sql_string(features['feature_id']), FeatureName = escape_sql_string(features['feature_name']), Longitude = features['longitude'], Latitude = features['latitude']))
                item_count += 1
            except pymysql.MySQLError as e:
                logger.error(e)
            conn.commit()

        for busTimes in BusTimesData:
            try:
                cur.execute(bus_times_sql_string.format(BusStopID = escape_sql_string(busTimes['bus_stop_id']), BusTimeID = escape_sql_string(busTimes['bus_time_id']), ArriveTime = escape_sql_string(busTimes['arrive_time']), DepartTime = escape_sql_string(busTimes['depart_time']), Route = busTimes['route']))
                item_count += 1
            except pymysql.MySQLError as e:
                logger.error(e)
            conn.commit()

        for busStopOrder in BusStopOrderData:
            try:
                cur.execute(bus_stop_order_sql_string.format(BusStopID = escape_sql_string(busStopOrder['bus_stop_id']), Order = busStopOrder['order']))
                item_count += 1
            except pymysql.MySQLError as e:
                logger.error(e)
            conn.commit()

        for nationalHoliday in NationalHolidayData:
            try:
                cur.execute(national_holidays_sql_string.format(Date = escape_sql_string(nationalHoliday['date'])))
                item_count += 1
            except pymysql.MySQLError as e:
                logger.error(e)
            conn.commit()

        for termDates in TermDatesData:
            try:
                cur.execute(term_dates_sql_string.format(UniversityID = escape_sql_string(termDates['university_id']), StartDate = escape_sql_string(termDates['start_date']), EndDate = escape_sql_string(termDates['end_date'])))
                item_count += 1
            except pymysql.MySQLError as e:
                logger.error(e)
            conn.commit()

        conn.commit()
    conn.commit()

    logger.info("Added %d items to RDS for MySQL database" %(item_count))
    return "Added %d items to RDS for MySQL database" %(item_count)

def create_schema():
    with conn.cursor() as cur:
        # Creates the university table
        cur.execute(get_university_table_sql())
        # Creates the features table
        cur.execute(get_features_table_sql())
        # Creates the bus times table
        cur.execute(get_bus_times_table_sql())
        # Creates the bus stop order table
        cur.execute(get_bus_stop_order_table_sql())
        # Creates the national holidays table
        cur.execute(get_national_holiday_table_sql())
        # Creates the term dates table
        cur.execute(get_term_dates_table_sql())
        conn.commit()
    conn.commit()

# Gets the university table sql
def get_university_table_sql():
    return "create table if not exists university ( University_ID  varchar(255) NOT NULL, University_Name varchar(255) NOT NULL, PRIMARY KEY (University_ID))"

# Gets the features table sql
def get_features_table_sql():
    sql_string = "create table if not exists feature ( {uniID}, {featureID}, {featureName}, {longitude}, {latitude}, {primaryKey}, {foreignKey})"
    uni_ID = "University_ID  varchar(255) NOT NULL"
    feature_ID = "Feature_ID varchar(255) NOT NULL"
    feature_Name = "Feature_Name varchar(255) NOT NULL"
    longitude = "Longitude double NOT NULL"
    latitude = "Latitude double NOT NULL"
    primary_Key = "PRIMARY KEY (Feature_ID)"
    foreign_Key = "FOREIGN KEY (University_ID) REFERENCES university(University_ID) ON DELETE CASCADE ON UPDATE CASCADE"
    return sql_string.format(uniID = uni_ID, featureID = feature_ID, featureName = feature_Name, longitude = longitude, latitude = latitude, primaryKey = primary_Key, foreignKey = foreign_Key)

# Gets the bus times table sql
def get_bus_times_table_sql():
    sql_string = "create table if not exists bus_times ( {busStopID}, {busTimeID}, {arriveTime}, {departTime}, {route}, {primaryKey}, {foreignKey})"
    busStop_ID = "Bus_Stop_ID  varchar(255) NOT NULL"
    busTime_ID = "Bus_Time_ID varchar(255) NOT NULL"
    arrive_Time = "Arrive_Time varchar(255)"
    depart_Time = "Depart_Time varchar(255)"
    route = "Route int NOT NULL"
    primary_Key = "PRIMARY KEY (Bus_Time_ID)"
    foreign_Key = "FOREIGN KEY (Bus_Stop_ID) REFERENCES feature(Feature_ID) ON DELETE CASCADE ON UPDATE CASCADE"
    return sql_string.format(busStopID = busStop_ID, busTimeID = busTime_ID, arriveTime = arrive_Time, departTime = depart_Time, route = route, primaryKey = primary_Key, foreignKey = foreign_Key)

# Gets the bus stop order table sql
def get_bus_stop_order_table_sql():
    sql_string = "create table if not exists bus_stop_order ( {busStopID}, {order}, {primaryKey}, {foreignKey})"
    busStop_ID = "Bus_Stop_ID  varchar(255) NOT NULL"
    order = "Bus_Stop_Order int NOT NULL"
    primary_Key = "PRIMARY KEY (Bus_Stop_ID, Bus_Stop_Order)"
    foreign_Key = "FOREIGN KEY (Bus_Stop_ID) REFERENCES feature(Feature_ID) ON DELETE CASCADE ON UPDATE CASCADE"
    return sql_string.format(busStopID = busStop_ID, order = order, primaryKey = primary_Key, foreignKey = foreign_Key)

# Gets the national holiday table sql
def get_national_holiday_table_sql():
    return "create table if not exists national_holiday ( Date varchar(255) NOT NULL, PRIMARY KEY (Date))"

# Gets the term dates table sql
def get_term_dates_table_sql():
    sql_string = "create table if not exists term_dates ( {uniID}, {startDate}, {endDate}, {primaryKey}, {foreignKey})"
    university_ID = "University_ID  varchar(255) NOT NULL"
    start_Date = "Start_Date  varchar(255) NOT NULL"
    end_Date = "End_Date  varchar(255) NOT NULL"
    primary_Key = "PRIMARY KEY (University_ID, Start_Date, End_Date)"
    foreign_Key = "FOREIGN KEY (University_ID) REFERENCES university(University_ID) ON DELETE CASCADE ON UPDATE CASCADE"
    return sql_string.format(uniID = university_ID, startDate = start_Date, endDate = end_Date, primaryKey = primary_Key, foreignKey = foreign_Key)

def escape_sql_string(sql_string):
    translate_table = str.maketrans({"]": r"\]", "\\": r"\\",
                                 "^": r"\^", "$": r"\$", "*": r"\*", "'": r"\'"})
    if (sql_string is None):
        return sql_string
    return sql_string.translate(translate_table)