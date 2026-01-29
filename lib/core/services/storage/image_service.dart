import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'token_service.dart';

class ImageService {
  final Dio _dio;

  ImageService(this._dio);

  Future<String> uploadImage({
    required BuildContext context,
    required File imageFile,
  }) async {
    // 🔐 Get token
    final tokenService =
        Provider.of<TokenService>(context, listen: false);
    final token = tokenService.getToken();

    if (token == null) {
      throw Exception("User not logged in");
    }

    // 📦 Prepare form data
    final formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(
        imageFile.path,
        filename: imageFile.path.split('/').last,
      ),
    });

    // 🚀 Upload image
    final response = await _dio.post(
      "http://10.0.2.2:3000/api/v1/students/upload-image",
      data: formData,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "multipart/form-data",
        },
      ),
    );

    return response.data["imageUrl"];
  }
}
