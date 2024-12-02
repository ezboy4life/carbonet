import 'dart:convert';
import 'dart:typed_data';
import 'package:carbonet/utils/logger.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
const String apiKey = "Mc7R5SUh.VNGX4zZvcG9H68TArkoBzt4MHJ1eUHi2";

class FoodvisorVision {
  Future<AnalysisResults?> analyseImage(Uint8List imageBytes) async {
    var headers = {
      'Authorization': 'Api-Key $apiKey'
    }; 

    var request = http.MultipartRequest('POST', Uri.parse('https://vision.foodvisor.io/api/1.0/en/analysis'));

    // mágica ✨
    var dt = DateTime.now();
    request.files.add(
      http.MultipartFile.fromBytes(
        'image', 
        imageBytes,
        filename: '${dt.year}-${dt.month}-${dt.day}_${dt.hour}h${dt.minute}m${dt.second}s_image.jpg',
        contentType: MediaType('image', 'jpg'),
      )
    );

    request.headers.addAll(headers);
    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final str = await response.stream.bytesToString();
        print(str);
        return AnalysisResults.fromJson(str);
      }
      else {
        print(response.reasonPhrase);
        return null;
      }
    } catch (error) {
      errorLog(error.toString());
      print(error);
      return null;
    }
    
  }
}

class AnalysisResults {
  final List<AnalysisItem> items = [];
  
  static AnalysisResults fromJson(String str) {
    AnalysisResults results = AnalysisResults();
    Map<String, dynamic> json = jsonDecode(str);

    for (Map<String, dynamic> item in json['items']) {
      var analysisItem = AnalysisItem(
          posX: item['position']['x'], 
          posY: item['position']['y'], 
          width: item['position']['width'], 
          height: item['position']['height']
        );

      for (Map<String, dynamic> food in item['food']) {
        var foodItem = FoodItem(
          confidence: food['confidence'], 
          quantity: food['quantity'], 
          foodId: food['food_info']['food_id'], 
          foodName: food['food_info']['display_name'], 
          gPerServing: food['food_info']['g_per_serving'], 
          calories100g: food['food_info']['nutrition']['calories_100g'], 
          carbs100g: food['food_info']['nutrition']['carbs_100g']
        );
        if (foodItem.confidence > 0.0) {
          analysisItem.foods.add(foodItem);
        }
      }
        
      results.items.add(analysisItem);
    }

    return results;
  }
}

class AnalysisItem {
  final double posX;
  final double posY;
  final double width;
  final double height;
  final List<FoodItem> foods = [];

  AnalysisItem({required this.posX, required this.posY, required this.width, required this.height});
}

class FoodItem {
  final double confidence;
  final double quantity;
  final String foodId;
  final String foodName;
  final double gPerServing;
  final double calories100g;
  final double carbs100g;

  FoodItem({required this.confidence, required this.quantity, required this.foodId, required this.foodName, required this.gPerServing, required this.calories100g, required this.carbs100g});

  FoodItem copyWith({ double? confidence, double? quantity, String? foodId, String? foodName, double? gPerServing, double? calories100g, double? carbs100g}) {
    return FoodItem(
      confidence: confidence ?? this.confidence,
      quantity: quantity ?? this.quantity,
      foodId: foodId ?? this.foodId,
      foodName: foodName ?? this.foodName,
      gPerServing: gPerServing ?? this.gPerServing,
      calories100g: calories100g ?? this.calories100g,
      carbs100g: carbs100g ?? this.carbs100g,
    );
  }
}