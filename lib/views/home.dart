import 'package:demo_todoapp/controllers/home_controller.dart';
import 'package:demo_todoapp/models/item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.put(HomeController());
    final size = MediaQuery.of(context).size;
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: const Text("TODO APP"),
          centerTitle: true,
          actions: [
            Obx(
              () => IconButton(
                  onPressed: () {
                    homeController.changeView();
                  },
                  icon: Icon(homeController.isView.value
                      ? Icons.menu
                      : Icons.apps_outlined)),
            )
          ],
        ),
        drawer: Drawer(
          backgroundColor: Colors.white,
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                accountName:
                    Text("${homeController.auth.currentUser?.displayName}"),
                accountEmail: Text("${homeController.auth.currentUser!.email}"),
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
            child: homeController.isView.value
                ? ListView.builder(
                    itemCount: homeController.items.length,
                    itemBuilder: (context, index) {
                      Item item = homeController.items[index];
                      return ListTile(
                        leading: const Icon(Icons.abc),
                        title: Text(item.name),
                        subtitle: Text(item.detail),
                        trailing: PopupMenuButton(
                          onSelected: (value) {
                            if (value == "Delete") {
                              homeController.deleteItem(
                                  homeController.itemsId[index],
                                  item.imagePart.split("/").last);
                            } else {
                              homeController.movePage(
                                  item.name,
                                  item.detail,
                                  homeController.itemsId[index],
                                  item.imagePart,
                                  item.imagePartDowload);
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
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 500,
                    ),
                    itemCount: homeController.items.length,
                    itemBuilder: (context, index) {
                      Item item = homeController.items[index];
                      return Card(
                        margin: EdgeInsets.all(16),
                        elevation: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Container(
                                height: size.height / 5,
                                width: size.width / 1.5,
                                child: Image(
                                  image: NetworkImage(item.imagePartDowload),
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                              Divider(
                                height: 18,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Name:",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(item.name),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Detail:",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(item.detail),
                                ],
                              ),
                              Divider(
                                height: 18,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    width: size.width / 3,
                                    child: TextButton(
                                      onPressed: () {
                                        homeController.movePage(
                                          item.name,
                                          item.detail,
                                          homeController.itemsId[index],
                                          item.imagePart,
                                          item.imagePartDowload,
                                        );
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.edit,
                                            color: Colors.yellow,
                                          ),
                                          Text(
                                            "Edit Item",
                                            style:
                                                TextStyle(color: Colors.yellow),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Container(
                                    width: size.width / 3,
                                    child: TextButton(
                                      onPressed: () {
                                        homeController.deleteItem(
                                          homeController.itemsId[index],
                                          item.imagePart.split("/").last,
                                        );
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            "Delete Item",
                                            style: TextStyle(color: Colors.red),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
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
