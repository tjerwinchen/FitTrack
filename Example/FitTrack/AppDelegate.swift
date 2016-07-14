//
//  AppDelegate.swift
//  FitTrack
//
//  Created by roman.sherbakov on 07/11/2016.
//  Copyright (c) 2016 roman.sherbakov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        UIApplication.shared().statusBarStyle = .lightContent
        
        ZoomStartupAnimation.performAnimation(window!, navControllerIdentifier: "navigationController", backgroundImage: UIImage(named: "bg")!, animationImage: UIImage(named: "logo")!)
        
        return true
    }

}

