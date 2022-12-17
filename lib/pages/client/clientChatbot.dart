import 'package:flutter/material.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../utils/SnackBarHelper.dart';

class clientChatbot extends StatefulWidget {
  @override
  _clientChatbotState createState() => _clientChatbotState();
}

class _clientChatbotState extends State<clientChatbot> {
  late DialogFlowtter dialogFlowtter;
  final TextEditingController messageController = TextEditingController();

  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    DialogFlowtter.fromFile().then((instance) => dialogFlowtter = instance);
  }

  @override
  Widget build(BuildContext context) {
    //var themeValue = MediaQuery.of(context).platformBrightness;
    var themeValue = Brightness.dark;
    return Scaffold(
      backgroundColor: themeValue == Brightness.dark
          ? HexColor('#262626')
          : HexColor('#FFFFFF'),
      appBar: AppBar(
        backgroundColor: themeValue == Brightness.dark
            ? HexColor('#3C3A3A')
            : HexColor('#BFBFBF'),
        title: Text(
          'Chat Bot',
          style: TextStyle(
              color:
              themeValue == Brightness.dark ? Colors.white : Colors.black),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: Body(messages: messages)),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: messageController,
                      style: TextStyle(
                          color: themeValue == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                          fontFamily: 'Poppins'),
                      decoration: new InputDecoration(
                        enabledBorder: new OutlineInputBorder(
                            borderSide: new BorderSide(
                                color: themeValue == Brightness.dark
                                    ? Colors.white
                                    : Colors.black),
                            borderRadius: BorderRadius.circular(15)),
                        hintStyle: TextStyle(
                          color: themeValue == Brightness.dark
                              ? Colors.white54
                              : Colors.black54,
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                        ),
                        labelStyle: TextStyle(
                            color: themeValue == Brightness.dark
                                ? Colors.white
                                : Colors.black),
                        hintText: 'Send a message',
                      ),
                    ),
                  ),
                  IconButton(
                    color: themeValue == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                    icon: Icon(Icons.send),
                    onPressed: () {
                      sendMessage(messageController.text);
                      messageController.clear();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void sendMessage(String text) async {
    if (text.isEmpty) return;
    setState(() {
      addMessage(
        Message(text: DialogText(text: [text])),
        true,
      );
    });
    try {
      //region DetectIntentResponse
      // DetectIntentResponse response = await dialogFlowtter.detectIntent(
      //   queryInput: QueryInput(text: TextInput(text: text)),
      // );
      //
      // if (response.message == null) return;
      // setState(() {
      //   addMessage(response.message!);
      // });
      //endregion

      await Future.delayed(Duration(seconds: 1));
      setState(() {
        addMessage(Message(text: DialogText(text: ['กรุณารอสักครู่...'])),
            false);
      });
      await Future.delayed(Duration(seconds: 3));

      String bot_message = "รูปแบบข้อความไม่ถูกต้อง";
      if (text == "รพ" || text == "โรงพยาบาล" || text.contains('โรงพยาบาล') || text.contains('รพ')) {
        bot_message = "โรงพยาบาลที่อยู่ใกล้คุณ..";
        bot_message += "\n1.) โรงพยาบาลกรุงเทพ\n2.) โรงพยาบาลพญาไท 3\n3.) โรงพยาบาลมิตรประชา";
      }
      else if (text == "สถานที่ท่องเที่ยว" || text == "ท่องเที่ยว" || text.contains('เที่ยว')) {
        bot_message = "สถานที่ท่องเที่ยวใกล้คุณ..";
        bot_message += "\n1.) Seacon Bangkae\n2.) เดอะมอลล์บางแค\n3.) เดอะมอลล์ท่าพระ";
      }
      setState(() {
        addMessage(Message(text: DialogText(text: [bot_message])),
            false);
      });
    }
    catch (error) {
      Alert.show(context: context, msg: error.toString());
    }
  }
  
  

  void addMessage(Message message, [bool isUserMessage = false]) {
    messages.add({
      'message': message,
      'isUserMessage': isUserMessage,
    });
  }

  @override
  void dispose() {
    dialogFlowtter.dispose();
    super.dispose();
  }
}

class Body extends StatelessWidget {
  final List<Map<String, dynamic>> messages;

  const Body({
    Key? key,
    this.messages = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, i) {
        var obj = messages[messages.length - 1 - i];
        Message message = obj['message'];
        bool isUserMessage = obj['isUserMessage'] ?? false;
        return Row(
          mainAxisAlignment:
          isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _MessageContainer(
              message: message,
              isUserMessage: isUserMessage,
            ),
          ],
        );
      },
      separatorBuilder: (_, i) => Container(height: 10),
      itemCount: messages.length,
      reverse: true,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 20,
      ),
    );
  }
}

class _MessageContainer extends StatelessWidget {
  final Message message;
  final bool isUserMessage;

  const _MessageContainer({
    Key? key,
    required this.message,
    this.isUserMessage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 250),
      child: LayoutBuilder(
        builder: (context, constrains) {
          return Container(
            decoration: BoxDecoration(
              color: isUserMessage ? Colors.blue : Colors.grey[800],
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(10),
            child: Text(
              message.text?.text?[0] ?? '',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}