import 'package:chat_app/widget/chats/messege_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messeges extends StatefulWidget {
  const Messeges({Key? key}) : super(key: key);

  @override
  _MessegesState createState() => _MessegesState();
}

class _MessegesState extends State<Messeges> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: Future.value(FirebaseAuth.instance.currentUser),
      builder: (BuildContext ctx, AsyncSnapshot<User> futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('chats')
                .orderBy(
                  'createdAt',
                  descending: true,
                )
                .snapshots(),
            builder:
                (BuildContext ctx, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
              if (chatSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final chatDocs = chatSnapshot.data?.docs;
              return ListView.builder(
                reverse: true,
                itemCount: chatDocs!.length,
                itemBuilder: (ctx, index) => BubbleChat(
                  chatDocs[index]['text'],
                  chatDocs[index]['userName'] == futureSnapshot.data?.uid,
                  chatDocs[index]['userName']
                ),
              );
            });
      },
    );
  }
}
