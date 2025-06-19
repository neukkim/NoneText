import SwiftUI

struct TextExtractView: View {
    let texts: [String]

    var body: some View {
        VStack {
            Text("텍스트 추출 결과")
                .font(.title2)
                .padding()

            List(texts, id: \.self) { text in
                Text(text)
            }

            HStack {
                Button("복사하기") {
                    UIPasteboard.general.string = texts.joined(separator: "\n")
                }

                Button("파일로 저장 (.txt)") {
                    saveAsTextFile(texts: texts)
                }
            }.padding()
        }
    }

    func saveAsTextFile(texts: [String]) {
        let text = texts.joined(separator: "\n")
        let fileName = "DetectedText.txt"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        try? text.write(to: url, atomically: true, encoding: .utf8)

        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true)
    }
}
