//
//  apollo4App.swift
//  apollo4
//
//  Created by Daniel DeMoney on 11/17/21.
//

import SwiftUI

import CoreData

// basically, we intialize one controller object that can only be seen within this file and put it
// within the app struct so we can easily grab it within views and the appDelegate class to easily
// grab in functions

fileprivate var DATACONTOLLER = DataController()

@main
struct apollo4App: App {
    @StateObject private var dataController = DATACONTOLLER
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
class AppDelegate: NSObject, UIApplicationDelegate {
    static var originalAppDelegate:AppDelegate!
    
    let persistentContainer:NSPersistentContainer = DATACONTOLLER.container
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppDelegate.originalAppDelegate = self
        // initialize Amplify
        print("LAUNCHING")
        let _ = Backend.initialize()

        return true
    }
}

