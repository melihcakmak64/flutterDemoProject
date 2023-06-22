// ignore: file_names
import 'package:demo/controller/Controller.dart';
import 'package:demo/view/consants/Colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiController controller = Get.put(ApiController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorPalet.backgroundColor,
        body: Container(
          margin: EdgeInsets.only(top: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              getHeader(),
              getSizedBox(15),
              imageBox("assets/cd_icon.png", 150),
              getSizedBox(15),
              searchBar(),
              listBuilder(controller: controller)
            ],
          ),
        ),
      ),
    );
  }
}

class listBuilder extends StatelessWidget {
  const listBuilder({
    super.key,
    required this.controller,
  });

  final ApiController controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(
        () => ListView.builder(
          itemCount: controller.getList().length,
          itemBuilder: (context, index) {
            return Card(
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                    controller.getList()[index].thumbnailUrl ?? "",
                  ),
                  child: Image.network(
                    controller.getList()[index].thumbnailUrl ?? "",
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      return FlutterLogo(); // Display FlutterLogo as fallback
                    },
                  ),
                ),
                title: Text(controller.getList()[index].title ?? ""),
                trailing: IconButton(
                  icon: (index != controller.getSize() - 1)
                      ? (const Icon(Icons.check))
                      : const Icon(Icons.add),
                  onPressed: () async {
                    String? title = await _showInputDialog(context);

                    if (title != null) {
                      bool? result = await controller.postData(title);
                      if (result == true) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(customSnackBar());
                      }
                    }
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

Container getHeader() {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
        color: ColorPalet.backgroundColor,
        borderRadius: BorderRadius.circular(18)),
    child: const Text(
      "Add Comments",
      textAlign: TextAlign.center,
      style: TextStyle(
          color: Colors.black, fontSize: 23, fontWeight: FontWeight.bold),
    ),
  );
}

Container imageBox(String path, double height) {
  return Container(
    decoration: BoxDecoration(
        color: ColorPalet.imageBackgroundColor,
        borderRadius: BorderRadius.circular(18)),
    height: height,
    child: Image.asset(path),
  );
}

SizedBox getSizedBox(double height) {
  return SizedBox(
    height: height,
  );
}

SnackBar customSnackBar() {
  return SnackBar(
    backgroundColor: ColorPalet.snackBarColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text(
          'New comment was added!',
          style: TextStyle(color: Colors.black),
        ),
        Icon(Icons.check_circle)
      ],
    ),
  );
}

Future<String?> _showInputDialog(BuildContext context) async {
  String? enteredText = '';

  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Type below'),
        content: Card(
          color: ColorPalet.cardColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                enteredText = value;
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: '  Comment',
              ),
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(enteredText);
            },
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(15), // Set the border radius
                ),
                backgroundColor:
                    ColorPalet.buttonColor // Set the background color
                ),
            child: const Text('Add'),
          ),
        ],
      );
    },
  );
}

Container searchBar() {
  return Container(
      child: const ListTile(
    leading: Icon(Icons.search),
    title: TextField(
      onChanged: null,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Comment',
      ),
    ),
  ));
}
