import 'dart:io';
import 'package:camera/camera.dart';
import 'package:carbonet/utils/app_colors.dart';
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
        return TakePictureScreen(cameraF: snapshot.data!.last, cameraB: snapshot.data!.first,);
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
    required this.cameraF,
    required this.cameraB
  });

  final CameraDescription cameraF;
  final CameraDescription cameraB;

  @override
  State<TakePictureScreen> createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controllerF;
  late CameraController _controllerB;
  late Future<void> _initializeControllerFuture;
  final ValueNotifier<bool> isFrontCamera = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();

    _controllerF = CameraController(
      widget.cameraF,
      ResolutionPreset.medium,
    );

    _controllerB = CameraController(
      widget.cameraB,
      ResolutionPreset.medium,
    );

    // inicializar o controller é necessário p/ usar a câmera p/ mostrar previews e tirar fotos
    _initializeControllerFuture = initControllers();
  }

  Future<void> initControllers() async {
    _initializeControllerFuture = _controllerF.initialize();
    _initializeControllerFuture = _controllerB.initialize();
  }

  @override
  void dispose() {
    // dar fim no controller qdo o widget for destruído
    _controllerF.dispose();
    _controllerB.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // futurebuilder p/ esperar o controller inicializar
    return Scaffold(
      appBar: AppBar(title: const Text('Tire uma foto'),),
      body: FutureBuilder(future: _initializeControllerFuture, builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ValueListenableBuilder(
            valueListenable: isFrontCamera, builder: (context, value, child) {
              return CameraPreview(isFrontCamera.value ? _controllerF : _controllerB);
            }
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              isFrontCamera.value = !isFrontCamera.value;
            },
            child: const Icon(Icons.flip_camera_android),
          ),
          const SizedBox(height: 12,),
          FloatingActionButton(
            onPressed: () async {
              // foto dentro do bloco try/catch :)
              try {
                await _initializeControllerFuture;
          
                //tenta tirar uma foto e pega o arquivo onde ela foi salva
                final image = await _controllerF.takePicture();
          
                if (!context.mounted) return;
          
                // se a foto foi tirada, exibir em uma nova página
                // user pode re-tirar a foto, ou continuar; isso devolve um valor; se não vier valor, o usuário deu um back e a gente não faz nada :D
                var value = await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => DisplayPictureScreen(
                    imagePath: image.path,
                  ))
                );
          
                if (value == null) {return;}
                else if (value == true) { // continue
                print("value: ${value}");
                    // aqui dentro: levantar o "cortar" do pacote crop_your_image.
          
                }
          
              } catch (e) {
                print(e);
              }
            },
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