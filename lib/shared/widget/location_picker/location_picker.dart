import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutterx/core.dart';
import 'package:permission_handler/permission_handler.dart';

class ExLocationPicker extends StatefulWidget {
  final String id;
  final String? label;
  final double? latitude;
  final double? longitude;

  ExLocationPicker({
    required this.id,
    this.label,
    this.latitude,
    this.longitude,
  });

  @override
  _ExLocationPickerState createState() => _ExLocationPickerState();
}

class _ExLocationPickerState extends State<ExLocationPicker> {
  @override
  void initState() {
    super.initState();
    if (widget.latitude == null && widget.longitude == null) {
      Input.set("${widget.id}_latitude", null);
      Input.set("${widget.id}_longitude", null);
    } else {
      Input.set("${widget.id}_latitude", widget.latitude);
      Input.set("${widget.id}_longitude", widget.longitude);
    }
  }

  bool isLocationPicked() {
    if (Input.get("${widget.id}_latitude") != null &&
        Input.get("${widget.id}_longitude") != null) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 6.0, bottom: 4.0),
      padding: EdgeInsets.all(10.0),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 4.0,
              right: 4.0,
            ),
            child: Text(
              (widget.label ?? "Select Location"),
              style: TextStyle(
                fontSize: 10.0,
              ),
            ),
          ),
          SizedBox(
            height: 4.0,
          ),
          if (!isLocationPicked())
            ExButton(
              label: "Select Location",
              color: disabledColor,
              icon: Icons.add_location,
              height: md,
              onPressed: () async {
                if (Platform.isAndroid || Platform.isIOS) {
                  if (await Permission.location.request().isGranted) {
                    await Get.to(
                      ExLocationPickerMapView(
                        id: widget.id,
                      ),
                    );
                    setState(() {});
                  }
                  return;
                }

                await Get.to(
                  ExLocationPickerMapView(
                    id: widget.id,
                  ),
                );
                setState(() {});
              },
            ),
          if (isLocationPicked())
            ExButton(
              label: "You've picked your location",
              fontSize: 10.0,
              color: primaryColor,
              icon: Icons.add_location,
              onPressed: () async {
                await Get.to(
                  ExLocationPickerMapView(
                    id: widget.id,
                    latitude: Input.get("${widget.id}_latitude"),
                    longitude: Input.get("${widget.id}_longitude"),
                  ),
                );
                setState(() {});
              },
            ),
        ],
      ),
    );
  }
}
