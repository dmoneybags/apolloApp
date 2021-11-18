//
//  apollo4App.swift
//  apollo4
//
//  Created by Daniel DeMoney on 11/17/21.
//

import SwiftUI

@main
struct apollo4App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // initialize Amplify
        let _ = Backend.initialize()

        return true
    }
}
