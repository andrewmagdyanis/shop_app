import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputAssertion {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final int age;
  final confirmedPassword;

  const InputAssertion({
    Key key,
    this.email,
    this.password,
    this.firstName,
    this.confirmedPassword,
    this.age,
    this.lastName,
  });

  void emailAndPasswordAssertion(String email, String password) {
    assert((password != null), 'The password can\'t be null');
    assert((password != ''), 'The password can\'t be empty');
    assert((email != null), 'The email can\'t be null');
    assert((email != ''), 'The email can\'t be empty');
    assert((email.contains('@')), 'The email should contains @');
    assert((email.contains('.com')), 'The should contains .com');
  }

  dynamic emailAssertion(String email) {
    if (email == null) return ('The email can\'t be null');
    if (email == '') return ('The email can\'t be empty');
    if (!email.contains('@')) return ('The email should contains @');
    if (!email.contains('.com')) return ('The should contains .com');
    return null;
  }

  dynamic passwordAssertion(String password) {
    if (password == null) return ('The password can\'t be null');
    if (password == '') return ('The password can\'t be empty');
    return null;
  }

  dynamic confirmedPasswordAssertion(String password, String confirmationPassword) {
    if (password == null) return ('The password can\'t be null');
    if (password == '') return ('The password can\'t be empty');
    if (password != confirmationPassword) return ('The password isn\'t confirmed correctly');

    return null;
  }

  dynamic nameAssertion(String name) {
    if (name == null) return ('The name can\'t be null');
    if (name == '') return ('The name can\'t be empty');
    return null;
  }

  dynamic ageAssertion(int age) {
    if (age == null) return ('The age can\'t be null');
    if (age == 0) return ('The age can\'t be zero');
    if (age >= 100) return ('enter the real age');
    if (age < 5) return ('enter the real age');

    return null;
  }

  dynamic allFieldsFilledAssertion(String firstName, String lastName, int age, String gender,
      String password, String confirmedPassword, String email) {
    if (firstName == null) return ('The firstName can\'t be null');
    if (lastName == null) return ('The lastName can\'t be null');
    if (age == null) return ('The age can\'t be null');
    if (gender == null) return ('The gender can\'t be null');
    if (password == null) return ('The password can\'t be null');
    if (confirmedPassword == null) return ('The confirmedPassword can\'t be null');
    if (email == null) return ('The email can\'t be null');

    dynamic emailErrorReturn = emailAssertion(email);
    dynamic ageErrorReturn = ageAssertion(age);
    dynamic passwordErrorReturn = passwordAssertion(password);
    dynamic confirmationPasswordErrorReturn =
        confirmedPasswordAssertion(password, confirmedPassword);
    dynamic firstNameErrorReturn = nameAssertion(firstName);
    dynamic lastNameErrorReturn = nameAssertion(lastName);


    if (emailErrorReturn == null &&
        ageErrorReturn == null &&
        passwordErrorReturn == null &&
        confirmationPasswordErrorReturn == null &&
        firstNameErrorReturn == null &&
        lastNameErrorReturn == null) {
      return 'done';
    }
    else{
      return null;
    }
  }
}
