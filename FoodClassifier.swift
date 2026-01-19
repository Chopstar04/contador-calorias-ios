import UIKit
import Vision

class FoodClassifier {

    // 📊 Calorías por 100 gramos
    static let calorieDB: [String: Int] = [

        // Básicos
        "rice": 130,
        "chicken": 165,
        "beef": 250,
        "fish": 200,
        "salmon": 208,
        "egg": 155,

        // Mexicanos
        "taco": 250,
        "quesadilla": 320,
        "burrito": 450,
        "enchilada": 200,

        // Fast food
        "pizza": 266,
        "hamburger": 295,
        "fries": 312,

        // Saludable
        "salad": 50,
        "broccoli": 34,
        "avocado": 160,

        // Frutas
        "apple": 52,
        "banana": 89,
        "orange": 47
    ]

    static func detectFoods(
        from image: UIImage,
        completion: @escaping ([DetectedFood]) -> Void
    ) {

        guard let cgImage = image.cgImage else {
            completion([])
            return
        }

        let request = VNClassifyImageRequest { request, _ in
            guard let results = request.results as? [VNClassificationObservation] else {
                completion([])
                return
            }

            var detectedFoods: [DetectedFood] = []
            var used = Set<String>()

            for result in results {
                let label = result.identifier.lowercased()
                let confidence = result.confidence

                guard confidence > 0.35 else { continue }

                for (food, calories) in calorieDB {
                    if label.contains(food), !used.contains(food) {
                        used.insert(food)

                        detectedFoods.append(
                            DetectedFood(
                                name: food.capitalized,
                                caloriesPer100g: calories,
                                grams: nil,
                                confidence: confidence
                            )
                        )
                    }
                }
            }

            DispatchQueue.main.async {
                completion(detectedFoods)
            }
        }

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            try? handler.perform([request])
        }
    }
}
