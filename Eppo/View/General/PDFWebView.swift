//
//  PDFWebView.swift
//  Eppo
//
//  Created by Letter on 22/11/2024.
//

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

        init(parent: PDFWebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.loadingState = .success
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.loadingState = .failed
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.loadingState = .loading
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Optional: Reload the URL if needed
    }
}

