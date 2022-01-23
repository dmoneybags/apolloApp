//
//  apollo4App.swift
//  apollo4
//
//  Created by Daniel DeMoney on 11/17/21.
//

import SwiftUI
import Amplify
import CoreData

// basically, we intialize one controller object that can only be seen within this file and put it
// within the app struct so we can easily grab it within views and the appDelegate class to easily
// grab in functions

fileprivate var DATACONTOLLER = DataController()
fileprivate var LOADMAIN = false
@main
struct apollo4App: App {
    @StateObject var bleManager: BLEManager = BLEManager()
    @StateObject private var dataController = DATACONTOLLER
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            if !LOADMAIN{
                ContentView()
                    .environment(\.managedObjectContext, dataController.container.viewContext)
                    .environmentObject(bleManager)
            } else {
                MainView2()
                    .environmentObject(bleManager)
            }
        }
    }
}
class AppDelegate: NSObject, UIApplicationDelegate {
    static var originalAppDelegate:AppDelegate!
    let persistentContainer:NSPersistentContainer = DATACONTOLLER.container
    var loadMain: Bool = false
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppDelegate.originalAppDelegate = self
        // initialize Amplify
        print("LAUNCHING")
        #if targetEnvironment(simulator)
        print("IN SIMULATOR")
        #else
        let _ = Backend.initialize()
        print("BACKEND INITIALIZED")
        print("CURRENT USER: \(String(describing: Amplify.Auth.getCurrentUser()))")
        Backend.shared.setUser()
        #endif
        LOADMAIN = loadMain
        return true
    }
}

