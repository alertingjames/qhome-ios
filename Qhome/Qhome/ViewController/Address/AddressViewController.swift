//
//  AddressViewController.swift
//  Qhome
//
//  Created by LGH419 on 7/19/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit
import SCLAlertView
import CountryPickerView

class AddressViewController: BaseViewController, CountryPickerViewDelegate, CountryPickerViewDataSource {
    
    @IBOutlet weak var view_tabs: UIView!
    @IBOutlet weak var view_address: UIView!
    @IBOutlet weak var view_phone: UIView!
    @IBOutlet weak var lbl_address: UILabel!
    @IBOutlet weak var lbl_phone: UILabel!
    @IBOutlet weak var view_address_indicator: UIView!
    @IBOutlet weak var view_phone_indicator: UIView!
    @IBOutlet weak var view_container: UIView!
    @IBOutlet weak var btn_add: UIButton!
    
    let unSelAttrs = [
        NSAttributedString.Key.foregroundColor : lightPrimaryColor,
        NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
        ] as [NSAttributedString.Key : Any]
    
    let selAttrs = [
        NSAttributedString.Key.foregroundColor : primaryColor,
        NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15),
        ] as [NSAttributedString.Key : Any]
    
    var addressFrame:AddressListViewController!
    var phoneFrame:PhoneListViewController!
    
    var selected:String = ""
    
    let countryPickerView = CountryPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        gAddressViewController = self

        addShadowToBar(view: view_tabs)
        setRoundShadowButton(button: btn_add, corner: btn_add.frame.height/2)
        
        self.addressFrame = self.storyboard!.instantiateViewController(withIdentifier: "AddressListViewController") as? AddressListViewController
        self.addressFrame.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.addressFrame.view.frame.size.height)
        
        self.phoneFrame = self.storyboard!.instantiateViewController(withIdentifier: "PhoneListViewController") as? PhoneListViewController
        self.phoneFrame.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.phoneFrame.view.frame.size.height)
        
        // So important!!!
        self.view_container.frame.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 70.0)
        
        var tap = UITapGestureRecognizer(target: self, action: #selector(self.tappedAddress(_:)))
        self.view_address.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.tappedPhone(_:)))
        self.view_phone.addGestureRecognizer(tap)
        
        if gAddrOption == "addr"{
            self.selAddress()
        }else if gAddrOption == "phone"{
            self.selPhone()
        }else{
            self.selAddress()
        }
        
//        countryPickerView.showCountriesList(from: self)
//        countryPickerView.delegate = self
//        countryPickerView.dataSource = self
    }
    
    @IBAction func back(_ sender: Any) {
        gAddressViewController = nil
        dismissViewController()
    }
    
    @objc func tappedAddress(_ sender: UITapGestureRecognizer? = nil) {
        self.selAddress()
    }
    
    @objc func tappedPhone(_ sender:UITapGestureRecognizer? = nil){
        self.selPhone()
    }
    
    func resetTabs(){
        
        self.lbl_address.attributedText = NSAttributedString(string: Language().address, attributes: unSelAttrs)
        self.lbl_phone.attributedText = NSAttributedString(string: Language().phone, attributes: unSelAttrs)
        
        self.view_address_indicator.isHidden = true
        self.view_phone_indicator.isHidden = true
        
    }
    
    func selAddress(){
        if selected != "address"{
            selected = "address"
            self.phoneFrame.view.removeFromSuperview()
            self.resetTabs()
            self.lbl_address.attributedText = NSAttributedString(string: Language().address, attributes: selAttrs)
            self.view_address_indicator.isHidden = false
            
            UIView.animate(withDuration: 0.3){() -> Void in
                self.addressFrame.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.addressFrame.view.frame.size.height)
                self.view_container.addSubview(self.addressFrame.view)
            }
        }
    }
    
    func selPhone(){
        if selected != "phone"{
            selected = "phone"
            self.addressFrame.view.removeFromSuperview()
            self.resetTabs()
            self.lbl_phone.attributedText = NSAttributedString(string: Language().phone, attributes: selAttrs)
            self.view_phone_indicator.isHidden = false
            
            UIView.animate(withDuration: 0.3){() -> Void in
                self.phoneFrame.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.phoneFrame.view.frame.size.height)
                self.view_container.addSubview(self.phoneFrame.view)
            }
        }
    }

    @IBAction func add(_ sender: Any) {
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: true
        )

        let alert = SCLAlertView(appearance: appearance)


        if selected == "address"{

            let address = alert.addTextField(Language().enter_address)
            let area = alert.addTextField(Language().enter_area)
            let street = alert.addTextField(Language().enter_street)
            let house = alert.addTextField(Language().enter_house)
            alert.addButton(Language().save) {
                if address.text == ""{
                    self.showToast(msg: Language().enter_address)
                    return
                }
                if area.text == ""{
                    self.showToast(msg: Language().enter_area)
                    return
                }
                if street.text == ""{
                    self.showToast(msg: Language().enter_street)
                    return
                }
                if house.text == ""{
                    self.showToast(msg: Language().enter_house)
                    return
                }
                
                APIs.saveAddress(member_id: thisUser.idx, imei_id: gIMEI, address: address.text!,
                                 area: area.text!, street: street.text!, house: house.text!, handleCallback: {
                    result_code in
                    print(result_code)
                    if result_code == "0"{
                        self.showToast(msg: Language().addressadded)
                        self.addressFrame.getAddresses()
                    }
                    else{
                        self.showToast(msg: Language().serverissue)
                    }
                })
                
            }
            alert.showEdit(Language().shipping_address, subTitle: Language().enter1moreshippingaddress)
        }else if selected == "phone"{

            let phoneNumber = alert.addTextField(Language().enterfullphone)
            alert.addButton(Language().save) {
                if phoneNumber.text == ""{
                    self.showToast(msg: Language().enterfullphone)
                    return
                }
                
                APIs.savePhone(member_id: thisUser.idx, imei_id: gIMEI, phone_number: phoneNumber.text!, handleCallback: {
                    result_code in
                    print(result_code)
                    if result_code == "0"{
                        self.showToast(msg: Language().phoneadded)
                        self.phoneFrame.getPhones()
                    }
                    else{
                        self.showToast(msg: Language().serverissue)
                    }
                })
                
            }
            alert.showEdit(Language().phone, subTitle: Language().enter1morephonenumber)
        }
        
    }
    
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country){
        print(country.phoneCode)
    }
    
}
