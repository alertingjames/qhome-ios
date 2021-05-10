//
//  OrderPlacedViewController.swift
//  Qhome
//
//  Created by LGH419 on 7/22/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit

class OrderPlacedViewController: BaseViewController {
    
    @IBOutlet weak var lbl_orderID: UILabel!
    @IBOutlet weak var lbl_orderdate: UILabel!
    @IBOutlet weak var lbl_orderstatus: UILabel!
    @IBOutlet weak var lbl_total: UILabel!   
    @IBOutlet weak var view_panel: UIView!
    @IBOutlet weak var view_nav: UIView!
    @IBOutlet weak var view_contactus: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addShadowToBar(view: view_nav)
        setRoundShadowView(view: view_panel, corner: 5)
        
        lbl_orderID.text = gOrderID
        lbl_orderdate.text = gOrderDate
        if lang == "ar"{
            lbl_total.text = "QR " + String(Double(gTotalPrice).roundToDecimal(2))
        }else{
            lbl_total.text = String(Double(gTotalPrice).roundToDecimal(2)) + " QR"
        }
        
    }
    
    @objc func contact(sender : UIButton){
        print("Tapped on ContactUs")
    }
   
    @IBAction func contactUs(_ sender: Any) {
        print("Tapped on ContactUs")
        let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "ContactUsViewController"))!
        conVC.modalPresentationStyle = .fullScreen
        transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
    }
    
    @IBAction func toHome(_ sender: Any) {
        let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "HomeViewController"))!
        conVC.modalPresentationStyle = .fullScreen
        transitionVc(vc: conVC, duration: 0.3, type: .fromLeft)
    }

}
