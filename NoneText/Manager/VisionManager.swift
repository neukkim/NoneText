import Vision
import SwiftUI

class VisionManager: ObservableObject {
    @Published var textBoxes: [CGRect] = []
    @Published var textContents: [String] = []
    var imageSize: CGSize = .zero

    func detectText(in image: UIImage) {
        guard let cgImage = image.cgImage else { return }

        imageSize = CGSize(width: cgImage.width, height: cgImage.height)

        let request = VNRecognizeTextRequest { request, error in
            DispatchQueue.main.async {
                self.textBoxes = []
                self.textContents = []

                guard let observations = request.results as? [VNRecognizedTextObservation] else { return }

                for obs in observations {
                    self.textBoxes.append(obs.boundingBox)
                    if let topText = obs.topCandidates(1).first {
                        self.textContents.append(topText.string)
                    }
                }
            }
        }

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try? handler.perform([request])
    }
}

class DummyVisionManager {
    var textBoxes: [CGRect]
    var imageSize: CGSize

    init(textBoxes: [CGRect], imageSize: CGSize = CGSize(width: 300, height: 300)) {
        self.textBoxes = textBoxes
        self.imageSize = imageSize
    }
}
