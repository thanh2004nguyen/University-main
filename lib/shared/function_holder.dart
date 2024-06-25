class FunctionHolder {
  // Define a variable that can hold a function with no parameters and no return value
  static Function? _function;

  // Method to set the function
 static void setFunction(Function function) {
    _function = function;
  }

  // Method to call the function
  static callFunction() {
    if (_function != null) {
      _function!();  // Call the function
    } else {
      print('Function is not set.');
    }
  }
}