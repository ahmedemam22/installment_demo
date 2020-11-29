import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:installment_demo/module/userModel.dart';
import 'package:installment_demo/services/userServices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class currentUserState extends ChangeNotifier
{
  Users _users=Users();

  Users get getUser=>_users;

  FirebaseAuth _authentecation = FirebaseAuth.instance;

  Future<bool> CheckUserLoggedIn()async //To Check If User LoggedIn Or Not
  {
    bool retVal=false;
    try
    {
      User _firebaseUser=await _authentecation.currentUser;
      _users.uid=_firebaseUser.uid;
      _users.Email=_firebaseUser.email;
      retVal=true;
    }catch(e)
    {
      print(e);
    }
    return retVal;
  }

  Future<bool> signOut()async //To Signing Out
  {
    bool retVal=false;
    try
    {
      await _authentecation.signOut();
      _users=Users();
      _users.uid=null;
      _users.Email=null;
      retVal=true;
    }catch(e)
    {
      print(e);
    }
    return retVal;
  }

  Future<bool> signupUser(String email , String password , String fullname , String Validity) async //To SignUp NewUser
  {
    Users _newUser=Users();
    bool val = false;
    try
    {
      UserCredential _authResult=await _authentecation.createUserWithEmailAndPassword(email: email, password: password);
      _newUser.uid=_authResult.user.uid;
      _newUser.Email=_authResult.user.email;
      _newUser.fullName=fullname;
      _newUser.Validity=Validity;
      UserServices().createUser(_newUser);
      if (_authResult.user !=null)
      {
        val = true;
      }
    }

    catch(e)
    {
      print(e);
    }

    return val;

  }

  Future<bool> loginUser(String email , String password)async //To Login
  {
    Users _newUser=Users();
    bool val = false;
    try
    {
      UserCredential _authResult=await _authentecation.signInWithEmailAndPassword(email:email, password: password);
      if(_authResult != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('id', _authResult.user.uid.toString());
        prefs.setString('email', _authResult.user.email.toString());
        _newUser.uid = _authResult.user.uid;
        _newUser.Email = _authResult.user.email;
        DocumentSnapshot document=await FirebaseFirestore.instance.collection('users').doc(_newUser.uid).get();
        prefs.setString('name', document.data()["fullname"]);
        _newUser.fullName=document.data()["fullname"];
        print(document.data()["fullname"]);
        print("ssssssssssssss");

        val = true;
      }

    }

    catch(e)
    {
      print(e);
    }

    return val;
  }
}