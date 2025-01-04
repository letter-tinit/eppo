import SwiftUI
import WebKit

struct PDFWebView: UIViewRepresentable {
    let url: URL
    @Binding var loadingState: LoadingState

    enum LoadingState {
        case loading, success, failed
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: PDFWebView
        private var webView: WKWebView?

        init(parent: PDFWebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.loadingState = .success
            self.webView = webView
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.loadingState = .failed
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.loadingState = .loading
        }

        @objc func printPDF() {
            guard let webView = webView else { return }
            let printController = UIPrintInteractionController.shared
            let printInfo = UIPrintInfo(dictionary: nil)
            printInfo.outputType = .general
            printInfo.jobName = parent.url.lastPathComponent
            printController.printInfo = printInfo
            printController.printFormatter = webView.viewPrintFormatter()
            printController.present(animated: true, completionHandler: nil)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UIView {
        // Tạo UIView bao gồm WKWebView và nút in
        let container = UIView()
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.load(URLRequest(url: url))
        self.loadingState = .loading

        // Tạo nút in
        let printButton = UIButton(type: .system)
        printButton.setTitle("In hợp đồng", for: .normal)
        printButton.addTarget(context.coordinator, action: #selector(Coordinator.printPDF), for: .touchUpInside)
        printButton.translatesAutoresizingMaskIntoConstraints = false

        // Thêm webView và nút vào container
        container.addSubview(webView)
        container.addSubview(printButton)

        // Cài đặt Auto Layout
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            webView.topAnchor.constraint(equalTo: container.topAnchor),
            webView.bottomAnchor.constraint(equalTo: container.bottomAnchor),

            printButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            printButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16),
            printButton.widthAnchor.constraint(equalToConstant: 100),
            printButton.heightAnchor.constraint(equalToConstant: 44)
        ])

        return container
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
