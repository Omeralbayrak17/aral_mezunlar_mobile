import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class ImageGallerySaverExtension{
  static void saveImageToGallery(BuildContext context, String imageUrl) async {
    try {

      ByteData byteData = await NetworkAssetBundle(Uri.parse(imageUrl)).load('');
      List<int> imageData = byteData.buffer.asUint8List();
      await ImageGallerySaver.saveImage(Uint8List.fromList(imageData));

    } catch (e) {
      return;
    }
  }
}
