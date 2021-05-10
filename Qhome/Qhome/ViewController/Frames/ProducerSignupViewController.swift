//
//  ProducerSignupViewController.swift
//  Qhome
//
//  Created by LGH419 on 7/14/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit

class ProducerSignupViewController: BaseViewController {
    
    @IBOutlet weak var view_name: UIView!
    @IBOutlet weak var edt_name: UITextField!
    @IBOutlet weak var view_email: UIView!
    @IBOutlet weak var edt_email: UITextField!
    @IBOutlet weak var view_password: UIView!
    @IBOutlet weak var edt_password: UITextField!
    @IBOutlet weak var btn_show: UIButton!
    @IBOutlet weak var view_phone: UIView!
    @IBOutlet weak var edt_phone: UITextField!
    
    @IBOutlet weak var view_instagram: UIView!
    @IBOutlet weak var edt_instagram: UITextField!
    @IBOutlet weak var btn_continue: UIButton!
    
    var show = UIImage(named: "eyeunlock")
    var unshow = UIImage(named: "eyelock")
    var showF = false
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setRoundShadowView(view: view_name, corner: 25)
        setRoundShadowView(view: view_email, corner: 25)
        setRoundShadowView(view: view_password, corner: 25)
        setRoundShadowView(view: view_phone, corner: 25)
        setRoundShadowView(view: view_instagram, corner: 25)
        setRoundShadowButton(button: btn_continue, corner: 25)
        
        edt_email.keyboardType = UIKeyboardType.emailAddress
        
    }

    @IBAction func continueSignup(_ sender: Any) {
        
        if edt_name.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            print("Enter your name")
            gSignupViewController.showToast(msg: Language().enter_name)
            return
        }

        if edt_email.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            gSignupViewController.showToast(msg: Language().enter_email)
            return
        }

        if isValidEmail(testStr: (edt_email.text?.trimmingCharacters(in: .whitespacesAndNewlines))!) == false{
            gSignupViewController.showToast(msg: Language().enter_valid_email)
            return
        }

        if edt_password.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            gSignupViewController.showToast(msg: Language().enter_password)
            return
        }

        if edt_phone.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            gSignupViewController.showToast(msg: Language().enter_phone)
            return
        }

        if edt_instagram.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            gSignupViewController.showToast(msg: Language().enter_instagram)
            return
        }
        
        self.register(name: (edt_name.text?.trimmingCharacters(in: .whitespacesAndNewlines))!,
                      imei_id: gIMEI,
                      email: (edt_email.text?.trimmingCharacters(in: .whitespacesAndNewlines))!,
                      password: (edt_password.text?.trimmingCharacters(in: .whitespacesAndNewlines))!,
                      phone_number: (edt_phone.text?.trimmingCharacters(in: .whitespacesAndNewlines))!,
                      instagram: (edt_instagram.text?.trimmingCharacters(in: .whitespacesAndNewlines))!,
                      address: "",
                      area: "",
                      street: "",
                      house: "",
                      role: "producer")
        
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
    
    func register(name:String,
                  imei_id:String,
                  email:String,
                  password: String,
                  phone_number:String,
                  instagram:String,
                  address:String,
                  area:String,
                  street:String,
                  house:String,
                  role:String)
    {
        self.view.endEditing(true)
        showLoadingView()
        APIs.register(name:name, imei:imei_id, email: email, password: password, phone_number: phone_number, instagram: instagram, address: address, area: area, street: street, house: house, role:role, handleCallback:{
            user, result_code in
            self.dismissLoadingView()
            print(result_code)
            if result_code == "0"{
                print("Registered!!!")
                self.showToast(msg: Language().verify_phone)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    let conVC = AppDelegate.currentStoryboard.instantiateViewController(withIdentifier: "PhoneVerificationViewController")
                    conVC.modalPresentationStyle = .fullScreen
                    gEmail = user?.email
                    self.transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
                }
            }else if result_code == "1" {
                self.showToast(msg: Language().existingemail)
            }else if result_code == "2" {
                self.showToast(msg: Language().existinguser)
                gSignupViewController.dismissViewController()
            }
            
        })
    }
    
}
