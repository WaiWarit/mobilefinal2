import 'package:flutter/material.dart';
import 'package:project/db/userDB.dart';
import 'package:project/utils/currentUser.dart';


class ProfilePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return ProfilePageState();
  }

}

class ProfilePageState extends State<ProfilePage>{
  final _formkey = GlobalKey<FormState>();

  UserUtils user = UserUtils();
  final userid = TextEditingController(text: CurrentUser.USERID);
  final name = TextEditingController(text: CurrentUser.NAME);
  final age = TextEditingController(text: CurrentUser.AGE);
  final password = TextEditingController();
  final quote = TextEditingController(text: CurrentUser.QUOTE);

  bool isUserIn = false;

  bool isNumeric(String s) {
    if(s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  int countSpace(String s){
    int result = 0;
    for(int i = 0;i<s.length;i++){
      if(s[i] == ' '){
        result += 1;
      }
    }
    return result;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Setup"),
      ),
      body: Form(
        key: _formkey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 15, 30, 0),
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: "User Id",
              ),
              controller: userid,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value.isEmpty) {
                  return "Please fill out this form";
                }
                else if (value.length < 6 || value.length > 12){
                  return "User Id ต้องอยู่ระหว่าง 6 - 12 ตัวอักษร";
                }
                else if (this.isUserIn){
                  return "Uesr นี้มีชื่ออยู่ในระบบแล้ว";
                }
              }
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Name",
              ),
              controller: name,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value.isEmpty) {
                  return "Please fill out this form";
                }
                if(countSpace(value) != 1){
                  return "กรุณาระบุชื่อ นามสกุล";
                }
              }
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Age",
              ),
              controller: age,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value.isEmpty) {
                  return "Please fill Age";
                }
                else if (!isNumeric(value) || int.parse(value) < 10 || int.parse(value) > 80) {
                  return "ต้องอยู่ในช่วง 10 - 80 ปี";
                }
              }
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Password",
              ),
              controller: password,
              obscureText: true,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value.isEmpty || value.length <= 6) {
                  return "Password ต้องมีความยาวมากกว่า 6 ตัวอักษร";
                }
              }
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Quote",
              ),
              controller: quote,
              keyboardType: TextInputType.text,
              maxLines: 5
            ),
            Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10)),
            RaisedButton(
              child: Text("SAVE"),
              onPressed: () async {
                await user.open("user.db");
                Future<List<User>> allUser = user.getAllUser();
                User userData = User();
                userData.id = CurrentUser.ID;
                userData.userid = userid.text;
                userData.name = name.text;
                userData.age = age.text;
                userData.password = password.text;
                userData.quote = quote.text;
                
                Future isUserTaken(User user) async {
                  var userList = await allUser;
                  for(var i=0; i < userList.length;i++){
                    if (user.userid == userList[i].userid && CurrentUser.ID != userList[i].id){
                      this.isUserIn = true;
                      break;
                    }
                  }
                }
                
                if (_formkey.currentState.validate()){
                  await isUserTaken(userData);
                  print(this.isUserIn);
                  
                  if(!this.isUserIn) {
                    await user.updateUser(userData);
                    CurrentUser.USERID = userData.userid;
                    CurrentUser.NAME = userData.name;
                    CurrentUser.AGE = userData.age;
                    CurrentUser.PASSWORD = userData.password;
                    CurrentUser.QUOTE = userData.quote;
                    Navigator.pop(context);
                    
                  }
                }

                this.isUserIn = false;
              }
            ),
          ]
        ),
      )
    );
  }

}