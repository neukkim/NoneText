
import SwiftUI

struct ResultView: View {
    @ObservedObject var viewModel: ResultViewModel
    @State private var showTextView = false
    @State private var showImageView = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("분석 결과")
                .font(.title2)
                .bold()
                .padding(.top)
            
            ZStack {
                Image(uiImage: viewModel.image)
                    .resizable()
                    .scaledToFit()
                    .overlay(
                        GeometryReader { geometry in
                            // 텍스트 박스
                            ForEach(viewModel.textBoxes.indices, id: \.self) { i in
                                let rect = viewModel.convertToViewCoordinates(viewModel.textBoxes[i], viewSize: geometry.size)
                                Rectangle()
                                    .stroke(Color.blue, lineWidth: 2)
                                    .frame(width: rect.width, height: rect.height)
                                    .position(x: rect.midX, y: rect.midY)
                            }

                            // 비텍스트 박스
                            ForEach(viewModel.nonTextBoxes.indices, id: \.self) { i in
                                let rect = viewModel.convertToViewCoordinates(viewModel.nonTextBoxes[i], viewSize: geometry.size)
                                Rectangle()
                                    .stroke(Color.green, lineWidth: 2)
                                    .frame(width: rect.width, height: rect.height)
                                    .position(x: rect.midX, y: rect.midY)
                            }

                        }
                    )
            }
            .cornerRadius(12)
            
            Text("텍스트 라인: \(viewModel.textCount)개 / 비텍스트: \(viewModel.nonTextCount)개")
                .font(.subheadline)
            
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
        .padding()
    } // End body
}// End View


#Preview {
    let dummyImage = UIImage(systemName: "photo")!
    let dummyBoxes = [CGRect(x: 10, y: 10, width: 100, height: 40)]
    let dummySize = CGSize(width: 300, height: 300)
    let viewModel = ResultViewModel(image: dummyImage, textBoxes: dummyBoxes, imageSize: dummySize)
    
    ResultView(viewModel: viewModel)  // ✅ return 없이 바로 View 작성
}


