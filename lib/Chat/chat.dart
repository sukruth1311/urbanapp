import 'dart:io';
import 'dart:typed_data';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final Gemini gemini = Gemini.instance;

  List<ChatMessage> messages = [];

  ChatUser currentUser = ChatUser(id: "0", firstName: "User");
  ChatUser geminiUser = ChatUser(
    id: "1",
    firstName: "Plant Doctor by DoctorBabu",
    profileImage: "",
    // "https://seeklogo.com/images/G/google-gemini-logo-A5787B2669-seeklogo.com.png",
  );

  XFile? _pickedImage;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 244, 238, 218),
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromRGBO(88, 140, 108,1)),
        useMaterial3: true,
      ),
      home: Scaffold(
        
        appBar: AppBar(
          leading: const BackButton(color: Color.fromARGB(255, 243, 153, 153)),
          centerTitle: true,
          title: Text(
            "Plant Doctor",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Color.fromRGBO(88, 140, 108,1),
        ),
        body: Column(
          children: [
            if (_pickedImage != null) _buildImageThumbnail(),
            Expanded(child: _buildChat()),
          ],
        ),
      ),
    );
  }

  Widget _buildImageThumbnail() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Stack(
        children: [
          Image.file(
            File(_pickedImage!.path),
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: Icon(Icons.cancel, color: Colors.red),
              onPressed: () {
                setState(() {
                  _pickedImage = null;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChat() {
    return DashChat(
      inputOptions: InputOptions(
        
        trailing: [
          IconButton(
            onPressed: _showImagePickerOptions,
            icon: const Icon(Icons.image),
          )
        ],
      ),
      currentUser: currentUser,
      onSend: _sendMessage,
      messages: messages,
      
    );
  }

  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
    });

    try {
      String question = chatMessage.text;
      List<Uint8List>? images;
      if (_pickedImage != null) {
        images = [File(_pickedImage!.path).readAsBytesSync()];

        // Add image to the message
        chatMessage.medias = [
          ChatMedia(
            url: _pickedImage!.path,
            fileName: "",
            type: MediaType.image,
          ),
        ];

        _pickedImage = null; // Reset the picked image after sending
      }

      gemini.streamGenerateContent(
        question,
        images: images,
      ).listen((event) {
        ChatMessage? lastMessage = messages.firstOrNull;
        if (lastMessage != null && lastMessage.user == geminiUser) {
          lastMessage = messages.removeAt(0);
          String response = event.content?.parts?.fold(
                  "", (previous, current) => "$previous ${current.text}") ??
              "";
          lastMessage.text += response;
          setState(
            () {
              messages = [lastMessage!, ...messages];
            },
          );
        } else {
          String response = event.content?.parts?.fold(
                  "", (previous, current) => "$previous ${current.text}") ??
              "";
          ChatMessage message = ChatMessage(
            user: geminiUser,
            createdAt: DateTime.now(),
            text: response,
          );
          setState(() {
            messages = [message, ...messages];
          });
        }
      });
    } catch (e) {
      print(e);
    }
  }

  void _showImagePickerOptions() async {
    final ImagePicker picker = ImagePicker();

    // Show a dialog with options to capture or pick an image
    final selectedOption = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
            "Choose option",
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        actions: <Widget>[
          Row(
            children: [
          //     TextButton(
          //       child: Text('Capture Image'),
          //       onPressed: () {
          //         Navigator.pop(context, 1); // Capture image
          //       },
          //     ),
          //      TextButton(
          //   child: Text('Pick Image from Gallery'),
          //   onPressed: () {
          //     Navigator.pop(context, 2); // Pick from gallery
          //   },
          // ),
           ElevatedButton(
                        onPressed: (){
                          Navigator.pop(context, 1);
                        },
                        
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(88, 140, 108, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          'Capture',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 50,),
                      ElevatedButton(
                        onPressed: (){
                          Navigator.pop(context, 2);
                        },
                        
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(88, 140, 108, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          'Upload',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
            ],
          ),
         
        ],
      ),
    );

    if (selectedOption == null) return;

    XFile? file;
    if (selectedOption == 1) {
      // Capture image
      file = await picker.pickImage(source: ImageSource.camera);
    } else if (selectedOption == 2) {
      // Pick image from gallery
      file = await picker.pickImage(source: ImageSource.gallery);
    }

    if (file != null) {
      setState(() {
        _pickedImage = file;
      });
    }
  }
}
