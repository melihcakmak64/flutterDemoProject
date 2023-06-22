import 'package:demo/model/Model.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class ApiController extends GetxController {
  Dio dio = Dio();
  final RxList<Model> _toDoList = <Model>[].obs;

  RxList<Model> getList() {
    if (_toDoList.isEmpty) {
      getData();
    }
    return _toDoList;
  }

  void getData() async {
    var data = await dio.get("https://jsonplaceholder.typicode.com/photos");
    for (int i = 0; i < 4; i++) {
      _toDoList.add(Model.fromJson(data.data[i]));
    }
  }

  Future<bool> postData(String title) async {
    try {
      Model model = Model(
          albumId: 1,
          title: title,
          url: 'https://example.com/test.jpg',
          thumbnailUrl: 'https://example.com/test-thumbnail.jpg');
      var response = await dio.post(
        "https://jsonplaceholder.typicode.com/photos/",
        data: model.toJson(),
      );

      if (response.statusCode == 201) {
        _toDoList.add(model);

        return true;
      }
    } catch (e) {
      print('An error occurred: $e');
    }
    return false;
  }

  int getSize() {
    return _toDoList.length;
  }
}
