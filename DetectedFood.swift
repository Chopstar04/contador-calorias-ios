import Foundation

struct DetectedFood: Identifiable {
    let id = UUID()
    let name: String
    let caloriesPer100g: Int
    var grams: Double?   // 👈 opcional
    let confidence: Float

    // 🧮 Calorías calculadas
    var calculatedCalories: Int {
        if let grams = grams {
            return Int((Double(caloriesPer100g) / 100.0) * grams)
        } else {
            // Porción promedio si no pone gramos (100g)
            return caloriesPer100g
        }
    }
}
