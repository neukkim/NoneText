
import Foundation
import Vision
import UIKit

class VisionManager {
    var textBoxes: [CGRect] = []
    var recognizedStrings: [String] = [] // ✅ 텍스트 내용 추가
    var imageSize: CGSize = .zero

    func analyze(image: UIImage, completion: @escaping () -> Void) {
        guard let cgImage = image.cgImage else {
            completion()
            return
        }

        self.imageSize = CGSize(width: cgImage.width, height: cgImage.height)

        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                completion()
                return
            }

            self.textBoxes = []
            self.recognizedStrings = []

            for obs in observations {
                if let candidate = obs.topCandidates(1).first {
                    self.recognizedStrings.append(candidate.string)

                    let box = obs.boundingBox
                    let x = box.origin.x * CGFloat(cgImage.width)
                    let y = (1 - box.origin.y - box.height) * CGFloat(cgImage.height)
                    let width = box.size.width * CGFloat(cgImage.width)
                    let height = box.size.height * CGFloat(cgImage.height)
                    self.textBoxes.append(CGRect(x: x, y: y, width: width, height: height))
                }
            }

            DispatchQueue.main.async {
                completion()
            }
        }

        request.recognitionLanguages = ["ko-KR", "en-US"]
        request.recognitionLevel = .accurate

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try? handler.perform([request])
    }
}


//class DummyVisionManager {
//    var textBoxes: [CGRect]
//    var imageSize: CGSize
//    
//    init(textBoxes: [CGRect], imageSize: CGSize = CGSize(width: 300, height: 300)) {
//        self.textBoxes = textBoxes
//        self.imageSize = imageSize
//    }
//}

class DummyVisionManager {
    var textBoxes: [CGRect]
    var recognizedStrings: [String]
    var imageSize: CGSize

    init(textBoxes: [CGRect], recognizedStrings: [String] = [], imageSize: CGSize = CGSize(width: 300, height: 300)) {
        self.textBoxes = textBoxes
        self.recognizedStrings = recognizedStrings
        self.imageSize = imageSize
    }
}

