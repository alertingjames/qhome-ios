//
//  LoginViewController.swift
//  Qhome
//
//  Created by LGH419 on 7/14/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit
import SCLAlertView

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var view_nav: UIView!
    @IBOutlet weak var view_email: UIView!
    @IBOutlet weak var view_password: UIView!
    @IBOutlet weak var view_producer: UIView!
    @IBOutlet weak var view_customer: UIView!
    @IBOutlet weak var btn_login: UIButton!
    @IBOutlet weak var img_producer: UIImageView!
    @IBOutlet weak var img_customer: UIImageView!
    @IBOutlet weak var btn_show: UIButton!
    @IBOutlet weak var edt_email: UITextField!
    @IBOutlet weak var edt_password: UITextField!
    
    var noselected = UIImage(named: "radioicon")
    var selected = UIImage(named: "radioicon2")
    
    var show = UIImage(named: "eyeunlock")
    var unshow = UIImage(named: "eyelock")
    var showF = false
    
    var selectedRole:String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()

        addShadowToBar(view: view_nav)
        setRoundShadowView(view: view_email, corner: 25)
        setRoundShadowView(view: view_password, corner: 25)
        setRoundShadowButton(button: btn_login, corner: 25)
        
        edt_email.keyboardType = UIKeyboardType.emailAddress
        
        let tap_pro = UITapGestureRecognizer(target: self, action: #selector(self.selProducer(_:)))
        view_producer.addGestureRecognizer(tap_pro)
        
        let tap_cus = UITapGestureRecognizer(target: self, action: #selector(self.selCustomer(_:)))
        view_customer.addGestureRecognizer(tap_cus)
        
        let email = UserDefaults.standard.string(forKey: "email")
        let role = UserDefaults.standard.string(forKey: "role")
        
    }
    
    func clearSelections(){
        img_producer.image = noselected
        img_customer.image = noselected
    }
    
    @objc func selProducer(_ sender: UITapGestureRecognizer? = nil) {
        selectProducer()
    }
    
    func selectProducer(){
        clearSelections()
        img_producer.image = selected
        selectedRole = "producer"
    }
    
    @objc func selCustomer(_ sender: UITapGestureRecognizer? = nil) {
        selectCustomer()
    }
    
    func selectCustomer(){
        clearSelections()
        img_customer.image = selected
        selectedRole = "customer"
    }
    
    @IBAction func showPassword(_ sender: Any) {
        if showF == false{
            btn_show.setImage(unshow, for: UIControl.State.normal)
            showF = true
            edt_password.isSecureTextEntry = false
        }else{
            btn_show.setImage(show, for: UIControl.State.normal)
            showF = false
            edt_password.isSecureTextEntry = true
        }
    }
    
    @IBAction func back(_ sender: Any) {
        dismissViewController()
    }
    
    @IBAction func toSignup(_ sender: Any) {
        let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "SignupViewController"))!
        conVC.modalPresentationStyle = .fullScreen
        transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
    }
    
    @IBAction func toForgotPassword(_ sender: Any) {
        let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController"))!
        conVC.modalPresentationStyle = .fullScreen
        transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
    }
    
    @IBAction func login(_ sender: Any) {
        
        if edt_email.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            showToast(msg: Language().enter_email)
            return
        }
        
        if isValidEmail(testStr: (edt_email.text?.trimmingCharacters(in: .whitespacesAndNewlines))!) == false{
            showToast(msg: Language().enter_valid_email)
            return
        }
        
        if edt_password.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            showToast(msg: Language().enter_password)
            return
        }
        
        if selectedRole == ""{
            showToast(msg: Language().select_role)
            return
        }
        
        self.login(email: (edt_email.text?.trimmingCharacters(in: .whitespacesAndNewlines))!,
                   password: (edt_password.text?.trimmingCharacters(in: .whitespacesAndNewlines))!,
                   role: selectedRole)
    }
    
    func login(email:String, password: String, role:String)
    {
        self.view.endEditing(true)
        showLoadingView()
        APIs.login(email: email, password: password, role:role, handleCallback:{
            user, result_code in
            self.dismissLoadingView()
            print(result_code)
            if result_code == "0"{
                
                if user?.status == "removed"{
                    UserDefaults.standard.set("", forKey: "email")
                    UserDefaults.standard.set("", forKey: "role")
                    thisUser.idx = 0
                    gHomeViewController.menu_vc.view_signuplogin.visibility = .visible
                    gHomeViewController.menu_vc.view_logout.visibility = .gone
                    let appearance = SCLAlertView.SCLAppearance(
                        kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
                        kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
                        kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
                        showCloseButton: true
                    )
                    let alert = SCLAlertView(appearance: appearance)
                    alert.addButton(Language().ok) {
                        self.dismissViewController()
                    }
                    alert.showWarning(Language().warning, subTitle: Language().account_deleted)
                    return
                }
                
                if user?.auth_status == ""{
                    thisUser.idx = 0
                    self.showToast(msg: Language().verify_phone)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        let conVC = AppDelegate.currentStoryboard.instantiateViewController(withIdentifier: "PhoneVerificationViewController")
                        conVC.modalPresentationStyle = .fullScreen
                        gEmail = user?.email
                        self.transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
                    }
                }else{
                    thisUser = user!
                    self.showToast(msg: Language().login_success)
                    UserDefaults.standard.set(thisUser.email, forKey: "email")
                    UserDefaults.standard.set(thisUser.role, forKey: "role")
                    gHomeViewController.menu_vc.view_signuplogin.visibility = .gone
                    gHomeViewController.menu_vc.view_logout.visibility = .visible
                    gHomeViewController.getNoitificaitons()
                    self.dismissViewController()
                }
            }else if result_code == "1" {
                thisUser.idx = 0
                self.showToast(msg: Language().unregistereduser)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    let conVC = AppDelegate.currentStoryboard.instantiateViewController(withIdentifier: "SignupViewController")
                    conVC.modalPresentationStyle = .fullScreen
                    self.transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
                }
            }else if result_code == "2" {
                thisUser.idx = 0
                self.showToast(msg: Language().incorrectpassword)
            }
            
        })
    }
    
}


