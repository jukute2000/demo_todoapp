import 'package:demo_todoapp/controllers/signup_login_controller.dart';
import 'package:demo_todoapp/widgets/backgroud.dart';
import 'package:demo_todoapp/widgets/inputText.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupLogin extends StatelessWidget {
  const SignupLogin({super.key});
  @override
  Widget build(BuildContext context) {
    SignupLoginController signloginconller = Get.put(SignupLoginController());
    return Obx(
      () => signloginconller.isLogin.value
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
                          controller: signloginconller.emailController,
                          check: false,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        inputText(
                          keyboardType: TextInputType.visiblePassword,
                          labelText: "Enter Password",
                          icons: Icons.password,
                          controller: signloginconller.passwordController,
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
                              signloginconller.OnLogin();
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
                              signloginconller.onChangePage();
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
                        Padding(
                          padding: EdgeInsets.all(25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Divider(
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                "Or Continue With",
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 8,
                              height: MediaQuery.of(context).size.height / 16,
                              child: FloatingActionButton(
                                backgroundColor: Colors.white.withOpacity(0.6),
                                onPressed: () {
                                  signloginconller.OnLoginGoogle();
                                },
                                child: Image(
                                  image: AssetImage(
                                    "assets/images/google.png",
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 8,
                              height: MediaQuery.of(context).size.height / 16,
                              child: FloatingActionButton(
                                backgroundColor: Colors.white.withOpacity(0.6),
                                onPressed: () {
                                  signloginconller.OnLoginFacebook();
                                },
                                child: Image(
                                  image: AssetImage(
                                    "assets/images/facebook.png",
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
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
                          controller: signloginconller.nameController,
                          icons: Icons.person_outline,
                          keyboardType: TextInputType.name,
                          labelText: "Enter Name",
                          check: false,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        inputText(
                          controller: signloginconller.emailController,
                          icons: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                          labelText: "Enter Email",
                          check: false,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        inputText(
                          controller: signloginconller.passwordController,
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
                              signloginconller.OnSignUp();
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
                              signloginconller.onChangePage();
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
