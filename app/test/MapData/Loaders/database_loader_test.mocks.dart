// Mocks generated by Mockito 5.4.0 from annotations
// in app/test/MapData/Loaders/database_loader_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:app/MapData/Loaders/bus_route_geojson_loader.dart' as _i5;
import 'package:mockito/mockito.dart' as _i1;
import 'package:sqflite_common/sql.dart' as _i4;
import 'package:sqflite_common/sqlite_api.dart' as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeDatabase_0 extends _i1.SmartFake implements _i2.Database {
  _FakeDatabase_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeFuture_1<T> extends _i1.SmartFake implements _i3.Future<T> {
  _FakeFuture_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeQueryCursor_2 extends _i1.SmartFake implements _i2.QueryCursor {
  _FakeQueryCursor_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeBatch_3 extends _i1.SmartFake implements _i2.Batch {
  _FakeBatch_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [Database].
///
/// See the documentation for Mockito's code generation for more information.
class MockDatabase extends _i1.Mock implements _i2.Database {
  MockDatabase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get path => (super.noSuchMethod(
        Invocation.getter(#path),
        returnValue: '',
      ) as String);
  @override
  bool get isOpen => (super.noSuchMethod(
        Invocation.getter(#isOpen),
        returnValue: false,
      ) as bool);
  @override
  _i2.Database get database => (super.noSuchMethod(
        Invocation.getter(#database),
        returnValue: _FakeDatabase_0(
          this,
          Invocation.getter(#database),
        ),
      ) as _i2.Database);
  @override
  _i3.Future<void> close() => (super.noSuchMethod(
        Invocation.method(
          #close,
          [],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
  @override
  _i3.Future<T> transaction<T>(
    _i3.Future<T> Function(_i2.Transaction)? action, {
    bool? exclusive,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #transaction,
          [action],
          {#exclusive: exclusive},
        ),
        returnValue: _FakeFuture_1<T>(
          this,
          Invocation.method(
            #transaction,
            [action],
            {#exclusive: exclusive},
          ),
        ),
      ) as _i3.Future<T>);
  @override
  _i3.Future<T> devInvokeMethod<T>(
    String? method, [
    Object? arguments,
  ]) =>
      (super.noSuchMethod(
        Invocation.method(
          #devInvokeMethod,
          [
            method,
            arguments,
          ],
        ),
        returnValue: _FakeFuture_1<T>(
          this,
          Invocation.method(
            #devInvokeMethod,
            [
              method,
              arguments,
            ],
          ),
        ),
      ) as _i3.Future<T>);
  @override
  _i3.Future<T> devInvokeSqlMethod<T>(
    String? method,
    String? sql, [
    List<Object?>? arguments,
  ]) =>
      (super.noSuchMethod(
        Invocation.method(
          #devInvokeSqlMethod,
          [
            method,
            sql,
            arguments,
          ],
        ),
        returnValue: _FakeFuture_1<T>(
          this,
          Invocation.method(
            #devInvokeSqlMethod,
            [
              method,
              sql,
              arguments,
            ],
          ),
        ),
      ) as _i3.Future<T>);
  @override
  _i3.Future<void> execute(
    String? sql, [
    List<Object?>? arguments,
  ]) =>
      (super.noSuchMethod(
        Invocation.method(
          #execute,
          [
            sql,
            arguments,
          ],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
  @override
  _i3.Future<int> rawInsert(
    String? sql, [
    List<Object?>? arguments,
  ]) =>
      (super.noSuchMethod(
        Invocation.method(
          #rawInsert,
          [
            sql,
            arguments,
          ],
        ),
        returnValue: _i3.Future<int>.value(0),
      ) as _i3.Future<int>);
  @override
  _i3.Future<int> insert(
    String? table,
    Map<String, Object?>? values, {
    String? nullColumnHack,
    _i4.ConflictAlgorithm? conflictAlgorithm,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #insert,
          [
            table,
            values,
          ],
          {
            #nullColumnHack: nullColumnHack,
            #conflictAlgorithm: conflictAlgorithm,
          },
        ),
        returnValue: _i3.Future<int>.value(0),
      ) as _i3.Future<int>);
  @override
  _i3.Future<List<Map<String, Object?>>> query(
    String? table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #query,
          [table],
          {
            #distinct: distinct,
            #columns: columns,
            #where: where,
            #whereArgs: whereArgs,
            #groupBy: groupBy,
            #having: having,
            #orderBy: orderBy,
            #limit: limit,
            #offset: offset,
          },
        ),
        returnValue: _i3.Future<List<Map<String, Object?>>>.value(
            <Map<String, Object?>>[]),
      ) as _i3.Future<List<Map<String, Object?>>>);
  @override
  _i3.Future<List<Map<String, Object?>>> rawQuery(
    String? sql, [
    List<Object?>? arguments,
  ]) =>
      (super.noSuchMethod(
        Invocation.method(
          #rawQuery,
          [
            sql,
            arguments,
          ],
        ),
        returnValue: _i3.Future<List<Map<String, Object?>>>.value(
            <Map<String, Object?>>[]),
      ) as _i3.Future<List<Map<String, Object?>>>);
  @override
  _i3.Future<_i2.QueryCursor> rawQueryCursor(
    String? sql,
    List<Object?>? arguments, {
    int? bufferSize,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #rawQueryCursor,
          [
            sql,
            arguments,
          ],
          {#bufferSize: bufferSize},
        ),
        returnValue: _i3.Future<_i2.QueryCursor>.value(_FakeQueryCursor_2(
          this,
          Invocation.method(
            #rawQueryCursor,
            [
              sql,
              arguments,
            ],
            {#bufferSize: bufferSize},
          ),
        )),
      ) as _i3.Future<_i2.QueryCursor>);
  @override
  _i3.Future<_i2.QueryCursor> queryCursor(
    String? table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
    int? bufferSize,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #queryCursor,
          [table],
          {
            #distinct: distinct,
            #columns: columns,
            #where: where,
            #whereArgs: whereArgs,
            #groupBy: groupBy,
            #having: having,
            #orderBy: orderBy,
            #limit: limit,
            #offset: offset,
            #bufferSize: bufferSize,
          },
        ),
        returnValue: _i3.Future<_i2.QueryCursor>.value(_FakeQueryCursor_2(
          this,
          Invocation.method(
            #queryCursor,
            [table],
            {
              #distinct: distinct,
              #columns: columns,
              #where: where,
              #whereArgs: whereArgs,
              #groupBy: groupBy,
              #having: having,
              #orderBy: orderBy,
              #limit: limit,
              #offset: offset,
              #bufferSize: bufferSize,
            },
          ),
        )),
      ) as _i3.Future<_i2.QueryCursor>);
  @override
  _i3.Future<int> rawUpdate(
    String? sql, [
    List<Object?>? arguments,
  ]) =>
      (super.noSuchMethod(
        Invocation.method(
          #rawUpdate,
          [
            sql,
            arguments,
          ],
        ),
        returnValue: _i3.Future<int>.value(0),
      ) as _i3.Future<int>);
  @override
  _i3.Future<int> update(
    String? table,
    Map<String, Object?>? values, {
    String? where,
    List<Object?>? whereArgs,
    _i4.ConflictAlgorithm? conflictAlgorithm,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #update,
          [
            table,
            values,
          ],
          {
            #where: where,
            #whereArgs: whereArgs,
            #conflictAlgorithm: conflictAlgorithm,
          },
        ),
        returnValue: _i3.Future<int>.value(0),
      ) as _i3.Future<int>);
  @override
  _i3.Future<int> rawDelete(
    String? sql, [
    List<Object?>? arguments,
  ]) =>
      (super.noSuchMethod(
        Invocation.method(
          #rawDelete,
          [
            sql,
            arguments,
          ],
        ),
        returnValue: _i3.Future<int>.value(0),
      ) as _i3.Future<int>);
  @override
  _i3.Future<int> delete(
    String? table, {
    String? where,
    List<Object?>? whereArgs,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #delete,
          [table],
          {
            #where: where,
            #whereArgs: whereArgs,
          },
        ),
        returnValue: _i3.Future<int>.value(0),
      ) as _i3.Future<int>);
  @override
  _i2.Batch batch() => (super.noSuchMethod(
        Invocation.method(
          #batch,
          [],
        ),
        returnValue: _FakeBatch_3(
          this,
          Invocation.method(
            #batch,
            [],
          ),
        ),
      ) as _i2.Batch);
}

/// A class which mocks [BusRouteGeoJsonLoader].
///
/// See the documentation for Mockito's code generation for more information.
class MockBusRouteGeoJsonLoader extends _i1.Mock
    implements _i5.BusRouteGeoJsonLoader {
  MockBusRouteGeoJsonLoader() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<Map<String, dynamic>> getBusRouteGeoJson() => (super.noSuchMethod(
        Invocation.method(
          #getBusRouteGeoJson,
          [],
        ),
        returnValue:
            _i3.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i3.Future<Map<String, dynamic>>);
  @override
  _i3.Future<String> getBusRouteGeoJsonAsString() => (super.noSuchMethod(
        Invocation.method(
          #getBusRouteGeoJsonAsString,
          [],
        ),
        returnValue: _i3.Future<String>.value(''),
      ) as _i3.Future<String>);
}
