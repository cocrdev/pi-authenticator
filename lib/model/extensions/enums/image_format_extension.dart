/*
 * privacyIDEA Authenticator
 *
 * Author: Frank Merkel <frank.merkel@netknights.it>
 *
 * Copyright (c) 2025 NetKnights GmbH
 *
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utils/logger.dart';
import '../../enums/image_format.dart';

extension ImageFormatX on ImageFormat {
  static ImageFormat fromExtensionString(String ex) => switch (ex) {
        'svg' => ImageFormat.svg,
        'svgz' => ImageFormat.svgz,
        'png' => ImageFormat.png,
        'jpg' => ImageFormat.jpg,
        'jpeg' => ImageFormat.jpeg,
        'gif' => ImageFormat.gif,
        'bmp' => ImageFormat.bmp,
        'webp' => ImageFormat.webp,
        _ => throw Exception('Unknown extension: $ex'),
      };

  Widget buildImageWidget(Uint8List imageData) => switch (this) {
        ImageFormat.svg => SvgPicture.memory(
            imageData,
            colorFilter: ColorFilter.mode(
              Colors.transparent,
              BlendMode.srcOver,
            ),
          ),
        ImageFormat.svgz => SvgPicture.memory(
            imageData,
            colorFilter: ColorFilter.mode(
              Colors.transparent,
              BlendMode.srcOver,
            ),
          ),
        ImageFormat.png => Image.memory(
            imageData,
            colorBlendMode: BlendMode.srcOver,
          ),
        ImageFormat.jpg => Image.memory(
            imageData,
            colorBlendMode: BlendMode.srcOver,
          ),
        ImageFormat.jpeg => Image.memory(
            imageData,
            colorBlendMode: BlendMode.srcOver,
          ),
        ImageFormat.gif => Image.memory(
            imageData,
            colorBlendMode: BlendMode.srcOver,
          ),
        ImageFormat.bmp => Image.memory(
            imageData,
            colorBlendMode: BlendMode.srcOver,
          ),
        ImageFormat.webp => Image.memory(
            imageData,
            colorBlendMode: BlendMode.srcOver,
          ),
      };

  Future<Size?> getImageSize(Uint8List imageData) async {
    double? width;
    double? height;
    switch (this) {
      case ImageFormat.svg:
      case ImageFormat.svgz:
        final image = SvgPicture.memory(imageData);
        width = image.width;
        height = image.height;
        break;
      // The following image formats are supported by decodeImageFromList JPEG, PNG, GIF, Animated GIF, WebP, Animated WebP, BMP, and WBMP.
      case ImageFormat.png:
      case ImageFormat.jpg:
      case ImageFormat.jpeg:
      case ImageFormat.gif:
      case ImageFormat.bmp:
      case ImageFormat.webp:
        final decodedImage = await decodeImageFromList(imageData);
        width = decodedImage.width.toDouble();
        height = decodedImage.height.toDouble();
        break;
    }
    if (width == null || height == null) {
      Logger.warning('Could not determine the size of the image.');
      return null;
    }
    return Size(width, height);
  }

  String get extension => toString().split('.').last;

  String get name => switch (this) {
        ImageFormat.svg => 'Scalable Vector Graphic',
        ImageFormat.svgz => 'Scalable Vector Graphic (compressed)',
        ImageFormat.png => 'PNG',
        ImageFormat.jpg => 'JPEG',
        ImageFormat.jpeg => 'JPEG',
        ImageFormat.gif => 'GIF',
        ImageFormat.bmp => 'Bitmap',
        ImageFormat.webp => 'WebP',
      };

  String get mimeType => switch (this) {
        ImageFormat.svg => 'image/svg+xml',
        ImageFormat.svgz => 'image/svg+xml',
        ImageFormat.png => 'image/png',
        ImageFormat.jpg => 'image/jpeg',
        ImageFormat.jpeg => 'image/jpeg',
        ImageFormat.gif => 'image/gif',
        ImageFormat.bmp => 'image/bmp',
        ImageFormat.webp => 'image/webp',
      };

  /// Builds an [XFile] from the given [imageData] and [fileName].
  /// The [fileName] is used as the name of the file.
  /// The file extension is determined by the [ImageFormat].
  XFile buildXFile(Uint8List imageData, String fileName) => XFile.fromData(imageData, name: "$fileName.$extension");

  /// Compares the given [extension] with the extension of this [ImageFormat] case-insensitive.
  bool matches(String extension) => extension.toLowerCase() == this.extension.toLowerCase();
}
