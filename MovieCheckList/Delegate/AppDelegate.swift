//
//  AppDelegate.swift
//  MovieCheckList
//
//  Created by Steven Lin on 2020/8/27.
//  Copyright © 2020 Steven Lin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        if Status.shared.jsonData != nil || Status.shared.remoteStarted{
//            self.window = UIWindow(frame: UIScreen.main.bounds)
//            let switchVC = SwitchVC()
//            if let ovc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController(){
//                switchVC.shellVC = ovc // the first ViewController
//            }
//            self.window?.rootViewController = switchVC
//            self.window?.makeKeyAndVisible()}
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
//        guard let fun = FunVCSingleton else{
//            return
//        }
//        fun.stopBackGroundUrlCheck()
//        fun.stopProgFetch()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
//        if let lastPresentUrl = MainWebView?.url{
//            PresentingURL = lastPresentUrl
//        }
//        AppDuringUsage = false
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
//        AppDuringUsage = true
    }
    
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
//        application.applicationIconBadgeNumber = 0
//        if DidReceiveMemoryWarningBackground && PresentingURL != nil{
//            MainWebView?.load(URLRequest(url: PresentingURL!))
//            print("Trig WebView reload due to MemoryWarning")
//            DidReceiveMemoryWarningBackground = false
//        }
//        guard let fun = FunVCSingleton else{
//            return
//        }
//        fun.startBackgroundUrlCheck()
//        fun.startProgFetch()
    }
    func applicationWillTerminate(_ application: UIApplication) {
//        print("didReciveMemoryWarning, AppDuringUsage = ",AppDuringUsage)
//        if !AppDuringUsage{DidReceiveMemoryWarningBackground = true}
        
    }
}

