import Foundation
import Vision
import UIKit
import SwiftUI

class VisionManager: ObservableObject {
    @Published var textBoxes: [CGRect] = []
    @Published var imageSize: CGSize = .zero

    func detectText(in image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        imageSize = CGSize(width: cgImage.width, height: cgImage.height)

        let request = VNRecognizeTextRequest { [weak self] request, _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.textBoxes = (request.results as? [VNRecognizedTextObservation])?.map {
                    $0.boundingBox
                } ?? []
            }
        }

        request.recognitionLevel = .accurate
        
        //아래 VNRecognizeTextRequest 옵션 강화
        request.usesLanguageCorrection = true
        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["ko", "en"] // 한국어 포함 시

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            try? handler.perform([request])
        }
    }
}
