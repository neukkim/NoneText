
import SwiftUI

class ImageSelectionViewModel: ObservableObject {
    @Published var selectedImage: UIImage? = nil

    func updateSelectedImage(_ image: UIImage) {
        selectedImage = image
    }
}
