//
//  STHideNavigationBarController.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/3/3.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import UIKit
import IQKeyboardManager

class STBaseViewController: UIViewController {

    static var identifier: String {
        
        return String(describing: self)
    }
    
    var isHideNavigationBar: Bool {

        return false
    }

    var isEnableResignOnTouchOutside: Bool {

        return true
    }

    var isEnableIQKeyboard: Bool {

        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if isHideNavigationBar {
            navigationItem.hidesBackButton = true
        }

        navigationController?.navigationBar.barTintColor = UIColor.white.withAlphaComponent(0.9)

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        navigationController?.navigationBar.backIndicatorImage = UIImage.asset(.Icons_24px_Back02)

        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage.asset(.Icons_24px_Back02)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if isHideNavigationBar {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }

        if !isEnableIQKeyboard {
            IQKeyboardManager.shared().isEnabled = false
        }

        if !isEnableResignOnTouchOutside {
            IQKeyboardManager.shared().shouldResignOnTouchOutside = false
        }
        
        self.setNeedsStatusBarAppearanceUpdate()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if isHideNavigationBar {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }

        if !isEnableIQKeyboard {
            IQKeyboardManager.shared().isEnabled = true
        }

        if !isEnableResignOnTouchOutside {
            IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        }
    }

    @IBAction func popBack(_ sender: UIButton) {

        navigationController?.popViewController(animated: true)
    }
    
    @objc @IBAction func backToRoot(_ sender: Any) {

        backToRoot(completion: nil)
    }
    
    
}

extension UIViewController {
    
    func backToRoot(completion: (() -> Void)? = nil) {
        
        if presentingViewController != nil {
            
            let superVC = presentingViewController
            
            dismiss(animated: false, completion: nil)
            
            superVC?.backToRoot(completion: completion)
            
            return
        }

        if self is UITabBarController {
            
            let vc = (self as? UITabBarController)?.selectedViewController
            
            vc?.backToRoot(completion: completion)
            
            return
        }
        
        if self is UINavigationController {
            
            (self as! UINavigationController).popToRootViewController(animated: false)
        }
        
        completion?()
    }
}
