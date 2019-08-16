//
//  AuthViewController.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/3/15.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import UIKit

class AuthViewController: STBaseViewController {

    @IBOutlet weak var contentView: UIView!

    let userProvider = UserProvider()

    override func viewDidLoad() {
        super.viewDidLoad()

        contentView.isHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animate(withDuration: 1, animations: { [weak self] in

            self?.contentView.isHidden = false
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }

    @IBAction func dismissView(_ sender: UIButton) {

        presentingViewController?.dismiss(animated: false, completion: nil)
    }

    @IBAction func onFacebookLogin() {

        userProvider.loginWithFaceBook(from: self, completion: { [weak self] result in

            switch result {

            case .success(let token):

                self?.onSTYLiSHSignIn(token: token)

            case .failure:

                LKProgressHUD.showSuccess(text: "Facebook 登入失敗!")
            }
        })
    }

    func onSTYLiSHSignIn(token: String) {

        LKProgressHUD.show()

        userProvider.signInToSTYLiSH(fbToken: token, completion: { [weak self] result in

            LKProgressHUD.dismiss()

            switch result {

            case .success:

                LKProgressHUD.showSuccess(text: "STYLiSH 登入成功")


            case .failure:

                LKProgressHUD.showSuccess(text: "STYLiSH 登入失敗!")
            }

            DispatchQueue.main.async {

                self?.presentingViewController?.dismiss(animated: false, completion: nil)
            }
        })
    }
    
    // Kevin- Native SingUp/ SingIn
    @IBAction func onSTYLiSHLogin() {
        
        guard let vc = UIStoryboard.nativeSignUp.instantiateInitialViewController() else { return }
        
        vc.modalPresentationStyle = .overCurrentContext
        
        present(vc, animated: true, completion: nil)
    }

    
}
