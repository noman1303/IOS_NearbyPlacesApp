
import SwiftUI

final class LandmarkViewModel: ObservableObject {

    @Published var landmark: Landmark?
    @Published var isLoading = false

    private let service: LandmarkService

    init(apiKey: String) {
        self.service = LandmarkService(apiKey: apiKey)
    }

    func recognize(image: UIImage) {
        isLoading = true
        landmark = nil

        service.detectLandmark(image: image) { [weak self] result in
            DispatchQueue.main.async {
                self?.landmark = result
                self?.isLoading = false
            }
        }
    }
}
