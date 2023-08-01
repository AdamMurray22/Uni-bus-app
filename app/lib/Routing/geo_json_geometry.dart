import 'dart:convert';

class GeoJsonGeometry
{
  final String _geometry;
  late final String? _colour;

  GeoJsonGeometry(this._geometry)
  {
    _colour = null;
  }
  GeoJsonGeometry.setColour(this._geometry, this._colour);

  /// Returns the geometry as a string.
  String getGeometryString()
  {
    return _geometry;
  }

  /// Returns the geometry as a json.
  dynamic getGeometry()
  {
    return jsonDecode(_geometry);
  }

  /// Returns the colour of the geojson if it has one.
  String? getColour()
  {
    return _colour;
  }

  bool hasColour()
  {
    return _colour != null;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is GeoJsonGeometry &&
              runtimeType == other.runtimeType &&
              _geometry == other._geometry &&
              _colour == other._colour;

  @override
  int get hashCode => _geometry.hashCode;
}