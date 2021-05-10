//
//  CategoryViewController.swift
//  Qhome
//
//  Created by LGH419 on 7/16/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit

class CategoryViewController: BaseViewController {

    @IBOutlet weak var view_nav: UIView!
    @IBOutlet weak var view_food: UIView!
    @IBOutlet weak var view_drinks: UIView!
    @IBOutlet weak var view_sweets: UIView!
    @IBOutlet weak var view_stationery: UIView!
    @IBOutlet weak var view_accessories: UIView!
    @IBOutlet weak var view_perfumes: UIView!
    @IBOutlet weak var view_others: UIView!
    @IBOutlet weak var img_food: UIImageView!
    @IBOutlet weak var mask_food: UIView!
    @IBOutlet weak var img_drinks: UIImageView!
    @IBOutlet weak var mask_drinks: UIView!
    @IBOutlet weak var img_sweets: UIImageView!
    @IBOutlet weak var mask_sweets: UIView!
    @IBOutlet weak var img_stationery: UIImageView!
    @IBOutlet weak var mask_stationery: UIView!
    @IBOutlet weak var img_accessories: UIImageView!
    @IBOutlet weak var mask_accessories: UIView!
    @IBOutlet weak var img_perfumes: UIImageView!
    @IBOutlet weak var mask_perfumes: UIView!
    @IBOutlet weak var img_others: UIImageView!
    @IBOutlet weak var mask_others: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addShadowToBar(view: view_nav)

        img_food.layer.cornerRadius = 5
        mask_food.layer.cornerRadius = 5
        
        img_drinks.layer.cornerRadius = 5
        mask_drinks.layer.cornerRadius = 5
        
        img_sweets.layer.cornerRadius = 5
        mask_sweets.layer.cornerRadius = 5
        
        img_stationery.layer.cornerRadius = 5
        mask_stationery.layer.cornerRadius = 5
        
        img_accessories.layer.cornerRadius = 5
        mask_accessories.layer.cornerRadius = 5
        
        img_perfumes.layer.cornerRadius = 5
        mask_perfumes.layer.cornerRadius = 5
        
        img_others.layer.cornerRadius = 5
        mask_others.layer.cornerRadius = 5
        
        var tap = UITapGestureRecognizer(target: self, action: #selector(self.getStoresByFood(_:)))
        view_food.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.getStoresByDrinks(_:)))
        view_drinks.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.getStoresBySweets(_:)))
        view_sweets.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.getStoresByStationery(_:)))
        view_stationery.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.getStoresByAccessories(_:)))
        view_accessories.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.getStoresByPerfumes(_:)))
        view_perfumes.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.getStoresByOthers(_:)))
        view_others.addGestureRecognizer(tap)
        
        gCategoryViewController = self
    }
    
    @objc func getStoresByFood(_ sender: UITapGestureRecognizer? = nil) {
        self.toStoresByCategory(category: Language().food)
    }

    @objc func getStoresByDrinks(_ sender: UITapGestureRecognizer? = nil) {
        self.toStoresByCategory(category: Language().drinks)
    }
    
    @objc func getStoresBySweets(_ sender: UITapGestureRecognizer? = nil) {
        self.toStoresByCategory(category: Language().sweets)
    }
    
    @objc func getStoresByStationery(_ sender: UITapGestureRecognizer? = nil) {
        self.toStoresByCategory(category: Language().stationery)
    }
    
    @objc func getStoresByAccessories(_ sender: UITapGestureRecognizer? = nil) {
        self.toStoresByCategory(category: Language().accessories)
    }
    
    @objc func getStoresByPerfumes(_ sender: UITapGestureRecognizer? = nil) {
        self.toStoresByCategory(category: Language().perfumes)
    }
    
    @objc func getStoresByOthers(_ sender: UITapGestureRecognizer? = nil) {
        self.toStoresByCategory(category: Language().others)
    }
    
    func toStoresByCategory(category:String){
        gCategory = category
        let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "StoreListViewController"))!
        conVC.modalPresentationStyle = .fullScreen
        transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
    }
    
    
    @IBAction func back(_ sender: Any) {
        dismissViewController()
    }
    
    @IBAction func toFilter(_ sender: Any) {
        let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "FilterViewController"))!
        conVC.modalPresentationStyle = .fullScreen
        transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
    }
    
}
