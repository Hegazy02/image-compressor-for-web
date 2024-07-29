import 'dart:convert';
import 'dart:html' as html;
import 'dart:js' as js;
import 'dart:typed_data';

class PickImageFromWeb {
  static Future<Uint8List?> pickFile() async {
    Uint8List? userImageByteMemory;
    html.FileReader fileReader = html.FileReader();
    final uploadInput = html.FileUploadInputElement()..accept = 'image/*';
    uploadInput.click();
    await uploadInput.onChange.first;
    html.File? file = uploadInput.files?.first;
    fileReader.readAsDataUrl(file!);
    await fileReader.onLoadEnd.first;
    String base64FileString = fileReader.result.toString().split(',')[1];
    var base64data = "data:image/png;base64,$base64FileString";

    userImageByteMemory = base64Decode(base64FileString);
    await js.context.callMethod('compressAndDownloadImage', [base64data]);
    listenToMessage(userImageByteMemory);
    return userImageByteMemory;
  }

  static listenToMessage(Uint8List? userImageByteMemory) {
    html.window.addEventListener("message", (event) {
      html.MessageEvent event2 = event as html.MessageEvent;

      userImageByteMemory = (event2.data as ByteBuffer).asUint8List();
    });
  }
}
