import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'dart:math' as math;

class ProductARScreen extends ConsumerStatefulWidget {
  final String url;
  const ProductARScreen({super.key, required this.url});

  @override
  ConsumerState<ProductARScreen> createState() => _ProductStateARScreen();
}

class _ProductStateARScreen extends ConsumerState<ProductARScreen> {
  late ARKitController arKitController;
  ARKitNode? imgNode;
  double size = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AR View'),
      ),
      body: Stack(
        children: [
          ARKitSceneView(
            // onARKitViewCreated: onARKitViewCreated,
            onARKitViewCreated: (controller) {},
            worldAlignment: ARWorldAlignment.camera,
            // enablePinchRecognizer: true,
            // configuration: ARKitConfiguration.imageTracking,
          ),
          Column(
            children: [
              const SizedBox(height: 100),
              CachedNetworkImage(
                imageUrl: widget.url,
                height: size,
                width: size,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              const Spacer(),
              Slider(
                value: size,
                onChanged: (double value) {
                  setState(() {
                    size = value;
                  });
                },
                min: 100,
                max: 360,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }

  void onARKitViewCreated(ARKitController arKitController) {
    this.arKitController = arKitController;
    this.arKitController.onNodePinch = (pinch) => _onPinchHandler(pinch);
    // addNode();
  }

  void addNode() {
    final material = ARKitMaterial(
      lightingModelName: ARKitLightingModel.physicallyBased,
      diffuse: ARKitMaterialProperty.color(
        Color((math.Random().nextDouble() * 0xFFFFFF).toInt() << 0)
            .withOpacity(1.0),
      ),
    );

    // final arImg =

    final box =
        ARKitBox(materials: [material], width: 0.1, height: 0.1, length: 0.1);

    final node = ARKitNode(
      geometry: box,
      position: vector.Vector3(0, 0, -0.5),
    );
    arKitController.add(node);
    imgNode = node;
  }

  void _onPinchHandler(List<ARKitNodePinchResult> pinch) {
    final pinchNode = pinch.firstWhere(
      (e) => e.nodeName == imgNode?.name,
    );
    if (pinchNode != null) {
      final scale = vector.Vector3.all(pinchNode.scale);
      imgNode?.scale = scale;
    }
  }
}
