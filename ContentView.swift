import SwiftUI

struct ContentView: View {
    @State private var totalCalorias = 0
    @State private var alimentoDetectado = "Ninguno"
    @State private var mostrarCamara = false

    var body: some View {
        VStack(spacing: 25) {

            Text("Contador con IA")
                .font(.largeTitle)
                .bold()

            Text("Alimento detectado:")
            Text(alimentoDetectado)
                .font(.title2)

            Text("Total de calorías")
            Text("\(totalCalorias)")
                .font(.largeTitle)

            Button("📸 Tomar foto") {
                mostrarCamara = true
            }

            Spacer()
        }
        .padding()
    }
}
