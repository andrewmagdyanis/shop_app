import '../services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'dart:io';
import 'package:oauth1/oauth1.dart' as oauth1;
import 'package:flutter/material.dart';
import '../reduxElements/models/models.dart';
import '../reduxElements/actions/actions.dart';
import 'package:shop_app/reduxElements/actions/userInfo_update.dart';
import 'package:shop_app/reduxElements/models/app_state.dart';
import 'package:shop_app/reduxElements/models/user_state.dart';

import 'database_service.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _fireStore = Firestore.instance;

  //social media authetication instances
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  final FacebookLogin _facebookLogin = FacebookLogin();
  final TwitterLogin _twitterLogin = new TwitterLogin(
      consumerKey: 'O4IHRKUod4CHBb1ScjW6fh6Wi',
      consumerSecret: 'h5nANM53WmF5vWHjZEtHTg4cYPgQqhOC8dqWp4VI1HfrthZ255');

  final BuildContext context;

  //constructor
  AuthServices({@required this.context});

  DatabaseService databaseService = DatabaseService();

  Future<UserState> saveUserData(FirebaseUser user,
      {String authProvider = "null", String firstName = 'null', String lastName = 'null'}) async {
    UserState userState =
        UserState(user, authProvider: authProvider, firstName: firstName, lastName: lastName);
    print(userState.toString());

    var data = userState.toMap();

    print('userState toMap output: ');
    print(data);

    bool foundInFireStore = false;
    await _fireStore.collection('Users').getDocuments().then((value) {
      value.documents.forEach((element) {
        if (element.documentID == user.uid) {
          foundInFireStore = true;
          print('Found before in Users list');
          print('retrieved data+\n' + element.data.toString());
          //userState = UserState.fromMap(element.data);
          /*
          userState = UserState.defaultConstructor(
            userId : element.data["userId"],
            userName : element.data["userName"],
            profilePictureUrl : element.data["profilePictureUrl"],
            phoneNumber : element.data["phoneNumber"],
            email : element.data["email"],
            authProvider : element.data["authProvider"],
            creationTime : element.data["creationTime"] is String
                ? DateTime.parse(element.data["creationTime"])
                : element.data["creationTime"],
            lastSignInTime : element.data["lastSignInTime"] is String
                ? DateTime.parse(element.data["lastSignInTime"])
                : element.data["lastSignInTime"],
            loggedIn : element.data["loggedIn"] == 1 ? true : false,

          );
          */

          userState = UserState.fromMap(element.data);

          print(element.data);
          print('userState from FireStore: ');
          print(userState);
          //userState
        }
      });
    });
    if (!foundInFireStore) {
      _fireStore.collection('Users').document(user.uid.toString()).setData(data);
    }
    StoreProvider.of<AppState>(context).dispatch(UserInfoUpdate(
      userState: userState,
    ));

    int id = await databaseService.insertObject(userState);
    print('id of the object inserted: ' + id.toString());
    return userState;
  }

  //sign-in anonomusly
  Future<dynamic> signInAnon() async {
    AuthResult authResult;
    try {
      authResult = await _auth.signInAnonymously();
    } catch (e) {
      print('annonmusly login error: ' + e.toString());
      return e;
    }
    FirebaseUser user = authResult.user;
    UserState userState = await saveUserData(user, authProvider: 'anonomusly');
    print('Done.... you are signed-in Anonomusly');
    return userState;
  }

  //email-password sign -up
  Future<dynamic> signUpEmailPassword(
      String firstName, String lastName, String email, String password) async {
    AuthResult authResult;
    try {
      authResult = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print('email-password signup error:' + e.toString());
      return e;
    }
    FirebaseUser user = authResult.user;
    UserState userState = await saveUserData(
      user,
      firstName: firstName,
      lastName: lastName,
      authProvider: 'email-'
          'password',
    );
    print('Done.... you are signed-up successfuly with email and password');
    return userState;
  }

  //email-passowrd sing-in
  Future<dynamic> signInEmailPassword(String email, String password) async {
    AuthResult authResult;
    try {
      authResult = await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print(e.toString());
      return e;
    }
    FirebaseUser user = authResult.user;
    UserState userState = await saveUserData(user, authProvider: 'null');

    print('Done.... you are signed-in email and password');

    return userState;
  }

  // sign-in with Google
  Future<dynamic> googleLogin() async {
    GoogleSignInAccount googleUser;
    GoogleSignInAuthentication googleAuth;
    try {
      googleUser = await _googleSignIn.signIn();
      googleAuth = await googleUser.authentication;
    } catch (e) {
      print('Google Login error: ' + e.toString());
      return (e);
    }
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    UserState userState = await saveUserData(user, authProvider: 'Google');

    print('Done.... you are signed-in with Google authentication');
    return userState;
  }

  //Facebook Login:
  Future<dynamic> facebookLogin() async {
    dynamic user;
    UserState userState;
    FacebookLoginResult facebookLoginResult;
    try {
      facebookLoginResult = await _facebookLogin.logIn(['email']);
    } catch (e) {
      print('facebook login result error: ' + e.toString());
      user = e;
    }
    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        print("Error");
        user = FacebookLoginStatus.error;
        break;

      case FacebookLoginStatus.cancelledByUser:
        print("CancelledByUser");
        user = FacebookLoginStatus.cancelledByUser;
        break;

      case FacebookLoginStatus.loggedIn:
        print("LoggedIn");
        final AuthCredential credential = FacebookAuthProvider.getCredential(
          accessToken: facebookLoginResult.accessToken.token,
        );
        user = (await _auth.signInWithCredential(credential)).user;

        userState = await saveUserData(user, authProvider: 'Facebook');

        print('Done.... you are signed-in with Facebook authentication');
        break;
    }
    return userState;
  }

  //Twitter Login:
  Future<dynamic> twitterLogin() async {
    dynamic user;
    UserState userState;
    TwitterLoginResult twitterLoginResult;
    try {
      twitterLoginResult = await _twitterLogin.authorize();
    } catch (e) {
      print('twitter login result error: ' + e.toString());
      user = e;
    }
    switch (twitterLoginResult.status) {
      case TwitterLoginStatus.error:
        print("Error");
        user = TwitterLoginStatus.error;
        break;

      case TwitterLoginStatus.cancelledByUser:
        print("CancelledByUser");
        user = TwitterLoginStatus.cancelledByUser;
        break;

      case TwitterLoginStatus.loggedIn:
        print("LoggedIn");
        final AuthCredential credential = TwitterAuthProvider.getCredential(
          authToken: twitterLoginResult.session.token,
          authTokenSecret: twitterLoginResult.session.secret,
        );
        user = (await _auth.signInWithCredential(credential)).user;
        userState = await saveUserData(user, authProvider: 'Twitter');

        print('Done.... you are signed-in with Twitter authentication');
        break;
    }

    return userState;
  }

  Future<dynamic> twitterLogin2(BuildContext context) async {
    FirebaseUser user;
    UserState userState;
    Navigator.of(context).pushNamed('twitterPage', arguments: {
      "consumerKey": 'O4IHRKUod4CHBb1ScjW6fh6Wi',
      "consumerSecret": 'h5nANM53WmF5vWHjZEtHTg4cYPgQqhOC8dqWp4VI1HfrthZ255',
      "oauthCallbackHandler": 'twittersdk://'
    }).then((credential) async {
      //Accept returned parameters
      print(credential.toString());
      user = (await _auth.signInWithCredential(credential)).user;

      userState = await saveUserData(user, authProvider: 'twitter');

      print('Done.... you are signed-in with Google authentication');
    });
    return userState;

/*
    var platform = new oauth1.Platform(
        'https://api.twitter.com/oauth/request_token', // temporary credentials request
        'https://api.twitter.com/oauth/authorize', // resource owner authorization
        'https://api.twitter.com/oauth/access_token', // token credentials request
        oauth1.SignatureMethods.hmacSha1 // signature method
        );

    // define client credentials (consumer keys)
    const String apiKey = 'O4IHRKUod4CHBb1ScjW6fh6Wi';
    const String apiSecret = 'h5nANM53WmF5vWHjZEtHTg4cYPgQqhOC8dqWp4VI1HfrthZ255';
    var clientCredentials = new oauth1.ClientCredentials(apiKey, apiSecret);

    // create Authorization object with client credentials and platform definition
    var auth = new oauth1.Authorization(clientCredentials, platform);

    // request temporary credentials (request tokens)
    auth.requestTemporaryCredentials('oob').then((res) {
      // redirect to authorization page
      print(
          "Open with your browser: ${auth.getResourceOwnerAuthorizationURI(res.credentials.token)}");
      final authorizationPage = auth.getResourceOwnerAuthorizationURI(res.credentials.token);
      final flutterWebviewPlugin = FlutterWebviewPlugin();

      flutterWebviewPlugin.launch(authorizationPage);
      // get verifier (PIN)
      var queryParameters = Uri.parse(authorizationPage).queryParameters;
      var oauthToken = queryParameters['oauth_token'];
      var oauthVerifier = queryParameters['oauth_verifier'];
      print('auth ttoken :' + oauthToken);
      print('auth verifier: ' + oauthVerifier);
      // request token credentials (access tokens)
      return auth.requestTokenCredentials(res.credentials, oauthVerifier);
    }).then((res) {
      final result = TwitterAuthProvider.getCredential(
        authToken: res.credentials.token,
        authTokenSecret: res.credentials.tokenSecret,
      );
      // get verifier (PIN)
      stdout.write("PIN: ");
      String verifier = stdin.readLineSync();

      // request token credentials (access tokens)
      return auth.requestTokenCredentials(res.credentials, verifier);
    }).then((res) {
      // yeah, you got token credentials
      // create Client object
      var client = new oauth1.Client(platform.signatureMethod, clientCredentials, res.credentials);

      // now you can access to protected resources via client
      client.get('https://api.twitter.com/1.1/statuses/home_timeline.json?count=1').then((res) {
        print(res.body);
      });

      // NOTE: you can get optional values from AuthorizationResponse object
      print("Your screen name is " + res.optionalParameters['screen_name']);
    });

    */
  }

  //sign-out with Google
  void _googleLogut() async {
    if (await _googleSignIn.isSignedIn()) {
      _googleSignIn.signOut();
      print('Done.... you are signed-out with Google');
    } else {
      print('you are not signed in google to logout');
    }
  }

  //Facebook Logout:
  void _facebookLogut() async {
    if (await _facebookLogin.isLoggedIn) {
      _facebookLogin.logOut();
      print('Done.... you are signed-out with Facebook');
    } else {
      print('you are not signed in faceboook to logout');
    }
  }

  //Twitter Logout:
  void _twitterLogut() async {
    if (await _twitterLogin.isSessionActive) {
      _twitterLogin.logOut();
      print('Done.... you are signed-out with Twitter');
    } else {
      print('you are not signed in twitter to logout');
    }
  }

  //general Logout all:
  void userLogout() {
    _auth.signOut();
    _facebookLogut();
    _twitterLogut();
    _googleLogut();
  }
}
