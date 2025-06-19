import SwiftUI

struct TextExtractView: View {
    let texts: [String]

    var body: some View {
        VStack {
            Text("텍스트 추출 결과")
                .font(.title2)
                .padding(.top)
                .bold()

            List(texts, id: \.self) { text in
                Text(text)
            }

            HStack {
                Button("복사하기") {
                    UIPasteboard.general.string = texts.joined(separator: "\n")
                }
                .foregroundColor(.black)
                .font(.system(size: 20, weight: .semibold))
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.gray.opacity(0.8))
                .cornerRadius(12)

                Button("파일로 저장 (.txt)") {
                    saveAsTextFile(texts: texts)
                }
                .foregroundColor(.black)
                .font(.system(size: 20, weight: .semibold))
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.gray.opacity(0.8))
                .cornerRadius(12)
            }
            .padding()
        }
    }

    func saveAsTextFile(texts: [String]) {
        let text = texts.joined(separator: "\n")
        let fileName = "DetectedText.txt"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        do {
            try text.write(to: url, atomically: true, encoding: .utf8)

            let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)

            // ✅ iOS 15 이상 대응
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootVC = windowScene.windows.first?.rootViewController {
                rootVC.present(activityVC, animated: true, completion: nil)
            }

        } catch {
            print("파일 저장 실패: \(error)")
        }

    }
}

#Preview {
    TextExtractView(texts: ["text1", "text2", "text3"])
}
