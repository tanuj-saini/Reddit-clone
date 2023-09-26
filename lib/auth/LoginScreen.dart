import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/auth/userContoller.dart';
import 'package:reddit/utils/themeColor.dart';

class LoginScreen extends ConsumerStatefulWidget {
  LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() {
    return _LoginScreen();
  }
}

class _LoginScreen extends ConsumerState<LoginScreen> {
  void googleSignInbutton(){
    ref.watch(authContoller).signInWIthGoogle(context);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: CircleAvatar(
          child: Image.asset('assets/images/logo.png'),
          radius: 15,
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text("Skip"),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                'Dive into anything',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(
                height: 15,
              ),
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 10 / 9,
                    child: Image.asset('assets/images/loginEmote.png'),
                  ),
                  Positioned(
                      child:
                          IconButton(onPressed: () {}, icon: Icon(Icons.add)))
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton.icon(
                  onPressed: () {googleSignInbutton();
                    
                  },
                  icon: CircleAvatar(
                    child: Image.asset('assets/images/google.png'),
                    radius: 15,
                  ),
                  label: Text(
                    "Continue with Google",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Pallete.greyColor.withOpacity(1)),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20.0), // Adjust the value as needed
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
