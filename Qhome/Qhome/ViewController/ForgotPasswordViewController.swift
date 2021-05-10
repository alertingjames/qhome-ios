//
//  ForgotPasswordViewController.swift
//  Qhome
//
//  Created by LGH419 on 7/14/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: BaseViewController {
    
    @IBOutlet weak var view_nav: UIView!
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var view_email: UIView!
    @IBOutlet weak var edt_email: UITextField!
    @IBOutlet weak var btn_request: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        addShadowToBar(view: view_nav)
        setRoundShadowView(view: view_email, corner: 25)
        setRoundShadowButton(button: btn_request, corner: 25)
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 10
        style.alignment = .center
        let attributes = [NSAttributedString.Key.paragraphStyle : style]
        caption.attributedText = NSAttributedString(string: caption.text!, attributes: attributes)
        
    }

    @IBAction func back(_ sender: Any) {
        dismissViewController()
    }
    
    @IBAction func requestPassword(_ sender: Any) {
        
        if edt_email.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            showToast(msg: "Enter your email.")
            return
        }
        
        if isValidEmail(testStr: (edt_email.text?.trimmingCharacters(in: .whitespacesAndNewlines))!) == false{
            showToast(msg: "Enter a valid email.")
            return
        }
        
    }
    
}
