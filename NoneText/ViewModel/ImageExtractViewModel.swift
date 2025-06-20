
import SwiftUI

class ImageExtractViewModel: ObservableObject {
    @Published var croppedImages: [UIImage]

    init(croppedImages: [UIImage]) {
        self.croppedImages = croppedImages
    }
}
