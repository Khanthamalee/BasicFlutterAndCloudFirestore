import 'package:basicff/model/student.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final formKey = GlobalKey<FormState>();
  Studentdata student = Studentdata();
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  CollectionReference _studentCollection =
      FirebaseFirestore.instance.collection("students");
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebase,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
                toolbarHeight: 500,
                title: Text(
                  "Error ${snapshot.error}",
                  maxLines: 10,
                )),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
              appBar: AppBar(
                title: const Text("แบบฟอร์มบันทึกคะแนนสอบ"),
                backgroundColor: Colors.greenAccent,
              ),
              body: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.white,
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        //FirstName
                        TextFormField(
                            decoration: const InputDecoration(
                                icon: Icon(Icons.person_2_rounded),
                                labelText: "ชื่อ *"),
                            onSaved: (firstName) {
                              student.firstName = firstName;
                            },
                            validator: RequiredValidator(
                                    errorText: "กรุณากรอกชื่อนักเรียน")
                                .call),
                        const SizedBox(
                          height: 10,
                        ),
                        //LastName
                        TextFormField(
                            decoration: const InputDecoration(
                                icon: Icon(Icons.family_restroom_rounded),
                                labelText: "นามสกุล *"),
                            onSaved: (lastName) {
                              student.lastName = lastName;
                            },
                            validator: RequiredValidator(
                                    errorText: "กรุณากรอกนามสกุลนักเรียน")
                                .call),
                        const SizedBox(
                          height: 10,
                        ),
                        //Email
                        TextFormField(
                          decoration: const InputDecoration(
                              icon: Icon(Icons.email_rounded),
                              labelText: "อีเมลล์ *"),
                          onSaved: (email) {
                            student.email = email;
                          },
                          validator: MultiValidator([
                            EmailValidator(
                                errorText: "รูปแบบอีเมลล์ต้องมี '@'"),
                            RequiredValidator(
                                errorText: "กรุณากรอกอีเมลล์นักเรียน")
                          ]).call,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        //Score
                        TextFormField(
                          decoration: const InputDecoration(
                              icon: Icon(Icons.score_rounded),
                              labelText: "คะแนน *"),
                          onSaved: (score) {
                            student.score = score;
                          },
                          validator: RequiredValidator(
                                  errorText: "กรุณากรอกคะแนนนักเรียน")
                              .call,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        //Save Button
                        SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: ElevatedButton(
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    formKey.currentState?.save();
                                    await _studentCollection.add({
                                      "firstName": student.firstName,
                                      "lastName": student.lastName,
                                      "email": student.email,
                                      "score": student.score,
                                    });
                                    formKey.currentState?.reset();
                                  }

                                  print("Firstname : ${student.firstName}");
                                  print("Lastname : ${student.lastName}");
                                  print("Email : ${student.email}");
                                  print("Score : ${student.score}");
                                },
                                child: const Text("บันทึกข้อมูล")))
                      ],
                    ),
                  ),
                ),
              ));
        }
        return Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
