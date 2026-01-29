import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'token_service.dart';

class ImageService {
  final Dio dio;

  ImageService(this.dio);

  Future<String> uploadImage(
    BuildContext context,
    File image,
  ) async {
    final tokenService =
        Provider.of<TokenService>(context, listen: false);

    final token = tokenService.getToken();

    if (token == null) {
      throw Exception("User not logged in");
    }

    FormData formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(image.path),
    });

    final response = await dio.post(
      "http://10.0.2.2:3000/api/v1/students/upload-image",
      data: formData,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    return response.data["imageUrl"];
  }
}
