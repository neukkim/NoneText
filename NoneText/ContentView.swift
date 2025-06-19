import SwiftUI

struct ContentView: View {
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var selectedOption = "Vision" // "Vision" or "CoreML"

    var body: some View {
        VStack(spacing: 40) {
            // 1. 타이틀
            Text("Text Detector")
                .font(.largeTitle)
                .bold()
                .padding(.top, 40)

            // 2. 이미지 선택 박스
            Button {
                showImagePicker = true
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray.opacity(0.8), lineWidth: 2.0)
                        .frame(height: 200)

                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .clipped()
                            .cornerRadius(16)
                    } else {
                        Image(systemName: "plus")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal)

            // 3. 분석 방식 Picker (Segmented)
            Picker("분석 방식", selection: $selectedOption) {
                Text("Vision").tag("Vision")
                Text("CoreML").tag("CoreML")
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            // 4. 분석 시작 버튼
            Button("분석 시작") {
                // 👉 여기에 VisionManager or CoreML 분석 로직 연결 예정
            }
            .foregroundColor(.white)
            .font(.system(size: 20, weight: .semibold))
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.black)
            .cornerRadius(12)
            .padding(.horizontal)
            .disabled(selectedImage == nil)

            Spacer()
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
    }
}

#Preview {
    ContentView()
}

