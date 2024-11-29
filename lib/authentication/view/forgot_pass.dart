import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mad_project/assets.dart';
import 'package:mad_project/authentication/controller/auth_controller.dart';

class Forgot extends StatelessWidget {
  Forgot({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final AuthController _authController = Get.find<AuthController>(); // Use Get.find to get the existing instance

  Future<void> _sendResetEmail() async {
    if (_formKey.currentState!.validate()) {
      await _authController.sendPasswordResetEmail(_emailController.text);
      Get.defaultDialog(
        title: 'Success',
        titlePadding: EdgeInsets.only(top: 20.0),
        titleStyle: TextStyle(
            color: Assets.primaryColor,
            fontSize: 30,
            fontWeight: FontWeight.bold),
        middleText: 'Password reset email sent.\n Please check your email.',
        middleTextStyle: TextStyle(color: Assets.lightTextColor, fontSize: 18),
        textConfirm: 'Got it!',
        confirmTextColor: Colors.white,
        buttonColor: Assets.btnBgColor,
        onConfirm: () {
          Get.back();
          Get.offNamed('/login');
        },
        barrierDismissible: false,
        contentPadding:
            EdgeInsets.only(left: 10.0, right: 10.0, bottom: 20.0, top: 10.0),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent, // No background color
          elevation: 0, // Remove the shadow
          iconTheme: IconThemeData(color: Colors.black), // Set the icon color
          leading: IconButton(
            icon: Padding(
              padding: const EdgeInsets.only(left: 6.0),
              child: const Icon(Icons.arrow_back),
            ),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Assets.backgroundImage),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Text(
                        'Forgot Password',
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Worry not we are here to help :)',
                        style: TextStyle(
                            fontSize: 16, color: Assets.lightTextColor),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelText: 'Email',
                          prefixIcon: const Icon(Icons.email_outlined),
                        ),
                        validator: _authController.validateEmail,
                      ),
                      const SizedBox(height: 10),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _sendResetEmail,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Assets.btnBgColor,
                          ),
                          child: const Text(
                            'Send Reset Email',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
