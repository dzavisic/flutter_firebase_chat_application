import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_application/src/shared/widgets/verticalSpacing.widget.dart';

class ParticipantInfoComponent extends StatefulWidget {
  const ParticipantInfoComponent({
    Key? key,
    required this.participantUser
  }) : super(key: key);

  final Map<String, dynamic> participantUser;

  @override
  State<ParticipantInfoComponent> createState() => _ParticipantInfoComponentState();
}

class _ParticipantInfoComponentState extends State<ParticipantInfoComponent> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${widget.participantUser['firstName']} ${widget.participantUser['lastName']}'),
        ),
        body: body()
    );
  }

  Widget body() {
    return SingleChildScrollView(
      child: Column(
        children: [
          verticalSpacing(50),
          avatar(),
          verticalSpacing(50),
          inputField('Email', widget.participantUser['email'], false),
          verticalSpacing(10),
          inputField('Phone Number', widget.participantUser['phone'], true),
        ],
      ),
    );
  }

  Widget avatar() {
    if (widget.participantUser['photo'].isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: CircleAvatar(
          radius: 80,
          backgroundImage: NetworkImage(widget.participantUser['photo']),
        ),
      );
    }
    return const Padding(
      padding: EdgeInsets.only(left: 15.0),
      child: CircleAvatar(
        radius: 80,
        backgroundImage: AssetImage('assets/img/avatar.png'),
      ),
    );
  }

  Widget inputField(String label, String controller, bool disableEdit) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          verticalSpacing(10),
          TextField(
            controller: TextEditingController(text: controller),
            enabled: false,
            decoration: InputDecoration(
              suffix: disableEdit ? const Icon(Icons.verified, color: Colors.orange) : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          )
        ],
      ),
    );
  }
}
