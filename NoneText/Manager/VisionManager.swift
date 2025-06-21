
import Foundation
import Vision
import UIKit

class VisionManager {
    var textBoxes: [CGRect] = []
    var imageSize: CGSize = .zero

    /// Vision 프레임워크를 사용하여 텍스트 박스를 추출
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

            self.textBoxes = observations.compactMap { observation in
                let boundingBox = observation.boundingBox
                let x = boundingBox.origin.x * CGFloat(cgImage.width)
                let y = (1 - boundingBox.origin.y - boundingBox.size.height) * CGFloat(cgImage.height)
                let width = boundingBox.size.width * CGFloat(cgImage.width)
                let height = boundingBox.size.height * CGFloat(cgImage.height)
                return CGRect(x: x, y: y, width: width, height: height)
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

//class VisionManager: ObservableObject {
//    @Published var textBoxes: [CGRect] = []
//    @Published var textContents: [String] = []
//    var imageSize: CGSize = .zero
//    
//    // 분석 추가
//    static func recognizeText(from image: UIImage, completion: @escaping ([VNRecognizedTextObservation]) -> Void) {
//        guard let cgImage = image.cgImage else { return }
//
//        let request = VNRecognizeTextRequest { request, error in
//            if let results = request.results as? [VNRecognizedTextObservation] {
//                DispatchQueue.main.async {
//                    completion(results)
//                }
//            }
//        }
//
//        request.recognitionLanguages = ["en-US", "ko-KR"]
//        request.recognitionLevel = .accurate
//
//        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
//        try? handler.perform([request])
//    }
//    
//    func detectText(in image: UIImage) {
//        guard let cgImage = image.cgImage else { return }
//        
//        imageSize = CGSize(width: cgImage.width, height: cgImage.height)
//        
//        let request = VNRecognizeTextRequest { request, error in
//            DispatchQueue.main.async {
//                self.textBoxes = []
//                self.textContents = []
//                
//                guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
//                
//                for obs in observations {
//                    self.textBoxes.append(obs.boundingBox)
//                    if let topText = obs.topCandidates(1).first {
//                        self.textContents.append(topText.string)
//                    }
//                }
//            }
//        }
//        
//        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
//        try? handler.perform([request])
//    }
//}

class DummyVisionManager {
    var textBoxes: [CGRect]
    var imageSize: CGSize
    
    init(textBoxes: [CGRect], imageSize: CGSize = CGSize(width: 300, height: 300)) {
        self.textBoxes = textBoxes
        self.imageSize = imageSize
    }
}
