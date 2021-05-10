//
//  MyProfileViewController.swift
//  Qhome
//
//  Created by LGH419 on 7/21/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit
import SCLAlertView

class MyProfileViewController: BaseViewController {
    
    @IBOutlet weak var view_nav: UIView!
    @IBOutlet weak var view_name: UIView!
    @IBOutlet weak var view_instagram: UIView!
    @IBOutlet weak var view_phone: UIView!
    @IBOutlet weak var view_address: UIView!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_email: UILabel!
    @IBOutlet weak var lbl_instagram: UILabel!
    @IBOutlet weak var lbl_phone: UILabel!
    @IBOutlet weak var lbl_address: UILabel!
    @IBOutlet weak var lbl_addressline: UILabel!
    @IBOutlet weak var view_line_instagram: UIView!
    
    var area = ""
    var street = ""
    var house = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        gPhoneId = 0
        gAddressId = 0

        addShadowToBar(view: view_nav)
        
        self.lbl_name.text = thisUser.name
        self.lbl_email.text = thisUser.email
        if thisUser.role == "producer"{
            self.view_instagram.visibility = .visible
            self.view_line_instagram.visibility = .visible
            self.lbl_instagram.text = thisUser.instagram
        }else{
            self.view_instagram.visibility = .gone
            self.view_line_instagram.visibility = .gone
        }
        
        self.lbl_phone.text = thisUser.phone_number
        
        var tap = UITapGestureRecognizer(target: self, action: #selector(self.editName(_:)))
        self.view_name.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.editInstagram(_:)))
        self.view_instagram.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.editPhone(_:)))
        self.view_phone.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.editAddress(_:)))
        self.view_address.addGestureRecognizer(tap)
        
    }
    
    @objc func editName(_ sender: UITapGestureRecognizer? = nil) {
        self.openEditBox(option: "name")
    }
    
    @objc func editInstagram(_ sender: UITapGestureRecognizer? = nil) {
        self.openEditBox(option: "instagram")
    }
    
    @objc func editPhone(_ sender: UITapGestureRecognizer? = nil) {
        let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "AddressViewController"))!
        conVC.modalPresentationStyle = .fullScreen
        gAddrOption = "phone"
        transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
    }
    
    @objc func editAddress(_ sender: UITapGestureRecognizer? = nil) {
        let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "AddressViewController"))!
        conVC.modalPresentationStyle = .fullScreen
        gAddrOption = "addr"
        transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
    }
    
    func openEditBox(option:String){
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: true
        )
        
        let alert = SCLAlertView(appearance: appearance)
        
        
        if option == "name"{
            let name = alert.addTextField(Language().enter_name)
            alert.addButton(Language().save) {
                if name.text == ""{
                    self.showToast(msg: Language().enter_name)
                    return
                }
                self.lbl_name.text = name.text
            }
            alert.showEdit(Language().myname, subTitle: Language().change_name)
        }else if option == "instagram"{
            let instagram = alert.addTextField(Language().enter_instagram)
            alert.addButton(Language().save) {
                if instagram.text == ""{
                    self.showToast(msg: Language().enter_instagram)
                    return
                }
                self.lbl_instagram.text = instagram.text
            }
            alert.showEdit(Language().instagramaccount, subTitle: Language().change_instagram)
        }
    }
    
    @IBAction func back(_ sender: Any) {
        dismissViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getPhones()
        self.getAddresses()
    }
    
    @IBAction func save(_ sender: Any) {
        self.updateMember(member_id: thisUser.idx, name: self.lbl_name.text!, email: self.lbl_email.text!, phone_number: self.lbl_phone.text!, instagram: self.lbl_instagram.text!, address: self.lbl_address.text!, area: self.area, street: self.street, house: self.house)
    }
    
    func getPhones(){
        APIs.getPhones(member_id: thisUser.idx, imei_id: gIMEI, handleCallback: {
            phones, result_code in
            print(result_code)
            if result_code == "0"{
                gPhones.removeAll()
                for phone in phones!{
                    gPhones.append(phone)
                }
                
                if gPhones.count > 0{
                    self.lbl_phone.text = (gPhones[Int(gPhoneId)]).phoneNumber
                }else{
                    if thisUser.idx > 0{
                        self.lbl_phone.text = thisUser.phone_number
                    }
                }
            }
        })
    }
    
    func getAddresses(){
        APIs.getAddresses(member_id: thisUser.idx, imei_id: gIMEI, handleCallback: {
            addresses, result_code in
            print(result_code)
            if result_code == "0"{
                gAddresses.removeAll()
                for address in addresses!{
                    gAddresses.append(address)
                }
                
                if thisUser.idx > 0 && thisUser.address == ""{
                    if gAddresses.count > 0{
                        self.lbl_address.text = gAddresses[Int(gAddressId)].address
                        self.lbl_addressline.text = gAddresses[Int(gAddressId)].area + ", " + gAddresses[Int(gAddressId)].street + ", " + gAddresses[Int(gAddressId)].house
                        self.area = gAddresses[Int(gAddressId)].area
                        self.street = gAddresses[Int(gAddressId)].street
                        self.house = gAddresses[Int(gAddressId)].house
                    }
                }else{
                    if gAddresses.count > 0{
                        self.lbl_address.text = gAddresses[Int(gAddressId)].address
                        self.lbl_addressline.text = gAddresses[Int(gAddressId)].area + ", " + gAddresses[Int(gAddressId)].street + ", " + gAddresses[Int(gAddressId)].house
                        self.area = gAddresses[Int(gAddressId)].area
                        self.street = gAddresses[Int(gAddressId)].street
                        self.house = gAddresses[Int(gAddressId)].house
                    }else{
                        self.lbl_address.text = thisUser.address
                        self.lbl_addressline.text = thisUser.area + ", " + thisUser.street + ", " + thisUser.house
                        self.area = thisUser.area
                        self.street = thisUser.street
                        self.house = thisUser.house
                    }
                }
            }
        })
    }
    
    func updateMember(
        member_id:Int64,
        name:String,
        email:String,
        phone_number:String,
        instagram:String,
        address:String,
        area:String,
        street:String,
        house:String
    )
    {
        self.view.endEditing(true)
        showLoadingView()
        APIs.updateMember(member_id:member_id, name:name, email: email, phone_number: phone_number, instagram: instagram, address: address, area: area, street: street, house: house, handleCallback:{
            user, result_code in
            self.dismissLoadingView()
            print(result_code)
            if result_code == "0"{
                self.showToast(msg: Language().profileupdated)
                self.dismissViewController()
            }else if result_code == "1" {
                self.showToast(msg: Language().unregistereduser)
                self.dismissViewController()
            }else{
                self.showToast(msg: Language().serverissue)
            }
            
        })
    }
    
}
