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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        userNameTextField.constant -= view.bounds.width
        
//        userNameTextField
        
//        let xorig = self.view2.center.x
//        let opts = UIViewAnimationOptions.autoreverse
//        UIView.animate(withDuration: 1, delay: 0, options: opts, animations: {
//            self.view2.center.x -= 100
//        }, completion: { _ in
//            self.view2.center.x = xorig
//        })

//        confirmBtn.alpha = 0.0
    }
    
    var isSignIn = true
    
    @IBAction func selectSignInOrSignUp(_ sender: UISegmentedControl) {
        
        confirmBtn.turnOff()
        
        if sender.selectedSegmentIndex == 0 {
            
            isSignIn = true
            
            setupForSignIn()
            
        } else {
            
            isSignIn = false
            
            setupForSignUp()
        }
    }
    
    func btnFail() {
        
        let bounds = self.confirmBtn.bounds
        UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.05, initialSpringVelocity: 10, options: .transitionFlipFromBottom, animations: {
            self.confirmBtn.bounds = CGRect(x: bounds.origin.x - 10, y: bounds.origin.y, width: bounds.size.width , height: bounds.size.height)
        }, completion: nil)
    }
    
    func btnPass() {
        
        let bounds = self.confirmBtn.bounds
        UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.15, initialSpringVelocity: 10, options: .transitionFlipFromBottom, animations: {
            self.confirmBtn.bounds = CGRect(x: bounds.origin.x - 20, y: bounds.origin.y, width: bounds.size.width + 50, height: bounds.size.height)
        }, completion: nil)
    }
    
    @IBAction func nativeSignIn(_ sender: UIButton) {
        
        if isSignIn {
            
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
                
                btnPass()
                
                LKProgressHUD.showFailure(text: "請確認密碼要跟密碼確認相同喔", self.view)
                
                confirmBtn.turnOff()
            }
        }
    }
    
    let userProvider = UserProvider()
    
    func nativeSignIn(email: String, password: String) {
        
        userProvider.nativeSignInToSTYLiSH(email: email,
                                           password: password,
                                           completion: { [weak self] result in
                                            
            switch result {
                
            case .success:

                print("STYLiSH 登入成功")
                
                DispatchQueue.main.async {
                    
                    LKProgressHUD.showSuccess(text: "STYLiSH 登入成功")
                    
                    self?.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
                    
                }
                
            case .failure:
                
                print("STYLiSH 登入失敗!")
                
                DispatchQueue.main.async {
                    
                    self!.btnFail()
                    
                    LKProgressHUD.showFailure(text: "STYLiSH 登入失敗!", self!.view)
                    
                }
                
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
                
                print("STYLiSH 註冊成功")
                
                DispatchQueue.main.async {
                    
                    LKProgressHUD.showSuccess(text: "STYLiSH 註冊成功")
                    
                    self?.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
                }
                
            case .failure:
                
                print("STYLiSH 註冊失敗!")
                
                DispatchQueue.main.async {
                    
                    LKProgressHUD.showFailure(text: "STYLiSH 註冊失敗!", self!.view)
                }
                
                self?.btnFail()
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
        
        if isSignIn {
            
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
