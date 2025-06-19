
import SwiftUI

struct ResultView: View {
    let image: UIImage
    @ObservedObject var visionManager: VisionManager

    var body: some View {
        VStack(spacing: 20) {
            // 1. 제목
            Text("분석 결과")
                .font(.title2)
                .bold()
                .padding(.top)

            // 2. 이미지 + 오버레이 박스
            ZStack {
                Image(uiImage: image)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(height: 200)
////                    .frame(maxWidth: .infinity, maxHeight: 200)
//                    .cornerRadius(12)
//                    .overlay(
//                        GeometryReader { geometry in
//                            ForEach(visionManager.textBoxes.indices, id: \.self) { i in
//                                let box = visionManager.textBoxes[i]
//                                let rect = convertToViewCoordinates(box, imageSize: visionManager.imageSize, viewSize: geometry.size)
//
//                                Rectangle()
//                                    .stroke(boxLabel(for: i) == "Text" ? Color.red : Color.blue, lineWidth: 2)
//                                    .frame(width: rect.width, height: rect.height)
//                                    .position(x: rect.midX, y: rect.midY)
//                                    .overlay(
//                                        Text(boxLabel(for: i))
//                                            .font(.caption2)
//                                            .foregroundColor(boxLabel(for: i) == "Text" ? .red : .blue)
//                                            .padding(4)
//                                            .background(Color.white)
//                                            .cornerRadius(4),
//                                        alignment: .topLeading
//                                    )
//                            }
//                        }
//                    )
                
                
                    .resizable()
//                            .scaledToFill()
//                            .clipped()
                    .scaledToFit()
                    .frame(height: 300)
                    .cornerRadius(16)

            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            
            
//                ZStack {
//                    RoundedRectangle(cornerRadius: 16)
//                        .stroke(Color.gray.opacity(0.8), lineWidth: 2.0)
//                        .frame(height: 200)
//                    Image(systemName: "plus")
//                        .font(.system(size: 50))
//                        .foregroundColor(.gray)
//                }
            
            
            
            
            .padding(.horizontal)

            // 3. 결과 요약
            Text("텍스트 \(visionManager.textBoxes.count)개 / 비텍스트 6개") // <- 비텍스트는 필요시 계산

            // 4. 버튼
            Button(action: {
                // 텍스트 추출 화면으로 이동
            }) {
                Text("텍스트 추출 보기")
                    .foregroundColor(.black)
                    .font(.system(size: 20, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.8))
                    .cornerRadius(12)
            }
            .padding(.horizontal)
//            Spacer()
            
            Button(action: {
                // 👉 이미지 추출 화면으로 이동
            }) {
                Text("이미지 추출 보기")
                    .foregroundColor(.black)
                    .font(.system(size: 20, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.8))
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            Spacer()
            
        }
        .padding(.top)
        .navigationBarBackButtonHidden(false)
    }

    func boxLabel(for index: Int) -> String {
        // 임시 로직 – 실제로는 visionManager에서 텍스트/비텍스트 구분된 배열 필요
        return "Text"
    }

    func convertToViewCoordinates(_ box: CGRect, imageSize: CGSize, viewSize: CGSize) -> CGRect {
        let width = viewSize.width * box.width
        let height = viewSize.height * box.height
        let x = viewSize.width * box.minX
        let y = (1 - box.maxY) * viewSize.height
        return CGRect(x: x, y: y, width: width, height: height)
    }
}

#Preview {
//    let dummyImage = UIImage(named: "example") ?? UIImage()
//    let dummyManager = VisionManager()
//    dummyManager.imageSize = dummyImage.size
//    dummyManager.textBoxes = [
//        CGRect(x: 0.2, y: 0.2, width: 0.3, height: 0.1),
//        CGRect(x: 0.6, y: 0.5, width: 0.2, height: 0.15)
//    ]
//    ResultView(image: dummyImage, visionManager: dummyManager)
    ResultView(
        image: UIImage(systemName: "photo")!,
        visionManager: {
            let manager = VisionManager()
            manager.imageSize = CGSize(width: 100, height: 100)
            manager.textBoxes = [
                CGRect(x: 0.2, y: 0.2, width: 0.3, height: 0.1),
                CGRect(x: 0.6, y: 0.5, width: 0.2, height: 0.15)
            ]
            return manager
        }()
    )
}

