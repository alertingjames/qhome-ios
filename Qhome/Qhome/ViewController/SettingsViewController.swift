//
//  SettingsViewController.swift
//  Qhome
//
//  Created by LGH419 on 7/11/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController {

    @IBOutlet weak var view_nav: UIView!
    @IBOutlet weak var view_en: UIView!
    @IBOutlet weak var img_en: UIImageView!
    @IBOutlet weak var view_ar: UIView!
    @IBOutlet weak var img_ar: UIImageView!
    @IBOutlet weak var view_notification: UIView!
    @IBOutlet weak var switch_notification: UISwitch!
    
    var noselected = UIImage(named: "radioicon")
    var selected = UIImage(named: "radioicon2")
    
    var selectedLang:String!
    var isNotificationEnabled:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addShadowToBar(view: view_nav)
        
        let tap_en = UITapGestureRecognizer(target: self, action: #selector(self.selEn(_:)))
        view_en.addGestureRecognizer(tap_en)
        
        let tap_ar = UITapGestureRecognizer(target: self, action: #selector(self.selAr(_:)))
        view_ar.addGestureRecognizer(tap_ar)
        
        isNotificationEnabled = UserDefaults.standard.bool(forKey: "notification")
        if isNotificationEnabled{
            switch_notification.isOn = true
        }else{
            switch_notification.isOn = false
        }
        
        let language = UserDefaults.standard.string(forKey: "language")
        
        if language == "ar"{
            selectAr()
            lang = "ar"
        }else{
            selectEn()
            lang = "en"
        }
        
    }
    
    @objc func selEn(_ sender: UITapGestureRecognizer? = nil) {
        selectEn()
    }
    
    func selectEn(){
        clearSelections()
        img_en.image = selected
        selectedLang = "en"
    }
    
    @objc func selAr(_ sender: UITapGestureRecognizer? = nil) {
        selectAr()
    }
    
    func selectAr(){
        clearSelections()
        img_ar.image = selected
        selectedLang = "ar"
    }
    
    func clearSelections(){
        img_en.image = noselected
        img_ar.image = noselected
    }
    
    @IBAction func back(_ sender: Any) {
        dismissViewController()
    }
    
    @IBAction func saveSettings(_ sender: Any) {
        if selectedLang == "en"{
            UserDefaults.standard.set("en", forKey: "language")
            lang = "en"
            AppDelegate.currentStoryboard = UIStoryboard(name: "Main", bundle: nil)
        }else if selectedLang == "ar"{
            UserDefaults.standard.set("ar", forKey: "language")
            lang = "ar"
            AppDelegate.currentStoryboard = UIStoryboard(name: "Arabic", bundle: nil)
        }
        
        if isNotificationEnabled{
            UserDefaults.standard.set(true, forKey: "notification")
        }else{
            UserDefaults.standard.set(false, forKey: "notification")
        }
        
        gNotificationEnabled = isNotificationEnabled
        
        let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "HomeViewController"))!
        conVC.modalPresentationStyle = .fullScreen
        self.transitionVc(vc: conVC, duration: 0.3, type: .fromLeft)
    }
    
    @IBAction func switchNotification(_ sender: Any) {
        if switch_notification.isOn == true{
            isNotificationEnabled = true
        }else{
            isNotificationEnabled = false
        }
    }
}
