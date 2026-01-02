
import SwiftUI

// 🔑 Replace with your own Google Vision API key
private let GOOGLE_VISION_API_KEY =   "AIzaSyCqafK_zWnJ1h7ZY_KTpsxmHRCQDAZzw_Q"

struct ContentView: View {

    @StateObject private var viewModel =
        LandmarkViewModel(apiKey: GOOGLE_VISION_API_KEY)

    @State private var selectedImage: UIImage?
    @State private var showPicker = false

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {

                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(12)
                }

                Button("Select Landmark Image") {
                    showPicker = true
                }
                .buttonStyle(.borderedProminent)

                if viewModel.isLoading {
                    ProgressView("Recognizing landmark...")
                }

                if let landmark = viewModel.landmark {
                    VStack(spacing: 8) {
                        Text(landmark.name)
                            .font(.title2)
                            .fontWeight(.bold)

                        Text("Confidence: \(Int(landmark.confidence * 100))%")

                        if let lat = landmark.latitude,
                           let lng = landmark.longitude {
                            Text("Latitude: \(lat)")
                            Text("Longitude: \(lng)")
                        }
                    }
                    .padding()
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Landmark Recognition")
        }
        .sheet(isPresented: $showPicker) {
            ImagePicker(image: $selectedImage)
        }
        .onChange(of: selectedImage) { newImage in
            guard let image = newImage else { return }
            viewModel.recognize(image: image)
        }
    }
}
