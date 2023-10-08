import 'package:get/get.dart';

class PagesController extends GetxController {
  RxInt currentPage = 0.obs;

  void changePage() {
    if (currentPage.value == 0) {
      currentPage.value = 1;
    } else {
      currentPage.value = 0;
    }
  }
}
