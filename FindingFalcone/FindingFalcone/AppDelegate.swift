//
//  AppDelegate.swift
//  FindingFalcone
//
//  Created by Hanh Do on 11/02/2022.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var applicationCoordinator: Coordinating?
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        applicationCoordinator = ApplicationCoordinator(window: window)
        applicationCoordinator?.start()
        return true
    }

}

