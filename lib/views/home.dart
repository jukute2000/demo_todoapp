import 'package:demo_todoapp/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.put(HomeController());

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: const Text("TODO APP"),
          centerTitle: true,
        ),
        drawer: Drawer(
          backgroundColor: Colors.white,
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text("${homeController.userN}"),
                accountEmail: Text("${homeController.user.email}"),
                currentAccountPicture: const Icon(
                  Icons.account_circle,
                  size: 80,
                ),
                otherAccountsPictures: [
                  PopupMenuButton(
                    color: Colors.white.withOpacity(0.6),
                    icon: const Icon(Icons.menu),
                    onSelected: (value) {
                      if (value == "Update") {
                        homeController.movePageUpdateInfomationUser();
                      } else {
                        homeController.logout();
                      }
                    },
                    itemBuilder: (context) {
                      return [
                        const PopupMenuItem(
                          value: "Update",
                          child: Row(
                            children: [
                              Icon(Icons.system_update),
                              SizedBox(
                                width: 8,
                              ),
                              Text("Update infomation user")
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: "Logout",
                          child: Row(
                            children: [
                              Icon(Icons.logout),
                              SizedBox(
                                width: 8,
                              ),
                              Text("Logout")
                            ],
                          ),
                        ),
                      ];
                    },
                  )
                ],
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage("assets/images/football.jpg"),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Colors.white.withOpacity(0.8), BlendMode.dstATop),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.upload),
                title: Text("Upload Video"),
                onTap: () {
                  Get.toNamed("/video");
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.upload),
                title: Text("Upload Image"),
                onTap: () => Get.toNamed("/image"),
              ),
            ],
          ),
        ),
        body: Visibility(
          visible: homeController.isLoading.value,
          replacement: RefreshIndicator(
            onRefresh: () => homeController.getItems(),
            child: ListView.builder(
              itemCount: homeController.items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(homeController.items[index].name),
                  subtitle: Text(homeController.items[index].number),
                  trailing: PopupMenuButton(
                    onSelected: (value) {
                      if (value == "Delete") {
                        homeController
                            .deleteItem(homeController.itemsId[index]);
                      } else {
                        homeController.movePage(
                          homeController.items[index].name,
                          homeController.items[index].number,
                          homeController.itemsId[index],
                        );
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: "Delete",
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text("Delete Item")
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                          value: "Edit",
                          child: Row(
                            children: [
                              Icon(
                                Icons.edit,
                                color: Colors.yellow,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text("Edit Item")
                            ],
                          )),
                    ],
                  ),
                );
              },
            ),
          ),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white.withOpacity(0.8),
          onPressed: () {
            Get.toNamed("/add")?.then(
              (value) {
                if (value) {
                  homeController.getItems();
                }
              },
            );
          },
          shape: const CircleBorder(),
          child: const Icon(
            Icons.add,
            color: Colors.black,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        bottomNavigationBar: BottomAppBar(
          color: Colors.white30,
          child: Container(
            padding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }
}
