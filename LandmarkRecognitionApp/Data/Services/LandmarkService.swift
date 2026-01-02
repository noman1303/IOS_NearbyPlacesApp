import UIKit

final class LandmarkService {

    private let apiKey: String

    init(apiKey: String) {
        self.apiKey = apiKey
    }

    func detectLandmark(
        image: UIImage,
        completion: @escaping (Landmark?) -> Void
    ) {
        guard let imageData = image.jpegData(compressionQuality: 0.7) else {
            completion(nil)
            return
        }

        let base64Image = imageData.base64EncodedString()

        let body: [String: Any] = [
            "requests": [[
                "image": ["content": base64Image],
                "features": [[
                    "type": "LANDMARK_DETECTION",
                    "maxResults": 1
                ]]
            ]]
        ]

        let url = URL(
            string: "https://vision.googleapis.com/v1/images:annotate?key=\(apiKey)"
        )!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard
                let data,
                let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                let responses = json["responses"] as? [[String: Any]],
                let landmarks = responses.first?["landmarkAnnotations"] as? [[String: Any]],
                let first = landmarks.first
            else {
                completion(nil)
                return
            }

            let name = first["description"] as? String ?? "Unknown"
            let score = first["score"] as? Double ?? 0.0

            let locations = first["locations"] as? [[String: Any]]
            let latLng = locations?.first?["latLng"] as? [String: Any]

            let latitude = latLng?["latitude"] as? Double
            let longitude = latLng?["longitude"] as? Double

            let landmark = Landmark(
                name: name,
                confidence: score,
                latitude: latitude,
                longitude: longitude
            )

            completion(landmark)
        }.resume()
    }
}
