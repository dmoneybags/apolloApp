//
//  PullUpToRefresh.swift
//  apollo4
//
//  Created by Daniel DeMoney on 2/6/22.
//

import SwiftUI

struct ActivityIndicator: UIViewRepresentable {

    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

struct PullUpToRefresh: View {
    var action: () -> Void
    @State private var show = true
    var body: some View {
        if show{
            ActivityIndicator(isAnimating: .constant(true), style: .medium)
        }
    }
}

