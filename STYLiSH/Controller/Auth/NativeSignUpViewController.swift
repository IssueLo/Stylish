//
//  NativeSignUpViewController.swift
//  STYLiSH
//
//  Created by 戴汝羽 on 2019/8/12.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import UIKit

class NativeSignUpViewController: UIViewController {
    
    @IBAction func goBackPage(_ senber: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var passwordConfirmLabel: UILabel!
    
    @IBOutlet weak var userNameTextField: UITextField! {
        didSet {
            
            userNameTextField.isEnabled = false
        }
    }
    
    @IBOutlet weak var userEmailTextField: UITextField!
    
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    @IBOutlet weak var userPasswordConfirmTextField: UITextField! {
        didSet {
            
            userPasswordConfirmTextField.isEnabled = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBOutlet weak var confirmBtn: UIButton! {
        
        didSet {
            
            confirmBtn.clipsToBounds = true
            
            confirmBtn.layer.cornerRadius = 5
        }
    }
    
    @IBAction func selectSignInOrSignUp(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            
            userNameLabel.textColor = UIColor.B4
            
            passwordConfirmLabel.textColor = UIColor.B4
            
            userNameTextField.isEnabled = false
            
            userPasswordConfirmTextField.isEnabled = false
            
        } else {
            
            userNameLabel.textColor = UIColor.B1
            
            passwordConfirmLabel.textColor = UIColor.B1
            
            userNameTextField.isEnabled = true
            
            userPasswordConfirmTextField.isEnabled = true
        }
    }
}
