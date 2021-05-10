//
//  ChooseLangViewController.swift
//  Qhome
//
//  Created by LGH419 on 7/9/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit

class ChooseLangViewController: BaseViewController {

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var view_buttons: UIView!
    @IBOutlet weak var img_en: UIImageView!
    @IBOutlet weak var img_ar: UIImageView!
    @IBOutlet weak var btn_remember: UIButton!
    @IBOutlet weak var view_remember: UIView!
    @IBOutlet weak var btn_continue: UIButton!
    @IBOutlet weak var view_en: UIView!
    @IBOutlet weak var view_ar: UIView!
    @IBOutlet weak var btn_remember_choice: UIButton!
    
    let checkbox = UIImage(named: "checked_maroon")
    let noCheckBox = UIImage(named: "unchecked_maroon")
    
    let selectediconar = UIImage(named: "checked_maroon_flip")
    let noselectediconar = UIImage(named: "unchecked_maroon_flip")
    
    var isRemembered:Bool = false
    var selectedLang:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addShadowToNavBar(navBar:navBar)
//        let title = UINavigationItem(title: Language().choose_lang);
//        navBar.setItems([title], animated: false);
        
        setRoundShadowButton(button: btn_continue, corner: 25)
        setRoundShadowView(view: view_buttons, corner: 5)
        
        let tap_en = UITapGestureRecognizer(target: self, action: #selector(self.handleEnTap(_:)))
        view_en.addGestureRecognizer(tap_en)
        
        let tap_ar = UITapGestureRecognizer(target: self, action: #selector(self.handleArTap(_:)))
        view_ar.addGestureRecognizer(tap_ar)
        
        resetUIButtons()
        setSelectedCircularImage(image: img_en)
        
    }
    
    func resetUIButtons(){
        setDefaultCircularImage(image: img_en)
        setDefaultCircularImage(image: img_ar)
    }
    
    @objc func handleEnTap(_ sender: UITapGestureRecognizer? = nil) {
        resetUIButtons()
        setSelectedCircularImage(image: img_en)
        selectedLang = "en"
    }
    
    @objc func handleArTap(_ sender: UITapGestureRecognizer? = nil) {
        resetUIButtons()
        setSelectedCircularImage(image: img_ar)
        selectedLang = "ar"
    }
    
    @IBAction func setRememberChoice(_ sender: Any) {
        if isRemembered == true{
            isRemembered = false
            if lang == "ar"{
                btn_remember.setImage(noselectediconar, for: .normal)
            }else{
                btn_remember.setImage(noCheckBox, for: .normal)
            }
        }else{
            isRemembered = true
            if lang == "ar"{
                btn_remember.setImage(selectediconar, for: .normal)
            }else{
                btn_remember.setImage(checkbox, for: .normal)
            }
        }
    }
    
    func setDefaultCircularImage(image:UIImageView){
        image.layer.borderWidth = 5
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.init(rgb: 0xfcf8df, alpha: 1.0).cgColor
        image.layer.cornerRadius = image.frame.height/2
        image.clipsToBounds = true
    }
    
    func setSelectedCircularImage(image:UIImageView){
        image.layer.borderWidth = 6
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.init(rgb: 0xffc107, alpha: 1.0).cgColor
        image.layer.cornerRadius = image.frame.height/2
        image.clipsToBounds = true
    }

    @IBAction func `continue`(_ sender: Any) {
        
        if isRemembered{
            UserDefaults.standard.set("remembered", forKey: "lang_remember")
        }else{
            UserDefaults.standard.set("", forKey: "lang_remember")
        }
        
        if selectedLang == "en"{
            UserDefaults.standard.set("en", forKey: "language")
            lang = "en"
            AppDelegate.currentStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
        }else if selectedLang == "ar"{
            UserDefaults.standard.set("ar", forKey: "language")
            lang = "ar"
            AppDelegate.currentStoryboard = UIStoryboard(name: "Arabic", bundle: nil)
        }
        
        let readTerms = UserDefaults.standard.string(forKey: "read_terms")
        
        if readTerms?.count ?? 0 == 0 {
            let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "TermsViewController"))!
            conVC.modalPresentationStyle = .fullScreen
            transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
        }else{
            let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "HomeViewController"))!
            conVC.modalPresentationStyle = .fullScreen
            transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
        }
        
    }
}
