import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:falcon/model/user_model.dart';

class AddUScreen extends StatefulWidget {
  const AddUScreen({
    Key? key,
    required this.loggedInUser,
    required this.title,
  }) : super(key: key);
  final UserModel loggedInUser;
  final String title;

  @override
  State<AddUScreen> createState() => _AddUScreenState();
}

class _AddUScreenState extends State<AddUScreen> {
  // string for displaying the error Message
  String? errorMessage;

  // our form key
  final _formKey = GlobalKey<FormState>();
  // editing Controller
  final firstNameEditingController = new TextEditingController();
  final secondNameEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final confirmPasswordEditingController = new TextEditingController();
  final indexNumberController = new TextEditingController();
  final roleController = new TextEditingController();
  final modulController = new TextEditingController();
  final batchController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    //first name field
    final firstNameField = TextFormField(
        autofocus: false,
        controller: firstNameEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("First Name cannot be Empty");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid name(Min. 3 Character)");
          }
          return null;
        },
        onSaved: (value) {
          firstNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "First Name",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: firstNameEditingController.text.length > 0
                ? IconButton(
                    onPressed: () {
                      firstNameEditingController.clear();
                      setState(() {});
                    },
                    icon: Icon(Icons.cancel, color: Colors.grey))
                : null));

    //second name field
    final secondNameField = TextFormField(
        autofocus: false,
        controller: secondNameEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Last Name cannot be Empty");
          }
          return null;
        },
        onSaved: (value) {
          secondNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Last Name",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: secondNameEditingController.text.length > 0
                ? IconButton(
                    onPressed: () {
                      secondNameEditingController.clear();
                      setState(() {});
                    },
                    icon: Icon(Icons.cancel, color: Colors.grey))
                : null));

    //email field
    final emailField = TextFormField(
        autofocus: false,
        controller: emailEditingController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Email");
          }
          // reg expression for email validation
          if (!RegExp("^[a-zA-Z0-9+_.-]+@sltc+.+ac+.lk").hasMatch(value)) {
            return ("Please Enter a valid email");
          }
          return null;
        },
        onSaved: (value) {
          firstNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Email",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: emailEditingController.text.length > 0
                ? IconButton(
                    onPressed: () {
                      emailEditingController.clear();
                      setState(() {});
                    },
                    icon: Icon(Icons.cancel, color: Colors.grey))
                : null));

    //password field
    final passwordField = TextFormField(
        autofocus: false,
        controller: passwordEditingController,
        obscureText: true,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Password is required for login");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid Password(Min. 6 Character)");
          }
        },
        onSaved: (value) {
          firstNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.vpn_key),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Password",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: passwordEditingController.text.length > 0
                ? IconButton(
                    onPressed: () {
                      passwordEditingController.clear();
                      setState(() {});
                    },
                    icon: Icon(Icons.cancel, color: Colors.grey))
                : null));
    //confirm password field
    final confirmPasswordField = TextFormField(
        autofocus: false,
        controller: confirmPasswordEditingController,
        obscureText: true,
        validator: (value) {
          if (confirmPasswordEditingController.text !=
              passwordEditingController.text) {
            return "Password don't match";
          }
          return null;
        },
        onSaved: (value) {
          confirmPasswordEditingController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.vpn_key),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Confirm Password",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: confirmPasswordEditingController.text.length > 0
                ? IconButton(
                    onPressed: () {
                      confirmPasswordEditingController.clear();
                      setState(() {});
                    },
                    icon: Icon(Icons.cancel, color: Colors.grey))
                : null));

    //modulField field
    final modulField = TextFormField(
        autofocus: false,
        controller: modulController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Module ID cannot be Empty");
          } else if ((value) != "7thModules") {
            if ((value) != "8thModules") {
              if ((value) != "null") {
                return ("Enter Valid Module ID");
              }
            }
          }
          return null;
        },
        onSaved: (value) {
          modulController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Module ID",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: modulController.text.length > 0
                ? IconButton(
                    onPressed: () {
                      modulController.clear();
                      setState(() {});
                    },
                    icon: Icon(Icons.cancel, color: Colors.grey))
                : null));

    //roleField field
    final roleField = TextFormField(
        autofocus: false,
        controller: roleController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Role cannot be Empty");
          } else if ((value) != "admin") {
            if ((value) != "student") {
              if ((value) != "lecturer") {
                return ("Enter Valid Role");
              }
            }
          }

          return null;
        },
        onSaved: (value) {
          roleController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Role",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: roleController.text.length > 0
                ? IconButton(
                    onPressed: () {
                      roleController.clear();
                      setState(() {});
                    },
                    icon: Icon(Icons.cancel, color: Colors.grey))
                : null));
    //indexNumberField field
    final indexNumberField = TextFormField(
        autofocus: false,
        controller: indexNumberController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("IndexNumber cannot be Empty");
          }
          return null;
        },
        onSaved: (value) {
          indexNumberController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "IndexNumber",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: indexNumberController.text.length > 0
                ? IconButton(
                    onPressed: () {
                      indexNumberController.clear();
                      setState(() {});
                    },
                    icon: Icon(Icons.cancel, color: Colors.grey))
                : null));

    //batchField field
    final batchField = TextFormField(
        autofocus: false,
        controller: batchController,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Batch Number cannot be Empty");
          } else if ((value) != "7") {
            if ((value) != "8") {
              if ((value) != "0") {
                return ("Enter Valid Module ID");
              }
            }
          }
          return null;
        },
        onSaved: (value) {
          batchController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Batch",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: batchController.text.length > 0
                ? IconButton(
                    onPressed: () {
                      batchController.clear();
                      setState(() {});
                    },
                    icon: Icon(Icons.cancel, color: Colors.grey))
                : null));

    //signup button
    final addButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Color(0xff0b3140),
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            AddUser(
                emailEditingController.text, passwordEditingController.text);
            AdminSignIn(
                '${widget.loggedInUser.email}', '${widget.loggedInUser.pw}');
          },
          child: Text(
            "Add User",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Row(
          children: [
            Text(widget.title),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 10),
                    firstNameField,
                    SizedBox(height: 20),
                    secondNameField,
                    SizedBox(height: 20),
                    indexNumberField,
                    SizedBox(height: 20),
                    emailField,
                    SizedBox(height: 20),
                    modulField,
                    SizedBox(height: 20),
                    roleField,
                    SizedBox(height: 20),
                    batchField,
                    SizedBox(height: 20),
                    passwordField,
                    SizedBox(height: 20),
                    confirmPasswordField,
                    SizedBox(height: 20),
                    addButton,
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void AddUser(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {postDetailsToFirestore()})
            .catchError((e) {
          Fluttertoast.showToast(msg: e!.message);
        });
        Fluttertoast.showToast(msg: "User added successfully!");

        firstNameEditingController.clear();
        secondNameEditingController.clear();
        emailEditingController.clear();
        passwordEditingController.clear();
        confirmPasswordEditingController.clear();
        indexNumberController.clear();
        roleController.clear();
        modulController.clear();
        batchController.clear();
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      }
    }
  }

  postDetailsToFirestore() async {
    // calling our firestore
    // calling our user model
    // sedning these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user2 = FirebaseAuth.instance.currentUser;

    UserModel userModel = UserModel();

    // writing all the values
    userModel.email = user2!.email;
    userModel.uid = user2.uid;
    userModel.firstName = firstNameEditingController.text;
    userModel.lastName = secondNameEditingController.text;
    userModel.module = modulController.text;
    userModel.pw = confirmPasswordEditingController.text;
    userModel.batch = int.parse(batchController.text);
    userModel.indexNo = indexNumberController.text;
    userModel.role = roleController.text;
    userModel.img = '';
    await firebaseFirestore
        .collection("users")
        .doc(user2.uid)
        .set(userModel.toMap())
        .whenComplete(() => Navigator.pop(context));
  }

  void AdminSignIn(String email, String password) async {
    User? user3 = FirebaseAuth.instance.currentUser;

    UserModel adminModel = UserModel();
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) async {
        FirebaseFirestore.instance
            .collection("users")
            .doc(user3!.uid)
            .get()
            .then((uid) {
          adminModel = UserModel.fromMap(uid.data());
        });
      });
    } on FirebaseAuthException catch (error) {
      print(error.code);
    }
  }
}
