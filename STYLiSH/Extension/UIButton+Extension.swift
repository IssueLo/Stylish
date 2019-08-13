//
//  UIButton+Extension.swift
//  STYLiSH
//
//  Created by 戴汝羽 on 2019/8/12.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import UIKit

extension UIButton {
    
    func turnOn() {
        
        self.isEnabled = true
        
        self.alpha = 1
    }
    
    func turnOff()  {
        
        self.isEnabled = false
        
        self.alpha = 0.6
    }
}
