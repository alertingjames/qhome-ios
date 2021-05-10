//
//  PhoneVerificationViewController.swift
//  Qhome
//
//  Created by LGH419 on 7/15/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit
import AccountKit

class PhoneVerificationViewController: BaseViewController, AKFViewControllerDelegate  {
    
    @IBOutlet weak var view_nav: UIView!
    @IBOutlet weak var btn_verify: UIButton!
    var _accountKit: AccountKit!
    @IBOutlet weak var view_logo: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addShadowToBar(view: view_nav)
        setRoundShadowButton(button: btn_verify, corner: 25)
        setRoundShadowView(view: view_logo, corner: view_logo.frame.height/2)
        
        if gSignupViewController != nil{
            gSignupViewController.dismiss(animated: false, completion: nil)
        }
        
        if _accountKit == nil {
            _accountKit = AccountKit(responseType: .accessToken)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if _accountKit?.currentAccessToken != nil{
            // if the user is already logged in, go to the main screen
            print("Already Logged in")
            DispatchQueue.main.async(execute: {
                
            })
        }
        else{
            // Show the login screen
        }
    }
    
    @IBAction func back(_ sender: Any) {
        dismissViewController()
    }
    
    @IBAction func verify(_ sender: Any) {
        self.loginWithPhone()
    }
    
    //MARK: - Helper Methods
    
    func prepareLoginViewController(loginViewController: AKFViewController) {
        loginViewController.delegate = self
        
        //Costumize the theme
        let theme:Theme = Theme.default()
        theme.headerBackgroundColor = UIColor(red: 0.325, green: 0.557, blue: 1, alpha: 1)
        theme.headerTextColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        theme.iconColor = UIColor(red: 0.325, green: 0.557, blue: 1, alpha: 1)
        theme.inputTextColor = UIColor(white: 0.4, alpha: 1.0)
        theme.statusBarStyle = .default
        theme.textColor = UIColor(white: 0.3, alpha: 1.0)
        theme.titleColor = UIColor(red: 0.247, green: 0.247, blue: 0.247, alpha: 1)
        loginViewController.setTheme(theme)
    }
    
    //Login with email address
    func loginWithEmail() {
        let inputState = NSUUID().uuidString
        let vc: AKFViewController = _accountKit!.viewControllerForEmailLogin(with: nil, state: inputState) as AKFViewController
        self.prepareLoginViewController(loginViewController: vc)
        self.present(vc as! UIViewController, animated: true, completion: nil)
    }
    
    //Login with phone number
    func loginWithPhone(){
        let inputState = UUID().uuidString
        let vc = (_accountKit?.viewControllerForPhoneLogin(with: nil, state: inputState))!
        vc.isSendToFacebookEnabled = true
        self.prepareLoginViewController(loginViewController: vc)
        self.present(vc as UIViewController, animated: true, completion: nil)
    }
    
    func successfullyLoggedIn(){
        _accountKit?.requestAccount({ (account:Account?, error:Error?) in
            //account ID
            if let accountID = account?.accountID{
                print("Account ID: \(accountID)")
            }
            if let email = account?.emailAddress {
                print(email)
            }
            if let phoneNumber = account?.phoneNumber{
                print("Phone Verified:\(phoneNumber.stringRepresentation())")
                self.logout()
                self.verify(email: gEmail)
            }
        })
    }
    
    func logout(){
        _accountKit?.logOut()
    }
    
    func verify(email:String)
    {
        showLoadingView()
        APIs.verifyEmail(email: email, handleCallback:{
            user, result_code in
            self.dismissLoadingView()
            if result_code == "0"{
                thisUser = user!
                self.showToast(msg: Language().verified)
                UserDefaults.standard.set(thisUser.email, forKey: "email")
                UserDefaults.standard.set(thisUser.role, forKey: "role")
                gHomeViewController.menu_vc.view_signuplogin.visibility = .gone
                gHomeViewController.menu_vc.view_logout.visibility = .visible
                print("User Role!!!\(user!.role)")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    if thisUser.role == "producer"{
                        let conVC = AppDelegate.currentStoryboard.instantiateViewController(withIdentifier: "RegisterStoreViewController")
                        conVC.modalPresentationStyle = .fullScreen
                        self.transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
                    }else{
                        let conVC = AppDelegate.currentStoryboard.instantiateViewController(withIdentifier: "HomeViewController")
                        conVC.modalPresentationStyle = .fullScreen
                        self.transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
                    }
                }
            }else {
                self.showToast(msg: Language().serverissue)
            }
            
        })
    }
    
}

extension PhoneVerificationViewController{
    
    func viewController(viewController: UIViewController!, didCompleteLoginWithAccessToken accessToken: AccessToken!, state: String!) {
        print("did complete login with access token \(accessToken.tokenString) state \(state)")
    }
    
    // handle callback on successful login to show authorization code
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didCompleteLoginWithAuthorizationCode code: String!, state: String!) {
        // Pass the code to your own server and have your server exchange it for a user access token.
        // You should wait until you receive a response from your server before proceeding to the main screen.
        
        /*
         [self sendAuthorizationCodeToServer:code];
         [self proceedToMainScreen];
         */
        print("didCompleteLoginWithAuthorizationCode")
    }
    
    func viewControllerDidCancel(_ viewController: (UIViewController & AKFViewController)!) {
        // ... handle user cancellation of the login process ...
        print("viewControllerDidCancel")
    }
    
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didFailWithError error: Error!) {
        // ... implement appropriate error handling ...
        print("\(viewController) did fail with error: \(error.localizedDescription)")
    }
    
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didCompleteLoginWith accessToken: AccessToken!, state: String!) {
        print("didCompleteLoginWith")
        self.successfullyLoggedIn()
    }
}










































