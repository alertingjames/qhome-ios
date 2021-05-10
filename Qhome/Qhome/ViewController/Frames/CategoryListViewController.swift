//
//  CategoryListViewController.swift
//  Qhome
//
//  Created by LGH419 on 7/15/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit

class CategoryListViewController: BaseViewController {
    
    @IBOutlet weak var view_panel: UIView!
    @IBOutlet weak var view_food: UIView!
    @IBOutlet weak var btn_food: UIButton!
    @IBOutlet weak var view_drinks: UIView!
    @IBOutlet weak var btn_drinks: UIButton!
    @IBOutlet weak var view_sweets: UIView!
    @IBOutlet weak var btn_sweets: UIButton!
    @IBOutlet weak var view_stationery: UIView!
    @IBOutlet weak var btn_stationery: UIButton!
    @IBOutlet weak var view_accessories: UIView!
    @IBOutlet weak var btn_accessories: UIButton!
    @IBOutlet weak var view_perfumes: UIView!
    @IBOutlet weak var btn_perfumes: UIButton!
    @IBOutlet weak var view_others: UIView!
    @IBOutlet weak var btn_others: UIButton!
    
    var selectedCategoryArray = [String]()
    var selectedARCategoryArray = [String]()
    
    let selectedicon = UIImage(named: "checked_maroon")
    let noselectedicon = UIImage(named: "unchecked_maroon")
    
    let selectediconar = UIImage(named: "checked_maroon_flip")
    let noselectediconar = UIImage(named: "unchecked_maroon_flip")
    
    var buttonArray = [UIButton]()
    var viewArray = [UIView]()
    
    var isSelectedArray = [
        false,
        false,
        false,
        false,
        false,
        false,
        false,
    ]
    
    var categoryArray = [
        "Food",
        "Drinks",
        "Sweets",
        "Stationery",
        "Accessories",
        "Perfumes",
        "Others",
    ]
    
    var categoryARArray = [
                "طعام",
                "مشروبات",
                "حلويات",
                "حلويات",
                "مستلزمات",
                "العطور",
                "الآخرين",
    ]
    

