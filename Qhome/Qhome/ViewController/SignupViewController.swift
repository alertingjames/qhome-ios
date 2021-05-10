//
//  SignupViewController.swift
//  Qhome
//
//  Created by LGH419 on 7/14/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit
import CountryPickerView

class SignupViewController: BaseViewController, CountryPickerViewDelegate, CountryPickerViewDataSource {
    
    @IBOutlet weak var view_nav: UIView!
    @IBOutlet weak var view_tabs: UIView!
    @IBOutlet weak var view_producer: UIView!
    @IBOutlet weak var view_customer: UIView!    
    @IBOutlet weak var lbl_producer: UILabel!
    @IBOutlet weak var lbl_customer: UILabel!
    
    @IBOutlet weak var view_container: UIView!
    
    let unSelAttrs = [
        NSAttributedString.Key.foregroundColor : lightPrimaryColor,
        NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
    ] as [NSAttributedString.Key : Any]
    
    let selAttrs = [
        NSAttributedString.Key.foregroundColor : primaryColor,
        NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17),
        NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue,
    ] as [NSAttributedString.Key : Any]
    
    var selected:String = "producer"
    
    var producerFrame:ProducerSignupViewController!
    var customerFrame:CustomerSignupViewController!
    
    let countryPickerView = CountryPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()

        gSignupViewController = self
        initUI()
        
        countryPickerView.delegate = self
        countryPickerView.dataSource = self
        
        // countryPickerView.showCountriesList(from: self)
    }
    
    func resetTabUI(){
        
        self.view_producer.layer.backgroundColor = nil
        self.view_customer.layer.backgroundColor = nil
        
        self.lbl_producer.attributedText = NSAttributedString(string: Language().producer, attributes: unSelAttrs)
        self.lbl_customer.attributedText = NSAttributedString(string: Language().customer, attributes: unSelAttrs)
        
    }

    @IBAction func back(_ sender: Any) {
        dismissViewController()
    }
    
    func initUI(){
        
        self.view_producer.frame.size.width = UIScreen.main.bounds.width/2
        self.view_customer.frame.size.width = UIScreen.main.bounds.width/2
        
        resetTabUI()
        self.view_producer.layer.backgroundColor = UIColor.white.cgColor
        self.view_producer.roundCorners(corners: [.topLeft, .topRight], radius: 15)
        self.lbl_producer.attributedText = NSAttributedString(string: Language().producer, attributes: selAttrs)
        
        addShadowToBar(view: view_nav)
        
        self.producerFrame = self.storyboard!.instantiateViewController(withIdentifier: "ProducerSignupViewController") as? ProducerSignupViewController
        self.producerFrame.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.producerFrame.view.frame.size.height)
        
        self.customerFrame = self.storyboard!.instantiateViewController(withIdentifier: "CustomerSignupViewController") as? CustomerSignupViewController
        self.customerFrame.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.customerFrame.view.frame.size.height)
        
        // So important!!!
        self.view_container.frame.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 100.0)
        
        let tap_producer = UITapGestureRecognizer(target: self, action: #selector(self.tappedProducer(_:)))
        self.view_producer.addGestureRecognizer(tap_producer)
        
        let tap_customer = UITapGestureRecognizer(target: self, action: #selector(self.tappedCustomer(_:)))
        self.view_customer.addGestureRecognizer(tap_customer)
        
        UIView.animate(withDuration: 0.3){() -> Void in
            self.producerFrame.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            self.view_container.addSubview(self.producerFrame.view)
        }
    }
    
    @objc func tappedProducer(_ sender: UITapGestureRecognizer? = nil) {
        self.selPro()
    }
    
    func selPro(){
        
        if selected != "producer"{
            self.view_producer.frame.size.width = UIScreen.main.bounds.width/2
            
            self.customerFrame.view.removeFromSuperview()
            resetTabUI()
            self.view_producer.layer.backgroundColor = UIColor.white.cgColor
            self.view_producer.roundCorners(corners: [.topLeft, .topRight], radius: 15)
            self.lbl_producer.attributedText = NSAttributedString(string: Language().producer, attributes: selAttrs)
            
            selected = "producer"
            
            UIView.animate(withDuration: 0.3){() -> Void in
                self.producerFrame.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                self.view_container.addSubview(self.producerFrame.view)
            }
        }
        
    }
    
    @objc func tappedCustomer(_ sender: UITapGestureRecognizer? = nil) {
        self.selCus()
    }
    
    func selCus(){
        if selected != "customer"{
            self.view_customer.frame.size.width = UIScreen.main.bounds.width/2
            
            self.producerFrame.view.removeFromSuperview()
            resetTabUI()
            self.view_customer.layer.backgroundColor = UIColor.white.cgColor
            self.view_customer.roundCorners(corners: [.topLeft, .topRight], radius: 15)
            self.lbl_customer.attributedText = NSAttributedString(string: Language().customer, attributes: selAttrs)
            
            selected = "customer"
            
            UIView.animate(withDuration: 0.3){() -> Void in
                self.customerFrame.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                self.view_container.addSubview(self.customerFrame.view)
            }
        }
    }
    
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country){
        print(country.phoneCode)
    }
    
    
}
