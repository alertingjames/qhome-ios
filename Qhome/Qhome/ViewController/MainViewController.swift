//
//  ViewController.swift
//  Qhome
//
//  Created by LGH419 on 7/7/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit

class ViewController: BaseViewController {
    
    var splash:SplashViewController!
    var timer:Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        splash = self.storyboard!.instantiateViewController(withIdentifier: "SplashViewController") as? SplashViewController
        self.splash.view.frame = CGRect(x: 0, y: -UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        
        lang = UserDefaults.standard.string(forKey: "language")
        if lang?.count ?? 0 == 0 {
            UserDefaults.standard.set("en", forKey: "language")
            lang = "en"
        }
        
        if lang == "ar"{
            AppDelegate.currentStoryboard = UIStoryboard(name: "Arabic", bundle: nil)
        }else{
            AppDelegate.currentStoryboard = UIStoryboard(name: "Main", bundle: nil)
        }
        
        UIView.animate(withDuration: 1.0, animations: {() -> Void in
            self.splash.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            self.addChild(self.splash)
            self.view.addSubview(self.splash.view)
        }){
            (finished) in
            self.timer = Timer.scheduledTimer(
                timeInterval: 1.2, target: self, selector: #selector(self.flipViews),
                userInfo: nil, repeats: true)
            self.timer.fire()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
                // Code you want to be delayed
                
                let email = UserDefaults.standard.string(forKey: "email")
                let role = UserDefaults.standard.string(forKey: "role")
                
                if email?.count ?? 0 > 0 && role?.count ?? 0 > 0{
                    self.login(email: email!, password: "", role: role!)
                }else{
                    thisUser.idx = 0
                    let langRemember = UserDefaults.standard.string(forKey: "lang_remember")
                    let readTerms = UserDefaults.standard.string(forKey: "read_terms")
                    if langRemember?.count ?? 0 == 0{
                        let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "ChooseLangViewController"))!
                        conVC.modalPresentationStyle = .fullScreen
                        self.transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
                    }else{
                        if readTerms?.count ?? 0 == 0{
                            let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "TermsViewController"))!
                            conVC.modalPresentationStyle = .fullScreen
                            self.transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
                        }else{
                            let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "HomeViewController"))!
                            conVC.modalPresentationStyle = .fullScreen
                            self.transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
                        }
                    }
                }
            }
        }
        
    }
    
    @objc func flipViews(){
        UIView.transition(with: self.splash.logo, duration: 1.2, options: [.transitionFlipFromRight, .showHideTransitionViews], animations: nil, completion: nil)
        UIView.transition(with: self.splash.name, duration: 1.2, options: [.transitionFlipFromRight, .showHideTransitionViews], animations: nil, completion: nil)
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
                thisUser = user!
            }else {
                thisUser.idx = 0
            }
            
            let langRemember = UserDefaults.standard.string(forKey: "lang_remember")
            let readTerms = UserDefaults.standard.string(forKey: "read_terms")
            if langRemember?.count ?? 0 == 0{
                let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "ChooseLangViewController"))!
                conVC.modalPresentationStyle = .fullScreen
                self.transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
            }else{
                if readTerms?.count ?? 0 == 0{
                    let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "TermsViewController"))!
                    conVC.modalPresentationStyle = .fullScreen
                    self.transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
                }else{
                    let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "HomeViewController"))!
                    conVC.modalPresentationStyle = .fullScreen
                    self.transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
                }
            }
            
        })
    }

}