    override func viewDidLoad() {
        super.viewDidLoad()

        view_panel.layer.cornerRadius = 5
        
        buttonArray = [
            btn_food,
            btn_drinks,
            btn_sweets,
            btn_stationery,
            btn_accessories,
            btn_perfumes,
            btn_others,
        ]
        
        viewArray = [
            view_food,
            view_drinks,
            view_sweets,
            view_stationery,
            view_accessories,
            view_perfumes,
            view_others,
        ]
        
        // views
        for i in 0..<self.viewArray.count {
            self.viewArray[i].tag = i
            let tap = UITapGestureRecognizer(target: self, action: #selector(selected))
            self.viewArray[i].addGestureRecognizer(tap)
        }
        
        // buttons
        for i in 0..<self.buttonArray.count {
            self.buttonArray[i].tag = i
            buttonArray[i].addTarget(self,action:#selector(buttonClicked),
                                     for:.touchUpInside)
        }
        
    }
    
    @objc func selected(sender:UITapGestureRecognizer) {
        let index = sender.view?.tag
        if !isSelectedArray[index!]{
            if selectedCategoryArray.count >= 2{
                self.showToast(msg: Language().select_2items)
            }else{
                isSelectedArray[index!] = true
                if lang == "ar"{
                    self.buttonArray[index!].setImage(self.selectediconar, for: UIControl.State.normal)
                }else{
                    self.buttonArray[index!].setImage(self.selectedicon, for: UIControl.State.normal)
                }
                self.selectedCategoryArray.append(categoryArray[index!])
                self.selectedARCategoryArray.append(categoryARArray[index!])
            }
            
        }else{
            isSelectedArray[index!] = false
            if lang == "ar"{
                self.buttonArray[index!].setImage(self.noselectediconar, for: UIControl.State.normal)
            }else{
                self.buttonArray[index!].setImage(self.noselectedicon, for: UIControl.State.normal)
            }
            while self.selectedCategoryArray.contains(categoryArray[index!]) {
                if let itemToRemoveIndex = self.selectedCategoryArray.index(of: categoryArray[index!]) {
                    self.selectedCategoryArray.remove(at: itemToRemoveIndex)
                    self.selectedARCategoryArray.remove(at: itemToRemoveIndex)
                }
            }
            
        }
        print(self.selectedCategoryArray)
    }
    
    @objc func buttonClicked(sender:UIButton)
    {
        let index = sender.tag
        if !isSelectedArray[index]{
            if selectedCategoryArray.count >= 2{
                self.showToast(msg: Language().select_2items)
            }else{
                isSelectedArray[index] = true
                if lang == "ar"{
                    self.buttonArray[index].setImage(self.selectediconar, for: UIControl.State.normal)
                }else{
                    self.buttonArray[index].setImage(self.selectedicon, for: UIControl.State.normal)
                }
                self.selectedCategoryArray.append(categoryArray[index])
                self.selectedARCategoryArray.append(categoryARArray[index])
            }
        }else{
            isSelectedArray[index] = false
            if lang == "ar"{
                self.buttonArray[index].setImage(self.noselectediconar, for: UIControl.State.normal)
            }else{
                self.buttonArray[index].setImage(self.noselectedicon, for: UIControl.State.normal)
            }
            while self.selectedCategoryArray.contains(categoryArray[index]) {
                if let itemToRemoveIndex = self.selectedCategoryArray.index(of: categoryArray[index]) {
                    self.selectedCategoryArray.remove(at: itemToRemoveIndex)
                    self.selectedARCategoryArray.remove(at: itemToRemoveIndex)
                }
            }
        }
        print(self.selectedCategoryArray)
    }
    
    @IBAction func cancel(_ sender: Any) {
        selectedCategoryArray.removeAll()
        selectedARCategoryArray.removeAll()
        if gRegisterStoreViewController != nil{
            gRegisterStoreViewController.closeCategoryList()
        }else if gMyStoreProfileViewController != nil{
            gMyStoreProfileViewController.closeCategoryList()
        }
        
    }
    
    @IBAction func ok(_ sender: Any) {
        if selectedCategoryArray.count == 0{
            self.showToast(msg: Language().choose_category)
            return
        }
        
        if gRegisterStoreViewController != nil{
            gRegisterStoreViewController.selCategories.removeAll()
            gRegisterStoreViewController.selARCategories.removeAll()
            for i in 0...selectedCategoryArray.count - 1 {
                gRegisterStoreViewController.selCategories.append(selectedCategoryArray[i])
                gRegisterStoreViewController.selARCategories.append(selectedARCategoryArray[i])
            }
            
            gRegisterStoreViewController.txt_category.text = ""
            gRegisterStoreViewController.txt_ar_category.text = ""
            
            if selectedCategoryArray.count == 1{
                gRegisterStoreViewController.txt_category.text = selectedCategoryArray[0]
                gRegisterStoreViewController.txt_ar_category.text = selectedARCategoryArray[0]
            }else{
                gRegisterStoreViewController.txt_category.text = "1." + selectedCategoryArray[0] + " 2." + selectedCategoryArray[1]
                gRegisterStoreViewController.txt_ar_category.text = "1." + selectedARCategoryArray[0] + " 2." + selectedARCategoryArray[1]
                //            gRegisterStoreViewController.txt_ar_category.text = selectedARCategoryArray[1] + ".2 " + selectedARCategoryArray[0] + ".1"
                
            }
            
            gRegisterStoreViewController.closeCategoryList()
        }
        else if gMyStoreProfileViewController != nil{
            gMyStoreProfileViewController.selCategories.removeAll()
            gMyStoreProfileViewController.selARCategories.removeAll()
            for i in 0...selectedCategoryArray.count - 1 {
                gMyStoreProfileViewController.selCategories.append(selectedCategoryArray[i])
                gMyStoreProfileViewController.selARCategories.append(selectedARCategoryArray[i])
            }
            
            gMyStoreProfileViewController.edt_category.text = ""
            gMyStoreProfileViewController.edt_category_ar.text = ""
            
            if selectedCategoryArray.count == 1{
                gMyStoreProfileViewController.edt_category.text = selectedCategoryArray[0]
                gMyStoreProfileViewController.edt_category_ar.text = selectedARCategoryArray[0]
            }else{
                gMyStoreProfileViewController.edt_category.text = "1." + selectedCategoryArray[0] + " 2." + selectedCategoryArray[1]
                gMyStoreProfileViewController.edt_category_ar.text = "1." + selectedARCategoryArray[0] + " 2." + selectedARCategoryArray[1]
                //            gMyStoreProfileViewController.edt_category_ar.text = selectedARCategoryArray[1] + ".2 " + selectedARCategoryArray[0] + ".1"
                
            }
            
            gMyStoreProfileViewController.closeCategoryList()
        }
        
    }
}
