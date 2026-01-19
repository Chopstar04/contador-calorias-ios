import SwiftUI

struct ContentView: View {

    @State private var foods: [DetectedFood] = []
    @State private var mostrarCamara = false

    var totalCalories: Int {
        foods.reduce(0) { $0 + $1.calculatedCalories }
    }

    var body: some View {
        NavigationView {
            VStack {

                Text("Calorías estimadas")
                    .font(.largeTitle)
                    .bold()

                List {
                    ForEach($foods) { $food in
                        VStack(alignment: .leading, spacing: 6) {

                            Text(food.name)
                                .font(.headline)

                            Text("Confianza: \(Int(food.confidence * 100))%")

                            HStack {
                                Text("Gramos (opcional):")
                                TextField("ej. 150", value: $food.grams, format: .number)
                                    .keyboardType(.numberPad)
                                    .textFieldStyle(.roundedBorder)
                                    .frame(width: 80)
                            }

                            Text("Calorías: \(food.calculatedCalories) kcal")
                                .foregroundColor(.orange)
                        }
                        .padding(.vertical, 4)
                    }
                }

                Text("Total: \(totalCalories) kcal")
                    .font(.title)
                    .bold()
                    .padding()

                Button("📸 Tomar foto") {
                    mostrarCamara = true
                }
                .buttonStyle(.borderedProminent)
                .padding()

            }
            .sheet(isPresented: $mostrarCamara) {
                CameraView { image in
                    FoodClassifier.detectFoods(from: image) { detected in
                        foods = detected
                    }
                }
            }
        }
    }
}
