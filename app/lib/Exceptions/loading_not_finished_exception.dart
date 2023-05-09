/// Error for when the map data is attempted to be accessed before it has
/// finished loading.
class LoadingNotFinishedException extends Error
{
  String message;
  LoadingNotFinishedException(this.message);
}