import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FaceAuthService {
  final ImagePicker picker = ImagePicker();

  Future<bool> verifyFace() async {
    final XFile? image =
    await picker.pickImage(source: ImageSource.camera);

    if (image == null) return false;

    final inputImage =
    InputImage.fromFilePath(image.path);

    final faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableClassification: true,
        performanceMode: FaceDetectorMode.accurate,
      ),
    );

    final faces =
    await faceDetector.processImage(inputImage);

    await faceDetector.close();

    // simple rule: at least 1 face detected
    if (faces.isEmpty) return false;

    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("face_enabled") ?? false;
  }
}