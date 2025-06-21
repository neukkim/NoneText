
import SwiftUI

class ResultViewModel: ObservableObject {
    @Published var image: UIImage
    @Published var textBoxes: [CGRect]
    @Published var nonTextBoxes: [CGRect] = []
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
        self.extractedTexts = visionManager.recognizedStrings
        self.extractNonTextImages()  // ✅ 추가
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
    
    func extractNonTextImages() {
        guard let cgImage = image.cgImage else { return }

        let combinedTextRect = textBoxes.reduce(CGRect.null) { $0.union($1) }

        let topRect = CGRect(x: 0, y: 0, width: imageSize.width, height: combinedTextRect.minY)
        let bottomRect = CGRect(x: 0, y: combinedTextRect.maxY, width: imageSize.width, height: imageSize.height - combinedTextRect.maxY)
        let leftRect = CGRect(x: 0, y: combinedTextRect.minY, width: combinedTextRect.minX, height: combinedTextRect.height)
        let rightRect = CGRect(x: combinedTextRect.maxX, y: combinedTextRect.minY, width: imageSize.width - combinedTextRect.maxX, height: combinedTextRect.height)

        let rects = [topRect, bottomRect, leftRect, rightRect].filter { $0.width > 10 && $0.height > 10 }

        self.nonTextBoxes = rects  // ✅ 저장

        self.croppedImages = []
        self.nonTextBoxes = []

        for rect in rects {
            guard let croppedCG = cgImage.cropping(to: rect) else { continue }
            let cropped = UIImage(cgImage: croppedCG)

            if !isVisuallyEmpty(cropped) {
                self.croppedImages.append(cropped)
                self.nonTextBoxes.append(rect)
            }
        }

        
        
    }

    
    func isVisuallyEmpty(_ image: UIImage, threshold: CGFloat = 0.95) -> Bool {
        guard let cgImage = image.cgImage else { return true }

        let width = 10
        let height = 10
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8

        guard let context = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bytesPerRow: bytesPerRow,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else { return true }

        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        guard let pixelBuffer = context.data else { return true }

        let pixels = pixelBuffer.bindMemory(to: UInt8.self, capacity: width * height * 4)

        var filteredCount = 0

        for i in stride(from: 0, to: width * height * 4, by: 4) {
            let r = pixels[i]
            let g = pixels[i + 1]
            let b = pixels[i + 2]

            // 밝기값 계산 (Luminance)
            let luminance = 0.299 * Double(r) + 0.587 * Double(g) + 0.114 * Double(b)

            // 🎯 거의 흰색 or 거의 검정 or 중간 회색 계열
            if luminance > 235 || luminance < 20 || (luminance >= 80 && luminance <= 180) {
                filteredCount += 1
            }
        }

        let ratio = CGFloat(filteredCount) / CGFloat(width * height)
        return ratio >= threshold
    }


}
