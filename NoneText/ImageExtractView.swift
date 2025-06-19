import SwiftUI

struct ImageExtractView: View {
    let croppedImages: [UIImage]

    var body: some View {
        VStack {
            Text("이미지 추출 결과")
                .font(.title2)
                .bold()
                .padding()

                List {
                    ForEach(croppedImages.indices, id: \.self) { index in
                        HStack(spacing: 64) {
                            Image(uiImage: croppedImages[index])
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .cornerRadius(8)
                            
                            Text("이미지 \(index + 1)")
                                .font(.body)
                        }
                        .padding(.vertical, 8)
                    }
                }
                .listStyle(.plain) // 혹은 .insetGrouped, .grouped 등
                
                
                
                
            //} // End ScrollView
//            .frame(maxHeight: 300) // 원하는 높이로 제한 가능
//            .overlay( // 정확하게 ScrollView 영역에 테두리
//                RoundedRectangle(cornerRadius: 8)
//                    .stroke(Color.red, lineWidth: 2)
//            )
            .padding(.horizontal)
            

            Button("이미지 저장하기") {
                // 👉 저장 로직: 예를 들면 zip 파일 생성 또는 공유
            }
            .foregroundColor(.black)
            .font(.system(size: 20, weight: .semibold))
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.gray.opacity(0.8))
            .cornerRadius(12)
            .padding(.horizontal)
        } // End VStack
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    // 예시용 이미지 생성
    let dummyImage1 = UIImage(systemName: "photo")!
    let dummyImage2 = UIImage(systemName: "photo.fill")!
    let dummyImage3 = UIImage(systemName: "photo.on.rectangle")!

    return ImageExtractView(croppedImages: [dummyImage1, dummyImage2, dummyImage3])
}

