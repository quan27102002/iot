import 'dart:developer';


import 'package:esp_smartconfig/esp_smartconfig.dart';

import 'package:flutter/material.dart';

import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../dialog/loading_dialog.dart';
import '../../dialog/msg_dilog.dart';

class ConfigWifiPage extends StatefulWidget {
  const ConfigWifiPage({super.key});

  @override
  State<ConfigWifiPage> createState() => _ConfigWifiPageState();
}

class _ConfigWifiPageState extends State<ConfigWifiPage> {
  final TextEditingController textWifiNameController = TextEditingController();
  final TextEditingController textWifiBSSIDController = TextEditingController();
  final TextEditingController textWifiPasswordController =
      TextEditingController();
  NetworkInfo networkInfo = NetworkInfo();
  String? wifiName;
  String? wifiBSSID;
  bool showPassword = false;
  
  void send() async {
    final provisioner = Provisioner.espTouch();
    bool isSuccess = false;
    provisioner.listen((response) {
      log(response.bssidText);
      isSuccess = true; // Đánh dấu là thành công khi có response
      print("Device ($response) is connected to WiFi!");
      LoadingDialog.hideLoadingDialog(context);
      MsgDialog.showMsgDialog(context, "", "Config Success");
    });

    await provisioner.start(ProvisioningRequest.fromStrings(
      ssid: textWifiNameController.text,
      bssid: textWifiBSSIDController.text,
      password: textWifiPasswordController.text,
    ));
    LoadingDialog.showLoadingDialog(context, "Loading...");
    await Future.delayed(Duration(seconds: 30));

    provisioner.stop();

    if (!isSuccess) {
      LoadingDialog.hideLoadingDialog(context);
      MsgDialog.showMsgDialog(context, "",
          "Somthing Wrong. Please try agian"); // Hiển thị thông báo lỗi nếu không có response
    }
  }

  void initState() {
    super.initState();
    permissionHandler();
    getNetworkInfo();
  }

  Future<void> permissionHandler() async {
    final status = await Permission.location.status;

    if (!status.isGranted) {
      final permissionStatus = await Permission.location.request();

      if (permissionStatus.isGranted) {
        // Xử lý khi quyền được cấp
        // Lấy thông tin mạng
        getNetworkInfo();
      } else {
        // Xử lý khi quyền bị từ chối
      }
    } else {
      // Xử lý khi quyền đã được cấp từ trước
      // Lấy thông tin mạng
      getNetworkInfo();
    }
  }

  // permissionHandler() async{
  //   await Permission.location.status.then(value) async{
  //     if(!value.isGranted){
  //       await Permission.location.request().then(value){
  //         //network info
  //         getNetworkInfo();
  //       };
  //     }
  //   };
  // }
  getNetworkInfo() async {
    wifiName = await networkInfo.getWifiName();
    wifiBSSID = await networkInfo.getWifiBSSID();
    String tmpWifiName = '$wifiName';
    int len = tmpWifiName.length;
    tmpWifiName = tmpWifiName.substring(1, len - 1);
    tmpWifiName = tmpWifiName.replaceAll('"', ''); // Loại bỏ hai dấu nháy kép
    log('wifi name = $wifiName, wifi bssid = $wifiBSSID');
    textWifiNameController.text =
        '$tmpWifiName'; // Sử dụng biến tmpWifiName đã chỉnh sửa
    textWifiBSSIDController.text = '$wifiBSSID';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
        constraints: BoxConstraints.expand(),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 70,
              ),
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 0),
                ),
                child: Image.asset(
                  "assets/images/wifirouter.png",
                  fit: BoxFit.contain,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 6),
                child: Text(
                  "Let's config wifi for your router",
                  style: TextStyle(fontSize: 22, color: Color(0xff333333)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 20),
                child: TextField(
                  controller: textWifiNameController,
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  decoration: InputDecoration(
                      labelText: "Name",
                      prefixIcon: Container(
                          width: 50,
                          child: Image.asset("assets/images/ic_wifi.png")),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xffCED0D2), width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(6)))),
                ),
              ),
              TextField(
                controller: textWifiBSSIDController,
                style: TextStyle(fontSize: 18, color: Colors.black),
                decoration: InputDecoration(
                    labelText: "BSSID",
                    prefixIcon: Container(
                        width: 50,
                        child: Image.asset("assets/images/ic_bssid.png")),
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xffCED0D2), width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(6)))),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 20),
                child: TextField(
                  controller: textWifiPasswordController,
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  obscureText:
                      !showPassword, // Sử dụng trạng thái của biến showPassword để hiện/ẩn mật khẩu
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: Container(
                      width: 50,
                      padding: EdgeInsets.all(16),
                      child: Image.asset(
                        "assets/images/ic_lockbold.jpg",
                        fit: BoxFit.contain,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(showPassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          showPassword =
                              !showPassword; // Khi nhấn vào nút, thay đổi trạng thái của biến showPassword
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xffCED0D2), width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 40),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                      onPressed: () {
                        send();
                      },
                      child: Text(
                        "Config",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent[700],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}