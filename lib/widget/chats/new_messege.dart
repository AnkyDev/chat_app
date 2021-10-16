import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessege extends StatefulWidget {
  const NewMessege({Key? key}) : super(key: key);

  @override
  _NewMessegeState createState() => _NewMessegeState();
}

class _NewMessegeState extends State<NewMessege> {
  final mrcontroller = new TextEditingController();
  var _newMessege = '';

  void _sendMessege() {
    final user = FirebaseAuth.instance.currentUser;
    final userOrName =
        FirebaseFirestore.instance.collection('users').doc(user?.uid).get();
    FocusScope.of(context).unfocus();
    FirebaseFirestore.instance.collection('chats').add({
      'text': _newMessege,
      'createdAt': Timestamp.now(),
      'userName': user!.uid,
      //'userOrig': userOrName,
    });
    mrcontroller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: mrcontroller,
              decoration: InputDecoration(labelText: 'Send Messege'),
              onChanged: (value) {
                setState(() {
                  _newMessege = value;
                });
              },
            ),
          ),
          IconButton(
            onPressed: _newMessege.trim().isEmpty ? null : _sendMessege,
            icon: Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
