import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FaceAuthService {
  final ImagePicker picker = ImagePicker();

  /// Quick unlock: re-opens the session of an already signed-in Firebase user
  /// when a face is in front of the camera. It detects a face, it does not
  /// identify a person, so it never replaces the email/password login.
  Future<bool> verifyFace() async {
    final prefs = await SharedPreferences.getInstance();
    if (!(prefs.getBool("face_enabled") ?? false)) return false;
    if (FirebaseAuth.instance.currentUser == null) return false;

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

    return faces.isNotEmpty;
  }
}