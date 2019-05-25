import 'package:flutter/material.dart';
import 'package:project/db/userDB.dart';



class RegisterPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return RegisterPageState();
  }

}

class RegisterPageState extends State<RegisterPage>{
  final _formkey = GlobalKey<FormState>();

  UserUtils user = UserUtils();
  final userid = TextEditingController();
  final name = TextEditingController();
  final age = TextEditingController();
  final password = TextEditingController();
  final repassword = TextEditingController();
  final quote = TextEditingController();

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
        title: Text("Register"),
      ),
      body: Form(
        key: _formkey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 15, 30, 0),
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: "User Id",
                icon: Icon(Icons.account_box, size: 40, color: Colors.grey),
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
                  return "Uesr นี้ชื่ออยู่ในระบบแล้ว";
                }
              }
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Name",
                icon: Icon(Icons.account_circle, size: 40, color: Colors.grey),
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
                icon: Icon(Icons.event_note, size: 40, color: Colors.grey),
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
                icon: Icon(Icons.lock, size: 40, color: Colors.grey),
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
            
            Padding(padding: EdgeInsets.fromLTRB(0, 15, 0, 10)),
            RaisedButton(
              child: Text("REGISTER NEW ACCOUNT"),
              onPressed: () async {
                await user.open("user.db");
                Future<List<User>> allUser = user.getAllUser();
                User userData = User();
                userData.userid = userid.text;
                userData.name = name.text;
                userData.age = age.text;
                userData.password = password.text;

                
                Future isNewUserIn(User user) async {
                  var userList = await allUser;
                  for(var i=0; i < userList.length;i++){
                    if (user.userid == userList[i].userid){
                      this.isUserIn = true;
                      break;
                    }
                  }
                }

                
                await isNewUserIn(userData);
                print(this.isUserIn);

                if (_formkey.currentState.validate()){
                                  
                  if(await !this.isUserIn) {
                    userid.text = "";
                    name.text = "";
                    age.text = "";
                    password.text = "";
                    repassword.text = "";
                    await user.insertUser(userData);
                    Navigator.pop(context);
                    print('insert complete');
                  }
                }

                this.isUserIn = false;

                Future showAllUser() async {
                  var userList = await allUser;
                  for(var i=0; i < userList.length;i++){
                    print(userList[i]);
                    }
                  }

                showAllUser();
              }
              
            ),
          ],
        ),
      ),
    );
  }
}