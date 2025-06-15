import SwiftUI

struct ContentView: View {
    @State private var selectedImage: UIImage?
    @State private var showPicker = false
    @StateObject var visionManager = VisionManager()

    var body: some View {
        VStack {
            if let image = selectedImage {
                GeometryReader { geometry in
                    ZStack {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()

                        ForEach(visionManager.textBoxes, id: \.self) { box in
                            let rect = convertToViewCoordinates(box, imageSize: visionManager.imageSize, viewSize: geometry.size)
                            Rectangle()
                                .stroke(Color.red, lineWidth: 2)
                                .frame(width: rect.width, height: rect.height)
                                .position(x: rect.midX, y: rect.midY)
                        }
                    }
                }
                .frame(height: 400)
            }

            Button("이미지 선택") {
                showPicker = true
            }

            if selectedImage != nil {
                Button("텍스트 감지 실행") {
                    visionManager.detectText(in: selectedImage!)
                }
                .padding(.top, 10)
            }
        }
        .sheet(isPresented: $showPicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
        .padding()
    }

//    func convertToViewCoordinates(_ box: CGRect, imageSize: CGSize, viewSize: CGSize) -> CGRect {
//        let width = box.width * viewSize.width
//        let height = box.height * viewSize.height
//        let x = box.minX * viewSize.width
//        let y = (1 - box.maxY) * viewSize.height
//        return CGRect(x: x, y: y, width: width, height: height)
//    }
    func convertToViewCoordinates(_ box: CGRect, imageSize: CGSize, viewSize: CGSize) -> CGRect {
        let width = viewSize.width * box.width
        let height = viewSize.height * box.height
        let x = viewSize.width * box.minX
        let y = (1 - box.maxY) * viewSize.height
        return CGRect(x: x, y: y, width: width, height: height)
    }

}

#Preview {
    ContentView()
}
