import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mad_project/assets.dart';
import 'package:mad_project/authentication/controller/auth_controller.dart';

class Register extends StatelessWidget {
  Register({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final AuthController _authController = Get.find<AuthController>();
  final RxBool isLoading = false.obs;

  Future<void> _register(BuildContext context) async {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      try {
        isLoading.value = true;

        // Query Firestore to check if email exists
        final QuerySnapshot result = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: _emailController.text)
            .limit(1)
            .get();

        if (result.docs.isNotEmpty) {
          // Email exists in Firestore
          Get.snackbar(
            'Error',
            'This email is already registered. Please use a different email.',
            backgroundColor: Colors.red[100],
            colorText: Colors.red[900],
            duration: const Duration(seconds: 3),
          );
          return;
        }

        // Email doesn't exist, proceed to profile creation
        Get.toNamed('registerProfile', parameters: {
          'email': _emailController.text,
          'password': _passwordController.text,
        });
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to check email: ${e.toString()}',
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
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
                        'Register',
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Assets.primaryColor),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Good to see you back!',
                        style: TextStyle(
                            fontSize: 16, color: Assets.lightTextColor),
                      ),
                      const SizedBox(height: 50),
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
                      const SizedBox(height: 20),
                      Obx(() {
                        return TextFormField(
                          controller: _passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: !_authController.isPasswordVisible.value,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _authController.isPasswordVisible.value
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                              onPressed: () {
                                _authController.isPasswordVisible.toggle();
                              },
                            ),
                          ),
                          validator: _authController.validatePassword,
                        );
                      }),
                      const SizedBox(height: 20),
                      Obx(() {
                        return TextFormField(
                          controller: _confirmPasswordController,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText:
                              !_authController.isConfirmPasswordVisible.value,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelText: 'Confirm Password',
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _authController.isConfirmPasswordVisible.value
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                              onPressed: () {
                                _authController.isConfirmPasswordVisible
                                    .toggle();
                              },
                            ),
                          ),
                          validator: (value) =>
                              _authController.validateConfirmPassword(
                                  value, _passwordController.text),
                        );
                      }),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: Obx(() => ElevatedButton(
                              onPressed: isLoading.value
                                  ? null
                                  : () => _register(context),
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
                                      'Register',
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white),
                                    ),
                            )),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () {
                            Get.offNamed('/login');
                          },
                          child: const Text(
                            'Already have account?',
                            style: TextStyle(
                                color: Assets.lightTextColor, fontSize: 16),
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
