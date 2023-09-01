// Mocks generated by Mockito 5.4.0 from annotations
// in app/test/Routing/RouteCreators/basic_route_creator_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:app/Routing/location.dart' as _i4;
import 'package:app/Routing/Servers/routing_server.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

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

/// A class which mocks [RoutingServer].
///
/// See the documentation for Mockito's code generation for more information.
class MockRoutingServer extends _i1.Mock implements _i2.RoutingServer {
  MockRoutingServer() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<String> getResponseBody(
    _i4.Location? startLocation,
    _i4.Location? endLocation,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #getResponseBody,
          [
            startLocation,
            endLocation,
          ],
        ),
        returnValue: _i3.Future<String>.value(''),
      ) as _i3.Future<String>);
  @override
  String getUriDomains() => (super.noSuchMethod(
        Invocation.method(
          #getUriDomains,
          [],
        ),
        returnValue: '',
      ) as String);
}
