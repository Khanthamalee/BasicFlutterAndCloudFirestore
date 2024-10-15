import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DisPlayScreen extends StatefulWidget {
  const DisPlayScreen({super.key});

  @override
  State<DisPlayScreen> createState() => _DisPlayScreenState();
}

class _DisPlayScreenState extends State<DisPlayScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("รายงานคะแนนสอบ"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("students").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('ยังไม่มีข้อมูลค่ะ..');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
              children: snapshot.data!.docs.map(
            (document) {
              return ListTile(
                leading: CircleAvatar(
                    radius: 30,
                    child: FittedBox(
                      child: Text(document["score"] ?? "-"),
                    )),
                title:
                    Text(document["firstName"] + document["lastName"] ?? "-"),
                subtitle: Text(document["email"] ?? "-"),
              );
            },
          ).toList());
        },
      ),
    );
  }
}
