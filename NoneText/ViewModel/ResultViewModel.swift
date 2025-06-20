
import SwiftUI

class ResultViewModel: ObservableObject {
    @Published var image: UIImage
    @Published var textBoxes: [CGRect]
    @Published var imageSize: CGSize
    @Published var extractedTexts: [String] = []
    @Published var croppedImages: [UIImage] = []
    
    var textCount: Int {
        extractedTexts.count
    }

    var nonTextCount: Int {
        croppedImages.count
    }

    init(image: UIImage, visionManager: VisionManager) {
        self.image = image
        self.textBoxes = visionManager.textBoxes
        self.imageSize = visionManager.imageSize
    }
    
    // 아래 더미용?
    init(image: UIImage, textBoxes: [CGRect], imageSize: CGSize) {
        self.image = image
        self.textBoxes = textBoxes
        self.imageSize = imageSize
    }


    func convertToViewCoordinates(_ rect: CGRect, viewSize: CGSize) -> CGRect {
        // 이미지 좌표계를 뷰 좌표계로 변환하는 로직 그대로 가져오기
        let scaleX = viewSize.width / imageSize.width
        let scaleY = viewSize.height / imageSize.height
        let scale = min(scaleX, scaleY)

        let newOrigin = CGPoint(x: rect.origin.x * scale, y: rect.origin.y * scale)
        let newSize = CGSize(width: rect.width * scale, height: rect.height * scale)

        return CGRect(origin: newOrigin, size: newSize)
    }
}
