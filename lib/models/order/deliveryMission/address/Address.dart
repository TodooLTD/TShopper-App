import 'package:flutter/cupertino.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import '../../../../constants/AppColors.dart';
import '../../../../constants/AppFontSize.dart';

class Address {
  final String addressType;
  final String apartment;
  final String deliveryInstruction;
  final String buildingNumber;
  final String entrance;
  final String floor;
  final String id;
  final String country;
  final double latitude;
  final double latitudeOnMap;
  final double longitude;
  final double longitudeOnMap;
  final String fullAddress;
  final String name;
  final String town;
  final String workArea;

  Address({
    this.addressType = "OTHER",
    this.apartment = "",
    this.deliveryInstruction = "",
    this.entrance = "",
    this.floor = "",
    this.id = "-1",
    required this.country,
    required this.fullAddress,
    required this.buildingNumber,
    required this.latitude,
    required this.latitudeOnMap,
    required this.longitude,
    required this.longitudeOnMap,
    required this.name,
    required this.town,
    required this.workArea,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json['id'] ?? "",
    name: json['name'] ?? "",
    country: json['country'] ?? "",
    fullAddress: json['fullAddress'] ?? "",
    addressType: json['addressType'] ?? "",
    floor: json['floor'] ?? "",
    apartment: json['apartment'] ?? "",
    buildingNumber: json['buildingNumber'] ?? "",
    entrance: json['entrance'] ?? "",
    deliveryInstruction: json['deliveryInstruction'] ?? "",
    latitude: json['latitude']?.toDouble() ?? 0.0,
    longitude: json['longitude']?.toDouble() ?? 0.0,
    latitudeOnMap: json['latitudeOnMap']?.toDouble() ?? 0.0,
    longitudeOnMap: json['longitudeOnMap']?.toDouble() ?? 0.0,
    workArea: json['workArea'] ?? "",
    town: json['town'] ?? "",
  );

  get address {
    String address = fullAddress + "\n";
    if(buildingNumber != ''){
      address = address + "מס׳ בניין: " + buildingNumber;
    }
    if(entrance != ''){
      address = address + " כניסה: " + entrance;
    }
    if(floor != ''){
      address = address + " קומה: " + floor;
    }
    if(apartment != ''){
      address = address + " דירה: " + apartment;
    }
    if(deliveryInstruction != ''){
      address = address + " הערות: " + deliveryInstruction;
    }
    return address;
  }

  List<TextSpan> getFormattedAddress(String customerName) {
    List<TextSpan> spans = [];

    spans.add(
      TextSpan(
        text: fullAddress + "\n",
        style: TextStyle(
          fontFamily: 'arimo',
          fontSize: 14.dp,
          color: AppColors.blackText,
          fontWeight: FontWeight.w900,
        )
      ),
    );

    if (buildingNumber.isNotEmpty) {
      spans.addAll([
        TextSpan(
          text: "מס׳ בניין: ",
          style: TextStyle(
            fontFamily: 'arimo',
            color: AppColors.blackText,
            fontSize: AppFontSize
                .fontSizeExtraSmall,
            fontWeight: FontWeight.w800,
          )
        ),
        TextSpan(
          text: buildingNumber + "  ",
            style: TextStyle(
              fontFamily: 'arimo',
              color: AppColors.blackText,
              fontSize: AppFontSize
                  .fontSizeExtraSmall,
              fontWeight: FontWeight.w400,
            )
        ),
      ]);
    }

    if (entrance.isNotEmpty) {
      spans.addAll([
         TextSpan(
          text: "כניסה: ",
            style: TextStyle(
              fontFamily: 'arimo',
              color: AppColors.blackText,
              fontSize: AppFontSize
                  .fontSizeExtraSmall,
              fontWeight: FontWeight.w800,
            )        ),
        TextSpan(
          text: entrance + "  ",
            style: TextStyle(
              fontFamily: 'arimo',
              color: AppColors.blackText,
              fontSize: AppFontSize
                  .fontSizeExtraSmall,
              fontWeight: FontWeight.w400,
            )        ),
      ]);
    }

    if (floor.isNotEmpty) {
      spans.addAll([
         TextSpan(
          text: "קומה: ",
            style: TextStyle(
              fontFamily: 'arimo',
              color: AppColors.blackText,
              fontSize: AppFontSize
                  .fontSizeExtraSmall,
              fontWeight: FontWeight.w800,
            )        ),
        TextSpan(
          text: floor + "  ",
            style: TextStyle(
              fontFamily: 'arimo',
              color: AppColors.blackText,
              fontSize: AppFontSize
                  .fontSizeExtraSmall,
              fontWeight: FontWeight.w400,
            )        ),
      ]);
    }

    if (apartment.isNotEmpty) {
      spans.addAll([
         TextSpan(
          text: "דירה: ",
            style: TextStyle(
              fontFamily: 'arimo',
              color: AppColors.blackText,
              fontSize: AppFontSize
                  .fontSizeExtraSmall,
              fontWeight: FontWeight.w800,
            )        ),
        TextSpan(
          text: apartment + "  ",
            style: TextStyle(
              fontFamily: 'arimo',
              color: AppColors.blackText,
              fontSize: AppFontSize
                  .fontSizeExtraSmall,
              fontWeight: FontWeight.w400,
            )        ),
      ]);
    }

    // if (deliveryInstruction.isNotEmpty) {
    //   spans.addAll([
    //     TextSpan(
    //       text: "הערות: ",
    //         style: TextStyle(
    //           fontFamily: 'arimo',
    //           color: AppColors.blackText,
    //           fontSize: AppFontSize
    //               .fontSizeExtraSmall,
    //           fontWeight: FontWeight.w800,
    //         )
    //     ),
    //     TextSpan(
    //       text: deliveryInstruction,
    //         style: TextStyle(
    //           fontFamily: 'arimo',
    //           color: AppColors.blackText,
    //           fontSize: AppFontSize
    //               .fontSizeExtraSmall,
    //           fontWeight: FontWeight.w400,
    //         ),
    //     ),
    //   ]);
    // }
    return spans;
  }

  @override
  String toString() {
    return 'Address(id: $id, name: $name, country: $country, fullAddress: $fullAddress, addressType: $addressType, floor: $floor, apartment: $apartment, deliveryInstruction: $deliveryInstruction, latitude: $latitude, longitude: $longitude, entrance: $entrance)';
  }
}