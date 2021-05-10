//
//  StoreDetailViewController.swift
//  Qhome
//
//  Created by LGH419 on 7/17/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit

class StoreDetailViewController: BaseViewController {
    
    @IBOutlet weak var view_nav: UIView!
    @IBOutlet weak var view_cart: UIView!
    @IBOutlet weak var view_count: UIView!
    @IBOutlet weak var lbl_count: UILabel!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var view_tabs: UIView!
    @IBOutlet weak var view_profile: UIView!
    @IBOutlet weak var lbl_profile: UILabel!
    @IBOutlet weak var view_profile_indicator: UIView!
    @IBOutlet weak var view_products: UIView!
    @IBOutlet weak var lbl_products: UILabel!
    @IBOutlet weak var view_products_indicator: UIView!
    @IBOutlet weak var view_rate: UIView!
    @IBOutlet weak var lbl_rate: UILabel!
    @IBOutlet weak var view_rate_indicator: UIView!
    @IBOutlet weak var view_container: UIView!
    
    let unSelAttrs = [
        NSAttributedString.Key.foregroundColor : lightPrimaryColor,
        NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
        ] as [NSAttributedString.Key : Any]
    
    let selAttrs = [
        NSAttributedString.Key.foregroundColor : primaryColor,
        NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15),
    ] as [NSAttributedString.Key : Any]
    
    var storeProfileFrame:StoreProfileViewController!
    var storeProductsFrame:StoreProductsViewController!
    var storeRateFrame:StoreRateViewController!
    
    var companyPriceId:Int64 = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        addShadowToBar(view: view_nav)
        
        gStoreDetailViewController = self
        
        companyPriceId = gStore.priceId
        
        self.storeProfileFrame = self.storyboard!.instantiateViewController(withIdentifier: "StoreProfileViewController") as? StoreProfileViewController
        self.storeProfileFrame.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.storeProfileFrame.view.frame.size.height)
        
        self.storeProductsFrame = self.storyboard!.instantiateViewController(withIdentifier: "StoreProductsViewController") as? StoreProductsViewController
        self.storeProductsFrame.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.storeProductsFrame.view.frame.size.height)
        
        self.storeRateFrame = self.storyboard!.instantiateViewController(withIdentifier: "StoreRateViewController") as? StoreRateViewController
        self.storeRateFrame.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.storeRateFrame.view.frame.size.height)
        
        // So important!!!
        self.view_container.frame.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 95.0)
        
        var tap = UITapGestureRecognizer(target: self, action: #selector(self.tappedProfile(_:)))
        self.view_profile.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.tappedProducts(_:)))
        self.view_products.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.tappedRate(_:)))
        self.view_rate.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.tappedCart(_:)))
        self.view_cart.addGestureRecognizer(tap)
        
        if lang == "ar"{
            lbl_title.text = gStore.arName
        }else{
            lbl_title.text = gStore.name
        }
        
        self.selProfile()
        self.getCart(imei: gIMEI)
        
    }
    
    @objc func tappedProfile(_ sender: UITapGestureRecognizer? = nil) {
        self.selProfile()
    }
    
    @objc func tappedProducts(_ sender:UITapGestureRecognizer? = nil){
        self.selProducts()
    }
    
    @objc func tappedRate(_ sender:UITapGestureRecognizer? = nil){
        self.selRate()
    }
    
    @objc func tappedCart(_ sender:UITapGestureRecognizer? = nil){
        let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "CartViewController"))!
        conVC.modalPresentationStyle = .fullScreen
        transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
    }
    
    func resetTabs(){
        
        self.lbl_profile.attributedText = NSAttributedString(string: Language().profile, attributes: unSelAttrs)
        self.lbl_products.attributedText = NSAttributedString(string: Language().products, attributes: unSelAttrs)
        self.lbl_rate.attributedText = NSAttributedString(string: Language().rate, attributes: unSelAttrs)
        
        self.view_profile_indicator.isHidden = true
        self.view_products_indicator.isHidden = true
        self.view_rate_indicator.isHidden = true
        
    }
    
    func selProfile(){
        self.storeProductsFrame.view.removeFromSuperview()
        self.storeRateFrame.view.removeFromSuperview()
        self.resetTabs()
        self.lbl_profile.attributedText = NSAttributedString(string: Language().profile, attributes: selAttrs)
        self.view_profile_indicator.isHidden = false
        
        UIView.animate(withDuration: 0.3){() -> Void in
            self.storeProfileFrame.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            self.view_container.addSubview(self.storeProfileFrame.view)
        }
    }
    
    func selProducts(){
        self.storeProfileFrame.view.removeFromSuperview()
        self.storeRateFrame.view.removeFromSuperview()
        self.resetTabs()
        self.lbl_products.attributedText = NSAttributedString(string: Language().products, attributes: selAttrs)
        self.view_products_indicator.isHidden = false
        
        UIView.animate(withDuration: 0.3){() -> Void in
            self.storeProductsFrame.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            self.storeProductsFrame.productList.frame.size.height = self.view_container.frame.height - self.storeProductsFrame.view_header.frame.height - 10
            self.view_container.addSubview(self.storeProductsFrame.view)
        }
    }
    
    func selRate(){
        if thisUser.idx == 0{
            let vc = AppDelegate.currentStoryboard.instantiateViewController(withIdentifier: "LoginViewController")
            transitionVc(vc: vc, duration: 0.3, type: .fromRight)
            return
        }
        self.storeProfileFrame.view.removeFromSuperview()
        self.storeProductsFrame.view.removeFromSuperview()
        self.resetTabs()
        self.lbl_rate.attributedText = NSAttributedString(string: Language().rate, attributes: selAttrs)
        self.view_rate_indicator.isHidden = false
        
        UIView.animate(withDuration: 0.3){() -> Void in
            self.storeRateFrame.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            self.view_container.addSubview(self.storeRateFrame.view)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @IBAction func back(_ sender: Any) {
        gStoreDetailViewController = nil
        dismissViewController()
    }
    
    func getCart(imei:String){
        gCartItems.removeAll()
        gCartItemsCount = 0
        APIs.getCarts(imei_id: imei, handleCallback: {
            cartItems, result_code in
            print(result_code)
            if result_code == "0"{
                for item in cartItems!{
                    gCartItems.append(item)
                    gCartItemsCount = gCartItemsCount + Int(item.quantity)
                }
                
                if gCartItems.count > 0{
                    self.view_count.isHidden = false
                    self.lbl_count.text = String(gCartItemsCount)
                }else{
                    self.view_count.isHidden = true
                }
                
            }
            else{
                
            }
        })
    }
    

}
