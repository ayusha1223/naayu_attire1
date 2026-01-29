import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:naayu_attire1/core/services/storage/token_service.dart';
import 'package:provider/provider.dart';

class ImageService {
  final Dio dio;

  ImageService(this.dio);

  Future<String> uploadImage({
    required BuildContext context,
    required File imageFile,
  }) async {
    final tokenService = context.read<TokenService>();
    final token = tokenService.getToken();

    if (token == null) {
      throw Exception("User not logged in");
    }

    final formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(imageFile.path),
    });

    final response = await dio.post(
      "http://192.168.1.91:3000/api/v1/students/upload-image",
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
