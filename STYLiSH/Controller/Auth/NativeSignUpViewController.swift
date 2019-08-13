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
            
            userNameTextField.delegate = self
        }
    }
    
    @IBOutlet weak var userEmailTextField: UITextField! {
        didSet {
            
            userEmailTextField.delegate = self
        }
    }
    
    @IBOutlet weak var userPasswordTextField: UITextField! {
        didSet {
            
            userPasswordTextField.delegate = self
        }
    }
    
    @IBOutlet weak var userPasswordConfirmTextField: UITextField! {
        didSet {
            
            userPasswordConfirmTextField.isEnabled = false
            
            userPasswordConfirmTextField.delegate = self
        }
    }

    @IBOutlet weak var confirmBtn: UIButton! {
        
        didSet {
            
            confirmBtn.setTitle("登入", for: .normal)
            
            confirmBtn.turnOff()
            
            confirmBtn.clipsToBounds = true
            
            confirmBtn.layer.cornerRadius = 5
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    var isSignUp = true
    
    @IBAction func selectSignInOrSignUp(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            
            isSignUp = true
            
            setupForSignIn()
            
        } else {
            
            isSignUp = false
            
            setupForSignUp()
        }
    }
    
    @IBAction func nativeSignIn(_ sender: Any) {
        
        if isSignUp {
            
            guard
                let email = userEmailTextField.text,
                let password = userPasswordTextField.text
            else {
                return
            }
            
            nativeSignIn(email: email, password: password)
            
        } else {
            
            guard
                let name = userNameTextField.text,
                let email = userEmailTextField.text,
                let password = userPasswordTextField.text,
                let confirmPassword = userPasswordConfirmTextField.text
            else {
                return
            }
            
            if password == confirmPassword {
                
                onSTYLiSHSignUp(name: name, email: email, password: password)
                
            } else {
                
                print("密碼錯誤喔")
                LKProgressHUD.showFailure(text: "需要兩次輸入相同的密碼喔", self.view)
            }
        }
    }
    
    
    let userProvider = UserProvider()
    
    func nativeSignIn(email: String, password: String) {
        
//        LKProgressHUD.show()
        
        userProvider.nativeSignInToSTYLiSH(email: email,
                                           password: password,
                                           completion: { [weak self] result in
                                        
//            LKProgressHUD.dismiss()
            
            switch result {
                
            case .success:
                
                LKProgressHUD.showSuccess(text: "STYLiSH 登入成功", self!.view)
                
            case .failure:
                
                LKProgressHUD.showFailure(text: "STYLiSH 登入失敗!", self!.view)
            }
            
            DispatchQueue.main.async {
                
                self?.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
                
            }
        })
    }
    
    func onSTYLiSHSignUp(name: String, email: String, password: String) {
        
//        LKProgressHUD.show()
        
        userProvider.nativeSignUpToSTYLiSH(name: name,
                                     email: email,
                                     password: password,
                                     completion: { [weak self] result in
            
//            LKProgressHUD.dismiss()

            switch result {
                
            case .success:
                
                LKProgressHUD.showSuccess(text: "STYLiSH 註冊成功", self!.view)
                
            case .failure:
                
                LKProgressHUD.showFailure(text: "STYLiSH 註冊失敗!", self!.view)
            }
            
            DispatchQueue.main.async {
                
                self?.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)

            }
        })
    }
    
    func setupForSignIn() {
        
        userEmailTextField.text = ""
        
        userPasswordTextField.text = ""
        
        userNameTextField.text = ""
        
        userPasswordConfirmTextField.text = ""
        
        userNameLabel.textColor = UIColor.B4
        
        passwordConfirmLabel.textColor = UIColor.B4
        
        userNameTextField.isEnabled = false
        
        userPasswordConfirmTextField.isEnabled = false
        
        confirmBtn.setTitle("登入", for: .normal)
    }
    
    func setupForSignUp() {
        
        userEmailTextField.text = ""
        
        userPasswordTextField.text = ""
        
        userNameTextField.text  = ""
        
        userPasswordConfirmTextField.text = ""
        
        userNameLabel.textColor = UIColor.B1
        
        passwordConfirmLabel.textColor = UIColor.B1
        
        userNameTextField.isEnabled = true
        
        userPasswordConfirmTextField.isEnabled = true
        
        confirmBtn.setTitle("確定註冊", for: .normal)
    }
    
}

extension NativeSignUpViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if isSignUp {
            
            if userEmailTextField.text != "" &&
                userPasswordTextField.text != ""
            {
                confirmBtn.turnOn()
                
            } else {
                
                confirmBtn.turnOff()
            }
            
        } else {
            
            if userEmailTextField.text != "" &&
                userPasswordTextField.text != "" &&
                userNameLabel.text != "" &&
                userPasswordConfirmTextField.text != ""
            {
                confirmBtn.turnOn()
                
            } else {
                
                confirmBtn.turnOff()
            }
        }
    }
}
