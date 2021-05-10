//
//  TermsViewController.swift
//  Qhome
//
//  Created by LGH419 on 7/10/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit

class TermsViewController: BaseViewController{

    @IBOutlet weak var btn_accept: UIButton!
    @IBOutlet weak var navBar: UINavigationBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addShadowToNavBar(navBar:navBar)
        
        setRoundShadowButton(button: btn_accept, corner: 5)
        
    }

    @IBAction func acceptTermsPolicy(_ sender: Any) {
        UserDefaults.standard.set("read", forKey: "read_terms")
        
        let conVC = (self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController"))!
        conVC.modalPresentationStyle = .fullScreen
        self.transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
    }
    
}
