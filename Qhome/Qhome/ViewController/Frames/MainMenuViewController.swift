//
//  MainMenuViewController.swift
//  Qhome
//
//  Created by LGH419 on 7/11/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit

class MainMenuViewController: BaseViewController {

    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var view_signuplogin: UIView!
    @IBOutlet weak var view_favorites: UIView!
    @IBOutlet weak var view_orders: UIView!
    @IBOutlet weak var view_notifications: UIView!
    @IBOutlet weak var view_manageaccount: UIView!
    @IBOutlet weak var view_settings: UIView!
    @IBOutlet weak var view_logout: UIView!
    @IBOutlet weak var view_help: UIView!
    @IBOutlet weak var view_admin: UIView!
    @IBOutlet weak var img_login: UIImageView!
    @IBOutlet weak var img_favorites: UIImageView!
    @IBOutlet weak var img_orders: UIImageView!
    @IBOutlet weak var img_notifications: UIImageView!
    @IBOutlet weak var img_manageaccount: UIImageView!
    @IBOutlet weak var img_settings: UIImageView!
    @IBOutlet weak var img_logout: UIImageView!
    @IBOutlet weak var img_help: UIImageView!
    @IBOutlet weak var img_admin: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        logo.layer.cornerRadius = logo.frame.height/2
        img_login.image = img_login.image?.imageWithColor(color1: UIColor.white)
        img_favorites.image = img_favorites.image?.imageWithColor(color1: UIColor.white)
        img_orders.image = img_orders.image?.imageWithColor(color1: UIColor.white)
        img_notifications.image = img_notifications.image?.imageWithColor(color1: UIColor.white)
        img_manageaccount.image = img_manageaccount.image?.imageWithColor(color1: UIColor.white)
        img_settings.image = img_settings.image?.imageWithColor(color1: UIColor.white)
        img_logout.image = img_logout.image?.imageWithColor(color1: UIColor.white)
        img_help.image = img_help.image?.imageWithColor(color1: UIColor.white)
        img_admin.image = img_admin.image?.imageWithColor(color1: UIColor.white)
        
        let tap_login = UITapGestureRecognizer(target: self, action: #selector(self.login(_:)))
        view_signuplogin.addGestureRecognizer(tap_login)
        
        let tap_favorites = UITapGestureRecognizer(target: self, action: #selector(self.favorites(_:)))
        view_favorites.addGestureRecognizer(tap_favorites)
        
        let tap_orders = UITapGestureRecognizer(target: self, action: #selector(self.orders(_:)))
        view_orders.addGestureRecognizer(tap_orders)
        
        let tap_notifications = UITapGestureRecognizer(target: self, action: #selector(self.notifications(_:)))
        view_notifications.addGestureRecognizer(tap_notifications)
        
        let tap_manageaccount = UITapGestureRecognizer(target: self, action: #selector(self.manageaccount(_:)))
        view_manageaccount.addGestureRecognizer(tap_manageaccount)
        
        let tap_settings = UITapGestureRecognizer(target: self, action: #selector(self.settings(_:)))
        view_settings.addGestureRecognizer(tap_settings)
        
        let tap_logout = UITapGestureRecognizer(target: self, action: #selector(self.logout(_:)))
        view_logout.addGestureRecognizer(tap_logout)
        
        let tap_help = UITapGestureRecognizer(target: self, action: #selector(self.help(_:)))
        view_help.addGestureRecognizer(tap_help)
        
        let tap_admin = UITapGestureRecognizer(target: self, action: #selector(self.companyadmin(_:)))
        view_admin.addGestureRecognizer(tap_admin)
        
    }
    
    @objc func login(_ sender: UITapGestureRecognizer? = nil) {
        if thisUser.idx == 0{
            let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "LoginViewController"))!
            conVC.modalPresentationStyle = .fullScreen
            transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
            gHomeViewController.close_menu()
        }
    }
    
    @objc func favorites(_ sender: UITapGestureRecognizer? = nil) {
        if thisUser.idx > 0 {
            let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "FavoritesViewController"))!
            conVC.modalPresentationStyle = .fullScreen
            transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
        }else{
            let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "LoginViewController"))!
            conVC.modalPresentationStyle = .fullScreen
            transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
        }
        gHomeViewController.close_menu()
    }
    
    @objc func orders(_ sender: UITapGestureRecognizer? = nil) {
        if thisUser.idx > 0 {
            let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "MyOrdersViewController"))!
            conVC.modalPresentationStyle = .fullScreen
            transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
        }else{
            let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "LoginViewController"))!
            conVC.modalPresentationStyle = .fullScreen
            transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
        }
        gHomeViewController.close_menu()
    }
    
    @objc func notifications(_ sender: UITapGestureRecognizer? = nil) {
        let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "NotificationsViewController"))!
        conVC.modalPresentationStyle = .fullScreen
        conVC.modalPresentationStyle = .fullScreen
        transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
        gHomeViewController.close_menu()
    }
    
    @objc func manageaccount(_ sender: UITapGestureRecognizer? = nil) {
        let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "ManageAccountViewController"))!
        conVC.modalPresentationStyle = .fullScreen
        transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
        gHomeViewController.close_menu()
    }
    
    @objc func settings(_ sender: UITapGestureRecognizer? = nil) {
        let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "SettingsViewController"))!
        conVC.modalPresentationStyle = .fullScreen
        transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
        gHomeViewController.close_menu()
    }
    
    @objc func logout(_ sender: UITapGestureRecognizer? = nil) {
        UserDefaults.standard.set("", forKey: "email")
        UserDefaults.standard.set("", forKey: "role")
        UserDefaults.standard.set("", forKey: "lang_remember")
        UserDefaults.standard.set("", forKey: "read_terms")
        thisUser.idx = 0
        self.view_signuplogin.visibility = .visible
        self.view_logout.visibility = .gone
        gHomeViewController.showToast(msg: Language().loggedout)
        gHomeViewController.close_menu()
    }
    
    @objc func help(_ sender: UITapGestureRecognizer? = nil) {
        let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "HelpViewController"))!
        conVC.modalPresentationStyle = .fullScreen
        transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
        gHomeViewController.close_menu()
    }
    
    @objc func companyadmin(_ sender: UITapGestureRecognizer? = nil) {
        if gHomeViewController != nil{
            gHomeViewController.cadminlogin()
        }
        gHomeViewController.close_menu()
    }

}
