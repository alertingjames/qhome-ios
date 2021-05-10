//
//  CustomerSignupViewController.swift
//  Qhome
//
//  Created by LGH419 on 7/14/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit

class CustomerSignupViewController: BaseViewController {
    
    @IBOutlet weak var view_name: UIView!
    @IBOutlet weak var edt_name: UITextField!
    @IBOutlet weak var view_email: UIView!
    @IBOutlet weak var edt_email: UITextField!
    @IBOutlet weak var view_password: UIView!
    @IBOutlet weak var edt_password: UITextField!
    @IBOutlet weak var btn_show: UIButton!
    @IBOutlet weak var view_phone: UIView!
    @IBOutlet weak var edt_phone: UITextField!
    @IBOutlet weak var view_address: UIView!
    @IBOutlet weak var edt_address: UITextField!
    @IBOutlet weak var view_area: UIView!
    @IBOutlet weak var edt_area: UITextField!
    @IBOutlet weak var view_street: UIView!
    @IBOutlet weak var edt_street: UITextField!
    @IBOutlet weak var view_house: UIView!
    @IBOutlet weak var edt_house: UITextField!
    @IBOutlet weak var btn_register: UIButton!
    
    
    var show = UIImage(named: "eyeunlock")
    var unshow = UIImage(named: "eyelock")
    var showF = false
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        setRoundShadowView(view: view_name, corner: 25)
        setRoundShadowView(view: view_email, corner: 25)
        setRoundShadowView(view: view_password, corner: 25)
        setRoundShadowView(view: view_phone, corner: 25)
        setRoundShadowView(view: view_address, corner: 25)
        setRoundShadowView(view: view_area, corner: 25)
        setRoundShadowView(view: view_street, corner: 25)
        setRoundShadowView(view: view_house, corner: 25)
        
        setRoundShadowButton(button: btn_register, corner: 25)
        
        edt_email.keyboardType = UIKeyboardType.emailAddress
        
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
    
    @IBAction func register(_ sender: Any) {
        
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
        
        if edt_address.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            gSignupViewController.showToast(msg: Language().enter_address)
            return
        }
        
        if edt_area.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            gSignupViewController.showToast(msg: Language().enter_area)
            return
        }
        
        if edt_street.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            gSignupViewController.showToast(msg: Language().enter_street)
            return
        }
        
        if edt_house.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            gSignupViewController.showToast(msg: Language().enter_house)
            return
        }
        
        self.register(name: (edt_name.text?.trimmingCharacters(in: .whitespacesAndNewlines))!,
                      imei_id: gIMEI,
                      email: (edt_email.text?.trimmingCharacters(in: .whitespacesAndNewlines))!,
                      password: (edt_password.text?.trimmingCharacters(in: .whitespacesAndNewlines))!,
                      phone_number: (edt_phone.text?.trimmingCharacters(in: .whitespacesAndNewlines))!,
                      instagram: "",
                      address: (edt_address.text?.trimmingCharacters(in: .whitespacesAndNewlines))!,
                      area: (edt_area.text?.trimmingCharacters(in: .whitespacesAndNewlines))!,
                      street: (edt_street.text?.trimmingCharacters(in: .whitespacesAndNewlines))!,
                      house: (edt_house.text?.trimmingCharacters(in: .whitespacesAndNewlines))!,
                      role: "customer")
        
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
