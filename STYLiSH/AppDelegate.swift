//
//  AppDelegate.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/2/11.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import UIKit
import AdSupport
import IQKeyboardManager
import FBSDKCoreKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    static let shared = UIApplication.shared.delegate as! AppDelegate
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        TPDSetup.setWithAppId(
            Bundle.STValueForInt32(key: STConstant.tapPayAppID),
            withAppKey: Bundle.STValueForString(key: STConstant.tapPayAppKey),
            with: TPDServerType.sandBox
        )
        
        TPDSetup.shareInstance().setupIDFA(
            ASIdentifierManager.shared().advertisingIdentifier.uuidString
        )
        
        TPDSetup.shareInstance().serverSync()
        
        IQKeyboardManager.shared().isEnabled = true
        
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        
        FBSDKApplicationDelegate.sharedInstance()!.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return FBSDKApplicationDelegate.sharedInstance()!.application(app, open:url, options:options)
    }
}

