class Validator {
  /// Verifies if the provided email is valid
  static String? isEmailValid(String? email) {
    String? res = nullCheck(email, "Email");
    if (res != null) {
      return res;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email!)) {
      return "Invalid email";
    }
    return null;
  }

  /// Verifies if the provided name is valid
  static String? isNameValid(String? name) {
    String? res = nullCheck(name, "Name");
    if (res != null) {
      return res;
    }
    //checks if name contains only letters and no numbers or symbols
    if (!RegExp(r'^[a-z A-Z]+$').hasMatch(name!)) {
      return "Invalid name";
    }
    return null;
  }

  /// Verifies if the provided scholar ID is valid
  static String? isScholarIDValid(String? scholarID) {
    String? res = nullCheck(scholarID, "Scholar ID");
    if (res != null) {
      return res;
    }
    //checks only for B.Tech students from year 2010 to 2023
    if (!RegExp(r'^(1[0-9]|20|21|22|23)[1][1-6](?!000)[0-9]{3}$')
        .hasMatch(scholarID!)) {
      return "Invalid scholar ID";
    }
    return null;
  }

  //checks if field is null or empty
  static String? nullCheck(String? value, String? fieldName) {
    if (value == null || value.isEmpty) {
      return "${fieldName ?? "field"} cannot be empty";
    }
    return null;
  }

  static String? isPasswordValid(String? password) {
    String? res = nullCheck(password, "Password");
    if (res != null) {
      return res;
    }
    if (password!.length < 6) {
      return "Password cannot be shorter than 6 character";
    }
    return null;
  }

  static String? isConfirmPassword(String? password, String? confirmPassword) {
    String? res = nullCheck(confirmPassword, "Confirm Password");
    if (res != null) {
      return res;
    }

    if (password != confirmPassword) {
      return "Enter the correct password";
    }
    return null;
  }
}
