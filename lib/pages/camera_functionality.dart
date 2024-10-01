import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:carbonet/utils/app_colors.dart';
import 'package:carbonet/utils/static_image_holder.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';

class BaseCameraScreen extends StatefulWidget {
  const BaseCameraScreen({super.key});

  @override
  State<BaseCameraScreen> createState() => _BaseCameraScreenState();
}

class _BaseCameraScreenState extends State<BaseCameraScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsFlutterBinding.ensureInitialized();
    cameras = availableCameras();
  }

  late Future<List<CameraDescription>> cameras;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: cameras, builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        return TakePictureScreen(cameras: snapshot.data!);
      } else {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    });
  }
}

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.cameras,
  });

  final List<CameraDescription>? cameras;

  @override
  State<TakePictureScreen> createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _cameraController;
  bool _isRearCameraSelected = true;
  Uint8List? croppedImage;

  Future initCamera(CameraDescription cd) async {
    _cameraController = CameraController(
      cd, ResolutionPreset.medium
    );
    try {
      await _cameraController.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    } catch (e) {
      debugPrint("camera error: $e");
    }
  }

  Future takePicture() async {
    if (!_cameraController.value.isInitialized) {return;}
    if (_cameraController.value.isTakingPicture) {return;}
    try {
      await _cameraController.setFlashMode(FlashMode.off);
      XFile picture = await _cameraController.takePicture();

      // se a foto foi tirada, exibir em uma nova página
      // user pode re-tirar a foto, ou continuar; isso devolve um valor; se não vier valor, o usuário deu um back e a gente não faz nada :D
      if (!mounted) return;
      var value = await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => DisplayPictureScreen(
          imagePath: picture.path,
        ))
      );

      if (value == null) {return;}
      else if (value == true) { // continue
        // aqui dentro: levantar o "cortar" do pacote crop_your_image.
        CropController _controllerCrop = CropController();
        if (!mounted) return;
        await Navigator.of(context).push(MaterialPageRoute(builder: (context) => Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 550,
                  child: Crop(
                    controller: _controllerCrop,
                    aspectRatio: 1,
                    image: File(picture.path).readAsBytesSync(),
                    onCropped: (value) {
                      croppedImage = value;
                      StaticImageHolder.image = value;
                      Navigator.of(context).pop(); // coloquei aqui.
                    },
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    _controllerCrop.crop();
                    //dois fixes: esperar uns dois segundos, ou colocar o pop dentro do OnCropped.
                    
                  }, 
                  label: const Text("Salvar"),
                  icon: const Icon(Icons.save ),)
              ],
            ),
          ),
        )));

        if (!mounted) return;
        debugPrint("is mounted; popping.");
        Navigator.pop(context, croppedImage);
      }
    } on CameraException catch (e) {
      debugPrint("Error ocurred while taking picture: $e");
      return;
    }
  }

  @override
  void initState() {
    super.initState();

    initCamera(widget.cameras![0]);
  }

  @override
  void dispose() {
    // dar fim no controller qdo o widget for destruído
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // futurebuilder p/ esperar o controller inicializar
    return Scaffold(
      appBar: AppBar(title: const Text('Tire uma foto'),),
      body: SafeArea(
        child: _cameraController.value.isInitialized
          ? CameraPreview(_cameraController)
          : const Center( child: CircularProgressIndicator(), ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "btnFlip",
            onPressed: () {
              setState(() {
                _isRearCameraSelected = !_isRearCameraSelected;
                initCamera(widget.cameras![_isRearCameraSelected ? 0 : 1]);
              });
            },
            child: const Icon(Icons.flip_camera_android),
          ),
          const SizedBox(height: 12,),
          FloatingActionButton(
            heroTag: "btnShoot",
            onPressed: takePicture,
            child: const Icon(Icons.camera_alt),
            ),
        ],
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  const DisplayPictureScreen({super.key, required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("uau imagem")),
      body: Column(
        children: [
          Image.file(File(imagePath)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                label: const Text("Refazer", style: TextStyle(color: Colors.black)),
                icon: const Icon(Icons.replay, color: Colors.black),
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.error
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              const SizedBox(width: 12,),
              TextButton.icon(
                label: const Text("Ok", style: TextStyle(color: Colors.black)),
                icon: const Icon(Icons.check, color: Colors.black),
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.brightGreen
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}