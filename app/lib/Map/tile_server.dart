class TileServer
{
  final String _url;
  final String _attribution;

  TileServer(this._url, this._attribution);

  String get url => _url;

  String get attribution => _attribution;

  String getUrlDomains()
  {
    return url.split("/")[2];
  }
}