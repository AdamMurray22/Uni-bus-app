/// Wrapper for bool.
class BoolWrapper
{
  bool _value;
  BoolWrapper(this._value);

  /// Returns the boolean value.
  bool getValue()
  {
    return _value;
  }

  /// Sets the boolean value.
  setValue(bool value)
  {
    _value = value;
  }
}