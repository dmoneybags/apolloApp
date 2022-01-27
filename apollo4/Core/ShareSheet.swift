//
//  ShareSheet.swift
//  apollo4
//
//  Created by Daniel DeMoney on 1/25/22.
//

import Foundation
import UIKit
import SwiftUI

public extension UIApplication {
    func currentUIWindow() -> UIWindow? {
        let connectedScenes = UIApplication.shared.connectedScenes
            .filter({
                $0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
        
        let window = connectedScenes.first?
            .windows
            .first { $0.isKeyWindow }

        return window
        
    }
}

func createShareSheetController(file: NSURL) -> UIActivityViewController{
    var filesToShare = [Any]()
    filesToShare.append(file)
    return UIActivityViewController(activityItems: filesToShare, applicationActivities: [])
}
func presentShareSheet(shareSheet: UIActivityViewController){
    shareSheet.isModalInPresentation = true
    UIApplication.shared.currentUIWindow()?.rootViewController?.present(shareSheet, animated: true, completion: nil)
}
struct ShareSheet: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIActivityViewController

    var sharing: [Any]

    func makeUIViewController(context: UIViewControllerRepresentableContext<ShareSheet>) -> UIActivityViewController {
        UIActivityViewController(activityItems: sharing, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ShareSheet>) {

    }
}
