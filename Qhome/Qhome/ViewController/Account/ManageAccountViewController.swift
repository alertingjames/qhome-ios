//
//  ManageAccountViewController.swift
//  Qhome
//
//  Created by LGH419 on 7/21/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit
import DynamicBlurView

class ManageAccountViewController: BaseViewController {
    
    private var lastContentOffset: CGFloat = 0
    @IBOutlet weak var view_nav: UIView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_title2: UILabel!
    @IBOutlet weak var view_tabs: UIView!
    @IBOutlet weak var view_coupons: UIView!
    @IBOutlet weak var view_orders: UIView!
    @IBOutlet weak var view_wishlist: UIView!
    @IBOutlet weak var view_background: UIView!
    @IBOutlet weak var view_panel: UIView!
    @IBOutlet weak var view_profile: UIView!
    @IBOutlet weak var view_shipping: UIView!
    @IBOutlet weak var view_favorites: UIView!
    @IBOutlet weak var view_feedback: UIView!
    @IBOutlet weak var view_my_stores: UIView!
    @IBOutlet weak var view_received_orders: UIView!
    @IBOutlet weak var view_luckydraw: UIView!
    @IBOutlet weak var view_contactus: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var view_tabs2: UIView!
    @IBOutlet weak var view_coupons2: UIView!
    @IBOutlet weak var view_orders2: UIView!
    @IBOutlet weak var view_wishlist2: UIView!
    @IBOutlet weak var lbl_store_count: UILabel!
    @IBOutlet weak var lbl_received_count: UILabel!
    
    @IBOutlet weak var view_line_receiveds: UIView!
    @IBOutlet weak var view_line_lucky: UIView!
    @IBOutlet weak var view_line_tabs: UIView!
    @IBOutlet weak var view_new_count: UIView!
    @IBOutlet weak var lbl_new_count: UILabel!
    
    
    var blurView:DynamicBlurView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setRoundShadowView(view: view_panel, corner: 3)
        scrollView.delegate = self
        
        self.blurView = DynamicBlurView(frame: self.view_background.bounds)
        view_tabs.visibility = .visible
        view_tabs2.visibility = .gone
        view_line_tabs.visibility = .gone
        lbl_title.text = ""
        
        if thisUser.idx == 0 || thisUser.role != "producer"{
            view_received_orders.visibility = .gone
            view_line_receiveds.visibility = .gone
        }
        
        if thisUser.idx == 0{
            view_luckydraw.visibility = .gone
            view_line_lucky.visibility = .gone
        }
        
