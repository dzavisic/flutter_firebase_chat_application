import 'package:flutter/material.dart';

class MessageComponent extends StatefulWidget {
  const MessageComponent({
    Key? key,
    required this.message,
    required this.timestamp,
    required this.isOwnMessage,
  }) : super(key: key);

  final String message;
  final int timestamp;
  final bool isOwnMessage;

  @override
  State<MessageComponent> createState() => _MessageComponentState();
}

class _MessageComponentState extends State<MessageComponent> {
  bool showTimestamp = false;
  late DateTime messageTimestamp;


  @override
  void initState() {
    super.initState();
    messageTimestamp = DateTime.fromMillisecondsSinceEpoch(widget.timestamp);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: widget.isOwnMessage
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
            children: [
              Flexible(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      showTimestamp = !showTimestamp;
                    });
                  },
                  child: Container(
                      padding: const EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
                      margin: EdgeInsets.only(left: widget.isOwnMessage ? 0 : 100, right: widget.isOwnMessage ? 100 : 0),
                      decoration: BoxDecoration(
                        color: widget.isOwnMessage ? showTimestamp ? Colors.blue[400] : Colors.blue : showTimestamp ? Colors.grey : Colors.grey[300],
                        borderRadius: BorderRadius.only(
                          topRight: const Radius.circular(15),
                          topLeft: const Radius.circular(15),
                          bottomLeft: Radius.circular(widget.isOwnMessage ? 2 : 15),
                          bottomRight: Radius.circular(widget.isOwnMessage ? 15 : 2),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(widget.message, style: TextStyle(color: widget.isOwnMessage ? Colors.white : Colors.black)),
                        ],
                      )
                  ),
                ),
              ),
            ],
          ),
          if (showTimestamp)
            Text(
              '${messageTimestamp.day}.${messageTimestamp.month}.${messageTimestamp.year}. ${messageTimestamp.hour}:${messageTimestamp.minute}',
              style: const TextStyle(color: Colors.grey),
            ),
        ],
      ),
    );
  }
}
