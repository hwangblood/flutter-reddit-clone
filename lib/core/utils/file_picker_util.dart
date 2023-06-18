import 'package:file_picker/file_picker.dart';

class FilePickerUtil {
  const FilePickerUtil._();

  static Future<FilePickerResult?> pickImage() async {
    final image = await FilePicker.platform.pickFiles(type: FileType.image);

    return image;
  }
}
