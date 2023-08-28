import sys
import logging
import getMapData.package.pymysql as pymysql
import json
import os

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

def lambda_handler(event, context):
    uniID = event['uniID']
    
    return_json = {}

    universityData = []
    with conn.cursor() as cur:
        cur.execute(f"select * from university where University_ID = '{uniID}'")
        for row in cur:
            universityMap = {}
            universityMap["UniversityID"] = row[0]
            universityMap["UniversityName"] = row[1]
            universityData.append(universityMap)
        cur.close()
    conn.commit()
    return_json["University"] = universityData

    featuresData = []
    with conn.cursor() as cur:
        cur.execute(f"select * from feature where University_ID = '{uniID}'")
        for row in cur:
            featureMap = {}
            featureMap["FeatureID"] = row[1]
            featureMap["FeatureName"] = row[2]
            featureMap["Longitude"] = row[3]
            featureMap["latitude"] = row[4]
            featuresData.append(featureMap)
        cur.close()
    conn.commit()
    return_json["Features"] = featuresData

    termDatesData = []
    with conn.cursor() as cur:
        cur.execute(f"select * from term_dates where University_ID = '{uniID}'")
        for row in cur:
            termDateMap = {}
            termDateMap["StartDate"] = row[1]
            termDateMap["EndDate"] = row[2]
            termDatesData.append(termDateMap)
        cur.close()
    conn.commit()
    return_json["TermDates"] = termDatesData

    nationalHolidaysData = []
    with conn.cursor() as cur:
        cur.execute("select * from national_holiday")
        for row in cur:
            nationalHolidayMap = {}
            nationalHolidayMap["Date"] = row[0]
            nationalHolidaysData.append(nationalHolidayMap)
        cur.close()
    conn.commit()
    return_json["NationalHolidays"] = nationalHolidaysData

    busTimesData = []
    for feature in featuresData:
        with conn.cursor() as cur:
            cur.execute(f"select * from bus_times where Bus_Stop_ID = '{feature['FeatureID']}'")
            for row in cur:
                busTimesMap = {}
                busTimesMap["BusStopID"] = row[0]
                busTimesMap["BusTimeID"] = row[1]
                busTimesMap["ArriveTime"] = row[2]
                busTimesMap["DepartTime"] = row[3]
                busTimesMap["Route"] = row[4]
                busTimesData.append(busTimesMap)
            cur.close()
        conn.commit()
    return_json["BusTimes"] = busTimesData

    busStopOrderData = []
    for feature in featuresData:
        with conn.cursor() as cur:
            cur.execute(f"select * from bus_stop_order where Bus_Stop_ID = '{feature['FeatureID']}'")
            for row in cur:
                busStopOrderMap = {}
                busStopOrderMap["BusStopID"] = row[0]
                busStopOrderMap["Order"] = row[1]
                busStopOrderData.append(busStopOrderMap)
            cur.close()
        conn.commit()
    return_json["BusStopOrder"] = busStopOrderData

    return return_json