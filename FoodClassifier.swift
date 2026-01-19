import UIKit
import Vision

struct DetectedFood {
    let name: String
    let calories: Int
    let confidence: Float
}

class FoodClassifier {

    // 📊 Base de datos grande de calorías (promedios)
    static let calorieDatabase: [String: Int] = [

        // Mexicanas
        "taco": 250,
        "burrito": 450,
        "quesadilla": 320,
        "enchilada": 400,
        "chilaquiles": 420,
        "tamale": 300,
        "pozole": 350,
        "tostada": 280,
        "flauta": 330,
        "nachos": 450,

        // Fast food
        "pizza": 285,
        "hamburger": 295,
        "hot dog": 290,
        "sandwich": 260,
        "fries": 365,
        "fried chicken": 420,
        "nuggets": 270,

        // Internacional
        "pasta": 220,
        "lasagna": 410,
        "ramen": 380,
        "sushi": 200,
        "fried rice": 330,
        "rice": 205,

        // Proteínas
        "chicken": 240,
        "beef": 280,
        "steak": 300,
        "fish": 200,
        "salmon": 300,
        "egg": 155,
        "tuna": 180,

        // Saludable
        "salad": 150,
        "broccoli": 55,
        "carrot": 40,
        "lettuce": 15,
        "avocado": 160,
        "beans": 180,
        "lentils": 190,

        // Frutas
        "apple": 95,
        "banana": 105,
        "orange": 62,
        "strawberry": 50,
        "grape": 104,
        "watermelon": 85,
        "pineapple": 82,
        "mango": 135,

        // Postres
        "cake": 450,
        "donut": 300,
        "cookie": 160,
        "brownie": 370,
        "ice cream": 270,
        "churros": 300,

        // Bebidas
        "soda": 150,
        "cola": 140,
        "juice": 110,
        "coffee": 5,
        "milkshake": 350
    ]

    // 🚀 Clasificación real con Vision
    static func detectFoods(
        from image: UIImage,
        completion: @escaping ([DetectedFood], Int) -> Void
    ) {

        guard let cgImage = image.cgImage else {
            completion([], 0)
            return
        }

        let request = VNClassifyImageRequest { request, error in
            guard let results = request.results as? [VNClassificationObservation] else {
                completion([], 0)
                return
            }

            var detected: [DetectedFood] = []
            var usedLabels = Set<String>()

            for observation in results {

                let identifier = observation.identifier.lowercased()
                let confidence = observation.confidence

                // Solo tomar detecciones razonables
                guard confidence > 0.30 else { continue }

                // Buscar coincidencias en la base de datos
                for (food, calories) in calorieDatabase {

                    if identifier.contains(food),
                       !usedLabels.contains(food) {

                        usedLabels.insert(food)

                        detected.append(
                            DetectedFood(
                                name: food.capitalized,
                                calories: calories,
                                confidence: confidence
                            )
                        )
                    }
                }
            }

            let totalCalories = detected.reduce(0) { $0 + $1.calories }

            DispatchQueue.main.async {
                completion(detected, totalCalories)
            }
        }

        request.usesCPUOnly = false

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])

        DispatchQueue.global(qos: .userInitiated).async {
            try? handler.perform([request])
        }
    }
}
