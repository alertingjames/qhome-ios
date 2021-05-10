//
//  CartViewController.swift
//  Qhome
//
//  Created by LGH419 on 7/19/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit

class CartViewController: BaseViewController {
    
    @IBOutlet weak var view_tabs: UIView!
    @IBOutlet weak var view_cart: UIView!
    @IBOutlet weak var view_wishlist: UIView!
    @IBOutlet weak var lbl_cart: UILabel!
    @IBOutlet weak var lbl_wishlist: UILabel!
    @IBOutlet weak var view_container: UIView!
    @IBOutlet weak var view_cart_indicator: UIView!
    @IBOutlet weak var view_wishlist_indicator: UIView!
    @IBOutlet weak var view_total: UIView!
    @IBOutlet weak var lbl_total: UILabel!
    @IBOutlet weak var btn_checkout: UIButton!
    @IBOutlet weak var view_footer: UIView!
    
    
    let unSelAttrs = [
        NSAttributedString.Key.foregroundColor : lightPrimaryColor,
        NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
        ] as [NSAttributedString.Key : Any]
    
    let selAttrs = [
        NSAttributedString.Key.foregroundColor : primaryColor,
        NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15),
        ] as [NSAttributedString.Key : Any]
    
    var cartListFrame:CartListViewController!
    var wishlistFrame:WishlistListViewController!
    var noResultFrame:NoResultViewController!
    
    var selected = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        gCartViewController = self

        addShadowToBar(view: view_tabs)
        view_total.addDashBorder(color: primaryColor)
        setRoundShadowButton(button: btn_checkout, corner: 25)
        
        self.cartListFrame = self.storyboard!.instantiateViewController(withIdentifier: "CartListViewController") as? CartListViewController
        self.cartListFrame.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.cartListFrame.view.frame.size.height)
        
        self.wishlistFrame = self.storyboard!.instantiateViewController(withIdentifier: "WishlistListViewController") as? WishlistListViewController
        self.wishlistFrame.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.wishlistFrame.view.frame.size.height)
        
        self.noResultFrame = self.storyboard!.instantiateViewController(withIdentifier: "NoResultViewController") as? NoResultViewController
        self.noResultFrame.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.noResultFrame.view.frame.size.height)
        
        // So important!!!
        self.view_container.frame.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 70.0)
        
        var tap = UITapGestureRecognizer(target: self, action: #selector(self.tappedCart(_:)))
        self.view_cart.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.tappedWishlist(_:)))
        self.view_wishlist.addGestureRecognizer(tap)
        
        self.selCart()
        
    }
    
    @objc func tappedCart(_ sender: UITapGestureRecognizer? = nil) {
        self.selCart()
    }
    
    @objc func tappedWishlist(_ sender:UITapGestureRecognizer? = nil){
        self.selWishlist()
    }
    
    func resetTabs(){
        
        self.lbl_cart.attributedText = NSAttributedString(string: Language().cart, attributes: unSelAttrs)
        self.lbl_wishlist.attributedText = NSAttributedString(string: Language().wishlist, attributes: unSelAttrs)
        
        self.view_cart_indicator.isHidden = true
        self.view_wishlist_indicator.isHidden = true
        
    }
    
    func selCart(){
        if self.selected != "cart"{
            self.selected = "cart"
            self.wishlistFrame.view.removeFromSuperview()
            self.resetTabs()
            self.lbl_cart.attributedText = NSAttributedString(string: Language().cart, attributes: selAttrs)
            self.view_cart_indicator.isHidden = false
            
            UIView.animate(withDuration: 0.3){() -> Void in
                self.cartListFrame.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.cartListFrame.view.frame.size.height)
                self.view_container.addSubview(self.cartListFrame.view)
            }
            
            view_footer.isHidden = false
        }
    }
    
    func selWishlist(){
        if self.selected != "wishlist"{
            self.selected = "wishlist"
            self.cartListFrame.view.removeFromSuperview()
            self.resetTabs()
            self.lbl_wishlist.attributedText = NSAttributedString(string: Language().wishlist, attributes: selAttrs)
            self.view_wishlist_indicator.isHidden = false
            
            view_footer.isHidden = true
            
            UIView.animate(withDuration: 0.3){() -> Void in
                
                self.wishlistFrame.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.wishlistFrame.view.frame.size.height)
                self.view_container.addSubview(self.wishlistFrame.view)
            }
        }
    }

    @IBAction func back(_ sender: Any) {
        if gStoreDetailViewController != nil{
            gStoreDetailViewController?.storeProductsFrame.productDetailFrame.getCart(imei: gIMEI)
        }
        gCartViewController = nil
        dismissViewController()
    }
    
    @IBAction func checkout(_ sender: Any) {
        let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "CheckoutViewController"))!
        conVC.modalPresentationStyle = .fullScreen
        transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
    }
}
