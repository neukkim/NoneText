import Foundation
import UIKit

class TextExtractViewModel: ObservableObject {
    @Published var texts: [String]
    
    init(texts: [String]){
        self.texts = texts
    }
    
    func copyToClipboard() {
        UIPasteboard.general.string = texts.joined(separator: "\n")
    }

    func saveAsTextFile() {
        let text = texts.joined(separator: "\n")
        let fileName = "DetectedText.txt"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)

        do {
            try text.write(to: url, atomically: true, encoding: .utf8)
            print("✅ 파일 저장 성공: \(url)")
        } catch {
            print("❌ 파일 저장 실패: \(error)")
        }
    }

    //아래 저장 + 공유 필요시 분석 사용
//    func saveAsTextFile(texts: [String]) {
//        let text = texts.joined(separator: "\n")
//        let fileName = "DetectedText.txt"
//        let url = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
//        
//        do {
//            try text.write(to: url, atomically: true, encoding: .utf8)
//
//            let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
//
//            // ✅ iOS 15 이상 대응
//            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//               let rootVC = windowScene.windows.first?.rootViewController {
//                rootVC.present(activityVC, animated: true, completion: nil)
//            }
//
//        } catch {
//            print("파일 저장 실패: \(error)")
//        }
//
//    }
}
