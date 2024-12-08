import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mad_project/assets.dart';
import 'package:mad_project/authentication/controller/auth_controller.dart';

class Forgot extends StatelessWidget {
  Forgot({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final AuthController _authController = Get.find<AuthController>();
  final RxBool isLoading = false.obs;

  Future<void> _sendResetEmail(BuildContext context) async {
    // Hide keyboard
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      try {
        isLoading.value = true;
        await _authController.sendPasswordResetEmail(_emailController.text);

        Get.defaultDialog(
          title: 'Success!',
          titlePadding: const EdgeInsets.only(top: 25.0),
          titleStyle: const TextStyle(
            color: Assets.primaryColor,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          content: Column(
            children: [
              const Icon(
                Icons.mark_email_read_outlined,
                size: 70,
                color: Assets.primaryColor,
              ),
              const SizedBox(height: 15),
              const Text(
                'Password reset email sent',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please check your inbox and follow\nthe instructions in the email',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Assets.lightTextColor,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
          confirm: SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: () {
                Get.back();
                Get.offNamed('/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Assets.btnBgColor,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Back to Login',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
          barrierDismissible: false,
          radius: 12,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
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
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Worry not we are here to help :)',
                        style: TextStyle(
                          fontSize: 16,
                          color: Assets.lightTextColor,
                        ),
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
                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: Obx(() => ElevatedButton(
                              onPressed: isLoading.value
                                  ? null
                                  : () => _sendResetEmail(context),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: Assets.btnBgColor,
                              ),
                              child: isLoading.value
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    )
                                  : const Text(
                                      'Send Reset Email',
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white),
                                    ),
                            )),
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
