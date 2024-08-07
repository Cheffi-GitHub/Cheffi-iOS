//
//  RepresentableWebView.swift
//  Cheffi
//
//  Created by 이서준 on 8/7/24.
//

import SwiftUI
import WebKit

struct RepresentableWebView: UIViewRepresentable {
    
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(URLRequest(url: url))
    }
}
