//
//  HelpViewController.swift
//  Qhome
//
//  Created by LGH419 on 7/22/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit

class HelpViewController: BaseViewController {
    
    @IBOutlet weak var view_nav: UIView!
    @IBOutlet weak var view_mailmessage: UIView!
    @IBOutlet weak var view_notification: UIView!
    
    var messageFrame:MessageFrameForContactUsViewController!
    var dark_background:DarkBackgroundViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gHelpViewController = self
        
        addShadowToBar(view: view_nav)
        setRoundShadowView(view: view_mailmessage, corner: view_mailmessage.frame.height/2)
        setRoundShadowView(view: view_notification, corner: view_notification.frame.height/2)
        
        self.messageFrame = self.storyboard!.instantiateViewController(withIdentifier: "MessageFrameForContactUsViewController") as? MessageFrameForContactUsViewController
        self.messageFrame.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.dark_background = self.storyboard!.instantiateViewController(withIdentifier: "DarkBackgroundViewController") as? DarkBackgroundViewController
        self.dark_background.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        var tap = UITapGestureRecognizer(target: self, action: #selector(self.mailMessage(_:)))
        view_mailmessage.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.notification(_:)))
        view_notification.addGestureRecognizer(tap)
    }
    
    @objc func mailMessage(_ sender: UITapGestureRecognizer? = nil) {
        let email = ADMIN_EMAIL
        if let url = URL(string: "mailto:\(email)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @objc func notification(_ sender: UITapGestureRecognizer? = nil) {
        if thisUser.idx == 0 {
            let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "LoginViewController"))!
            conVC.modalPresentationStyle = .fullScreen
            transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
            return
        }
        
        UIView.animate(withDuration: 0.5){() -> Void in
            self.addChild(self.dark_background)
            self.view.addSubview(self.dark_background.view)
            self.messageFrame.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            self.messageFrame.btn_cancel.visibilityh = .gone
            self.messageFrame.lbl_caption.visibilityh = .visible
            self.messageFrame.btn_send.setImage(self.messageFrame.cancelicon, for: .normal)
            self.messageFrame.edt_message.text = ""
            self.messageFrame.edt_message.frame.size.height = 200.0
            self.messageFrame.edt_message.isScrollEnabled = true
            self.messageFrame.edt_message.showsVerticalScrollIndicator = true
            self.addChild(self.messageFrame)
            self.view.addSubview(self.messageFrame.view)
        }
    }
    
    func closeMessageFrame(){
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            self.messageFrame.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            self.dark_background.view.removeFromSuperview()
        }){
            (finished) in
            self.dark_background.view.removeFromSuperview()
            self.messageFrame.view.removeFromSuperview()
        }
    }
    
    @IBAction func back(_ sender: Any) {
        gHelpViewController = nil
        dismissViewController()
    }
    
}