        var tap = UITapGestureRecognizer(target: self, action: #selector(self.toCoupons(_:)))
        self.view_coupons.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.toOrders(_:)))
        self.view_orders.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.toWishlist(_:)))
        self.view_wishlist.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.toCoupons(_:)))
        self.view_coupons2.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.toOrders(_:)))
        self.view_orders2.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.toWishlist(_:)))
        self.view_wishlist2.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.toMyProfile(_:)))
        self.view_profile.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.toShippingAddress(_:)))
        self.view_shipping.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.toFavorites(_:)))
        self.view_favorites.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.toFeedback(_:)))
        self.view_feedback.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.toMyStores(_:)))
        self.view_my_stores.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.toReceivedOrders(_:)))
        self.view_received_orders.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.toLuckyDraw(_:)))
        self.view_luckydraw.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.toContactUs(_:)))
        self.view_contactus.addGestureRecognizer(tap)
        
    }
    
    @objc func toCoupons(_ sender: UITapGestureRecognizer? = nil) {
        print("Tapped on Coupons")
        if thisUser.idx > 0{
            let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "CouponsViewController"))!
            conVC.modalPresentationStyle = .fullScreen
            transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
        }else{
            let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "LoginViewController"))!
            conVC.modalPresentationStyle = .fullScreen
            transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
        }
    }
    
    @objc func toOrders(_ sender: UITapGestureRecognizer? = nil) {
        if thisUser.idx > 0{
            let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "MyOrdersViewController"))!
            conVC.modalPresentationStyle = .fullScreen
            transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
        }else{
            let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "LoginViewController"))!
            conVC.modalPresentationStyle = .fullScreen
            transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
        }
    }
    
    @objc func toWishlist(_ sender: UITapGestureRecognizer? = nil) {
        let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "WishlistViewController"))!
        conVC.modalPresentationStyle = .fullScreen
        transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
    }
    
    @objc func toMyProfile(_ sender: UITapGestureRecognizer? = nil) {
        if thisUser.idx > 0{
            let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "MyProfileViewController"))!
            conVC.modalPresentationStyle = .fullScreen
            transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
        }else{
            let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "LoginViewController"))!
            conVC.modalPresentationStyle = .fullScreen
            transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
        }
    }
    
    @objc func toShippingAddress(_ sender: UITapGestureRecognizer? = nil) {
        let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "AddressViewController"))!
        conVC.modalPresentationStyle = .fullScreen
        gAddrOption = "addr"
        transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
    }
    
    @objc func toFavorites(_ sender: UITapGestureRecognizer? = nil) {
        if thisUser.idx > 0 {
            let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "FavoritesViewController"))!
            conVC.modalPresentationStyle = .fullScreen
            transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
        }else{
            let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "LoginViewController"))!
            conVC.modalPresentationStyle = .fullScreen
            transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
        }
    }
    
    @objc func toFeedback(_ sender: UITapGestureRecognizer? = nil) {
        if thisUser.idx > 0{
            let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "FeedbackViewController"))!
            conVC.modalPresentationStyle = .fullScreen
            transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
        }else{
            let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "LoginViewController"))!
            conVC.modalPresentationStyle = .fullScreen
            transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
        }
    }
    
    @objc func toMyStores(_ sender: UITapGestureRecognizer? = nil) {
        if thisUser.idx > 0 && thisUser.role == "producer"{
            let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "MyStoreListViewController"))!
            conVC.modalPresentationStyle = .fullScreen
            transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
        }else{
            let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "LoginViewController"))!
            conVC.modalPresentationStyle = .fullScreen
            transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
        }
    }
    
    @objc func toReceivedOrders(_ sender: UITapGestureRecognizer? = nil) {
        let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "ReceivedOrdersViewController"))!
        conVC.modalPresentationStyle = .fullScreen
        transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
    }
    
    @objc func toLuckyDraw(_ sender: UITapGestureRecognizer? = nil) {
        if thisUser.idx > 0{
            let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "LuckyDrawViewController"))!
            conVC.modalPresentationStyle = .fullScreen
            transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
        }else{
            let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "LoginViewController"))!
            conVC.modalPresentationStyle = .fullScreen
            transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
        }
    }
    
    @objc func toContactUs(_ sender: UITapGestureRecognizer? = nil) {
        let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "ContactUsViewController"))!
        conVC.modalPresentationStyle = .fullScreen
        transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
    }
    
    @IBAction func toSettings(_ sender: Any) {
        let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "SettingsViewController"))!
        conVC.modalPresentationStyle = .fullScreen
        self.transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lbl_store_count.text = "(" + String(gMyStores.count) + ")"
        if thisUser.idx > 0 && thisUser.role == "producer"{
            self.getOrderItems()
        }        
        self.getPhones()
        self.getAddresses()
    }
    
    @IBAction func back(_ sender: Any) {
        dismissViewController()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.lastContentOffset > scrollView.contentOffset.y) {
            // move down
            print("Now scrolling down\(scrollView.contentOffset.y)")
            if scrollView.contentOffset.y < 200{
                lbl_title.text = ""
                lbl_title2.text = "Manage Account"
                view_nav.layer.backgroundColor = nil
                
                if scrollView.contentOffset.y < 50{
                    self.blurView.alpha = 0
                }
                
                self.view_tabs.isHidden = false
                self.view_tabs2.visibility = .gone
                self.view_line_tabs.visibility = .gone
                
            }
        }
        else if (self.lastContentOffset < scrollView.contentOffset.y) {
            // move up
            print("Now scrolling up\(scrollView.contentOffset.y)")
            if scrollView.contentOffset.y > 100{
                lbl_title.text = "Manage Account"
                lbl_title2.text = ""
                view_nav.layer.backgroundColor = primaryColor.cgColor
                
                self.blurView.alpha = 1
                self.blurView.blurRadius = 10
                self.view_background.addSubview(self.blurView)
                
                self.view_tabs.isHidden = true
                self.view_tabs2.visibility = .visible
                self.view_line_tabs.visibility = .visible
            }
        }
        
        // update the new position acquired
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    func getOrderItems(){
        var onGoings = [OrderItem]()
        var placeds = [OrderItem]()
        APIs.getOrderItems(member_id: thisUser.idx, handleCallback: {
            orderItems, result_code in
            print(result_code)
            if result_code == "0"{
                for item in orderItems!{
                    
                    if item.status != "delivered"{
                        onGoings.append(item)
                        if item.status == "placed"{
                            placeds.append(item)
                        }
                    }
                }
                
                self.lbl_received_count.text = "(" + String(onGoings.count) + ")"
                
                if placeds.count > 0{
                    self.view_new_count.isHidden = false
                    self.lbl_new_count.text = String(placeds.count)
                }else{
                    self.view_new_count.isHidden = true
                }
            }
        })
    }
    
    func getPhones(){
        APIs.getPhones(member_id: thisUser.idx, imei_id: gIMEI, handleCallback: {
            phones, result_code in
            print(result_code)
            if result_code == "0"{
                gPhones.removeAll()
                for phone in phones!{
                    gPhones.append(phone)
                }
            }
        })
    }
    
    func getAddresses(){
        APIs.getAddresses(member_id: thisUser.idx, imei_id: gIMEI, handleCallback: {
            addresses, result_code in
            print(result_code)
            if result_code == "0"{
                gAddresses.removeAll()
                for address in addresses!{
                    gAddresses.append(address)
                }
            }
        })
    }
    
}
