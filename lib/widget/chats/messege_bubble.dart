import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BubbleChat extends StatelessWidget {
  final String messege;
  final bool isMe;
  final String userId;
  BubbleChat(this.messege, this.isMe, this.userId);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
            decoration: BoxDecoration(
              color: isMe ? Colors.grey[300] : Theme.of(context).accentColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(12),
                bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
              ),
            ),
            width: 140,
            margin: EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 8,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .get(),
                  builder: (BuildContext ctx, fsnapShot) {
                    if (fsnapShot.connectionState == ConnectionState.waiting) {
                      return Text('...Loading');
                    }
                    return Text(
                      fsnapShot.data?['username'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isMe
                            ? Colors.black
                            : Theme.of(context)
                                .accentTextTheme
                                .headline6!
                                .color,
                      ),
                    );
                  },
                ),
                Text(
                  messege,
                  style: TextStyle(
                    color: isMe
                        ? Colors.black
                        : Theme.of(context).accentTextTheme.headline6!.color,
                  ),
                  textAlign: isMe ? TextAlign.end : TextAlign.start,
                ),
              ],
            )),
      ],
    );
  }
}
