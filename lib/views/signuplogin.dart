import 'package:demo_todoapp/controllers/signup_login_controller.dart';
import 'package:demo_todoapp/widgets/backgroud.dart';
import 'package:demo_todoapp/widgets/inputText.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupLogin extends StatelessWidget {
  const SignupLogin({super.key});
  @override
  Widget build(BuildContext context) {
    SignupLoginController signlogincoller = Get.put(SignupLoginController());
    return Obx(
      () => signlogincoller.isLogin.value
          ? Scaffold(
              appBar: AppBar(
                title: const Text(
                  "L O G I N",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: true,
              ),
              body: Backgroud(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        inputText(
                          keyboardType: TextInputType.emailAddress,
                          labelText: "Enter Email",
                          icons: Icons.email,
                          controller: signlogincoller.emailController,
                          check: false,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        inputText(
                          keyboardType: TextInputType.visiblePassword,
                          labelText: "Enter Password",
                          icons: Icons.password,
                          controller: signlogincoller.passwordController,
                          check: true,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: FloatingActionButton(
                            heroTag: "submit_login",
                            onPressed: () {
                              signlogincoller.OnLogin();
                            },
                            backgroundColor: Colors.white.withOpacity(0.6),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.admin_panel_settings),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  "LOGIN",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: FloatingActionButton(
                            heroTag: "change_page_signup",
                            onPressed: () {
                              signlogincoller.onChangePage();
                            },
                            backgroundColor: Colors.white.withOpacity(0.6),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.person_add_alt_rounded),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  "SIGN UP",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : Scaffold(
              appBar: AppBar(
                title: const Text(
                  "S I N G U P",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 36,
                  ),
                ),
                centerTitle: true,
              ),
              body: Backgroud(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        inputText(
                          controller: signlogincoller.nameController,
                          icons: Icons.person_outline,
                          keyboardType: TextInputType.name,
                          labelText: "Enter Name",
                          check: false,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        inputText(
                          controller: signlogincoller.emailController,
                          icons: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                          labelText: "Enter Email",
                          check: false,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        inputText(
                          controller: signlogincoller.passwordController,
                          icons: Icons.password,
                          keyboardType: TextInputType.visiblePassword,
                          labelText: "Enter Password",
                          check: true,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: FloatingActionButton(
                            heroTag: "submit_signup",
                            onPressed: () {
                              signlogincoller.OnSignUp();
                            },
                            backgroundColor: Colors.white.withOpacity(0.6),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.person_add_alt_rounded),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  "SIGN UP",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: FloatingActionButton(
                            heroTag: "change_login",
                            onPressed: () {
                              signlogincoller.onChangePage();
                            },
                            backgroundColor: Colors.white.withOpacity(0.6),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.admin_panel_settings),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  "LOGIN",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
