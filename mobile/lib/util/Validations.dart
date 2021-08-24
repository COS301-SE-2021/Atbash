class Validations {
  //This the correct place for this??
  bool numberIsValid(String number){
    final pattern = r'^(?:[+0][1-9])?[0-9]{10,12}$';
    final regExp = new RegExp(pattern);

    return regExp.hasMatch(number);
  }
}