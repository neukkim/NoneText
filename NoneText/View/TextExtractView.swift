import SwiftUI

struct TextExtractView: View {
    @ObservedObject var viewModel: TextExtractViewModel

    var body: some View {
        VStack {
            Text("텍스트 추출 결과")
                .font(.title2)
                .padding(.top)
                .bold()

            List(viewModel.texts, id: \.self) { text in
                Text(text)
            }

            HStack(spacing: 16) {
                Button("복사하기") {
                    viewModel.copyToClipboard()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.8))
                .cornerRadius(12)

                Button("파일로 저장 (.txt)") {
                    viewModel.saveAsTextFile()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.8))
                .cornerRadius(12)
            }
            .font(.system(size: 20, weight: .semibold))
            .foregroundColor(.black)
        }
        .padding(.horizontal)
    }

}

#Preview {
    let testViewModel = TextExtractViewModel(texts: ["첫 번째 문장", "두 번째 문장", "세 번째 문장"])
    return TextExtractView(viewModel: testViewModel)
}
