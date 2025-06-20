import SwiftUI

import SwiftUI

struct ContentView: View {
    @State private var showImagePicker = false
    @StateObject private var viewModel = ImageSelectionViewModel()
    @State private var selectedOption = "Vision"

    var body: some View {
        VStack(spacing: 40) {
            Text("Text Detector")
                .font(.largeTitle)
                .bold()
                .padding(.top, 40)

            Button {
                showImagePicker = true
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray.opacity(0.8), lineWidth: 2.0)
                        .frame(height: 200)

                    if let image = viewModel.selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 300)
                            .cornerRadius(16)
                    } else {
                        Image(systemName: "plus")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal)

            Picker("분석 방식", selection: $selectedOption) {
                Text("Vision").tag("Vision")
                Text("CoreML").tag("CoreML")
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            Button("분석 시작") {
                // viewModel.selectedImage 를 분석기로 넘기면 됨
            }
            .foregroundColor(.white)
            .font(.system(size: 20, weight: .semibold))
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.black)
            .cornerRadius(12)
            .padding(.horizontal)
            Spacer()
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker { image in
                viewModel.updateSelectedImage(image)
            }
        }
    }
}


#Preview {
    ContentView()
}

