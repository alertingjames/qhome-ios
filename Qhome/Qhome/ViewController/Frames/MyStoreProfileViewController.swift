//
//  MyStoreProfileViewController.swift
//  Qhome
//
//  Created by LGH419 on 7/18/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit
import Kingfisher
import YPImagePicker
import SCLAlertView

class MyStoreProfileViewController: BaseViewController {
    
    @IBOutlet weak var btn_edit: UIButton!
    @IBOutlet weak var img_logo: UIImageView!
    @IBOutlet weak var lbl_likes: UILabel!
    @IBOutlet weak var btn_category: UIButton!
    @IBOutlet weak var edt_store_name: UITextField!
    @IBOutlet weak var edt_store_ar_name: UITextField!
    @IBOutlet weak var edt_category: UITextField!
    @IBOutlet weak var edt_category_ar: UITextField!
    @IBOutlet weak var edt_desc: UITextView!
    @IBOutlet weak var edt_ar_desc: UITextView!
    @IBOutlet weak var btn_comuse: UIButton!
    
    var compriceListData = [CompanyPrice]()
    var priceId:Int64 = 0
    var isChecked:Bool = false
    
    let checkbox = UIImage(named: "checked_maroon")
    let noCheckBox = UIImage(named: "unchecked_maroon")
    
    let selectediconar = UIImage(named: "checked_maroon_flip")
    let noselectediconar = UIImage(named: "unchecked_maroon_flip")
    
    var imageFile:Data!
    var ImageArray:NSMutableArray!
    
    var selCategories = [String]()
    var selARCategories = [String]()
    var categoryList:CategoryListViewController!
    var dark_background:DarkBackgroundViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gMyStoreProfileViewController = self
        
        gMyStoreDetailViewController!.lbl_title.text = Language().mystore

        img_logo.layer.cornerRadius = 10
        loadPicture(imageView: img_logo, url: URL(string: gStore.logoUrl)!)
        edt_store_name.isEnabled = false
        edt_store_ar_name.isEnabled = false
        edt_category.isEnabled = false
        edt_category_ar.isEnabled = false
        edt_desc.isEditable = false
        edt_ar_desc.isEditable = false
        btn_category.isHidden = true
        edt_store_name.text = gStore.name
        edt_store_ar_name.text = gStore.arName
        edt_desc.text = gStore.description
        edt_ar_desc.text = gStore.arDescription
        
        var cat2 = ""
        var cap = ""
        if gStore.category2 != ""{
            cap = "1."
            cat2 = " 2." + gStore.category2
        }
        
        self.edt_category.text = cap + gStore.category + cat2
        self.selCategories.removeAll()
        self.selCategories.append(gStore.category)
        self.selCategories.append(gStore.category2)
        self.btn_category.isHidden = true
        
        self.lbl_likes.text = String(gStore.likes)
        
        let attributeString = NSMutableAttributedString(string: Language().edit,
                                                        attributes: selectedButtonFont)
        btn_edit.setAttributedTitle(attributeString, for: .normal)
        
        if gStore.category2 == ""{
            edt_category.text = gStore.category
            edt_category_ar.text = gStore.arCategory
        }else{
            edt_category.text = gStore.category + ", " + gStore.category2
            edt_category_ar.text = gStore.arCategory + ", " + gStore.arCategory2
        }
        
        self.selARCategories.removeAll()
        self.selARCategories.append(gStore.arCategory)
        self.selARCategories.append(gStore.arCategory2)
        
        self.categoryList = self.storyboard!.instantiateViewController(withIdentifier: "CategoryListViewController") as? CategoryListViewController
        self.categoryList.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.dark_background = self.storyboard!.instantiateViewController(withIdentifier: "DarkBackgroundViewController") as? DarkBackgroundViewController
        self.dark_background.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        if gStore.priceId > 0{
            if lang == "ar"{
                self.btn_comuse.setImage(self.selectediconar, for: .normal)
            }else{
                self.btn_comuse.setImage(self.checkbox, for: .normal)
            }
            isChecked = true
        }else{
            if lang == "ar"{
                self.btn_comuse.setImage(self.noselectediconar, for: .normal)
            }else{
                self.btn_comuse.setImage(self.noCheckBox, for: .normal)
            }
            isChecked = false
        }
        
        self.getCompanyPrices()
        
    }
    
    func loadPicture(imageView:UIImageView, url:URL){
        let processor = DownsamplingImageProcessor(size: imageView.frame.size)
            >> ResizingImageProcessor(referenceSize: imageView.frame.size, mode: .aspectFill)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "appicon.jpg"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func loadLogo(_ sender: Any) {
        if edt_store_name.isEnabled == false{
            return
        }
        gMyStoreDetailViewController!.pickPicture()
    }
    
    @IBAction func openCategoryList(_ sender: Any) {
        selCategories.removeAll()
        selARCategories.removeAll()
        categoryList.selectedCategoryArray.removeAll()
        categoryList.selectedARCategoryArray.removeAll()
        // buttons
        for i in 0...self.categoryList.buttonArray.count - 1{
            self.categoryList.buttonArray[i].setImage(self.categoryList.noselectedicon, for: UIControl.State.normal)
        }
        UIView.animate(withDuration: 0.5){() -> Void in
            gMyStoreDetailViewController!.addChild(self.dark_background)
            gMyStoreDetailViewController!.view.addSubview(self.dark_background.view)
            self.categoryList.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            gMyStoreDetailViewController!.addChild(self.categoryList)
            gMyStoreDetailViewController!.view.addSubview(self.categoryList.view)
        }
    }
    
    func closeCategoryList(){
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            self.categoryList.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            self.dark_background.view.removeFromSuperview()
        }){
            (finished) in
            self.categoryList.view.removeFromSuperview()
        }
    }

    @IBAction func edit(_ sender: Any) {
        if edt_store_name.isEnabled == false{
            edt_store_name.isEnabled = true
            edt_store_ar_name.isEnabled = true
            edt_desc.isEditable = true
            edt_ar_desc.isEditable = true
            btn_category.isHidden = false
            let attributeString = NSMutableAttributedString(string: Language().submit,
                                                            attributes: selectedButtonFont)
            btn_edit.setAttributedTitle(attributeString, for: .normal)
        }else{
            btn_category.isHidden = true
            edt_store_name.isEnabled = false
            edt_store_ar_name.isEnabled = false
            edt_desc.isEditable = false
            edt_ar_desc.isEditable = false
            let attributeString = NSMutableAttributedString(string: Language().edit,
                                                            attributes: selectedButtonFont)
            btn_edit.setAttributedTitle(attributeString, for: .normal)
            self.submitStoreInfo()
        }
    }
    
    func submitStoreInfo(){
        
        var catt2 = ""
        if gStore.category2 != ""{
            catt2 = ", " + gStore.category2
        }
        
        if imageFile == nil && self.edt_store_name.text == gStore.name && self.edt_store_ar_name.text == gStore.arName && self.edt_category.text == gStore.category + catt2 && self.edt_desc.text == gStore.description && self.edt_ar_desc.text == gStore.arDescription{
            return
        }
        
        if self.edt_store_name.text == ""{
            self.showToast(msg: Language().enterstorename)
            return
        }
        if self.edt_desc.text == ""{
            self.showToast(msg: Language().enterdesc)
            return
        }
        if self.edt_store_ar_name.text == ""{
            self.showToast(msg: Language().enterstorenameinarabic)
            return
        }
        if self.edt_ar_desc.text == ""{
            self.showToast(msg: Language().enterdescriptioninarabic)
            return
        }
        if self.edt_category.text == ""{
            self.showToast(msg: Language().choose_category)
            return
        }
        
        var cat1 = ""
        var cat2 = ""
        var acat1 = ""
        var acat2 = ""
        
        if selCategories.count == 1{
            cat1 = selCategories[0]
            acat1 = selARCategories[0]
        }else{
            cat1 = selCategories[0]
            acat1 = selARCategories[0]
            cat2 = selCategories[1]
            acat2 = selARCategories[1]
        }
        
        let parameters: [String:Any] = [
            "store_id" : String(gStore.idx),
            "member_id" : String(thisUser.idx),
            "name" : self.edt_store_name.text as Any,
            "category" : cat1,
            "category2": cat2,
            "description": self.edt_desc.text as Any,
            "ar_name": self.edt_store_ar_name.text as Any,
            "ar_category": acat1,
            "ar_category2" : acat2,
            "ar_description" : self.edt_ar_desc.text as Any,
            "price_id" : String(self.priceId)
        ]
        
        if imageFile != nil{
            // Here is your image is in DATA formate don’t send as UIImage formate
            let ImageDic = ["file" : imageFile!]
            // Here you can pass multiple image in array i am passing just one
            ImageArray = NSMutableArray(array: [ImageDic as NSDictionary])
            
            self.showLoadingView()
            APIs().postImageRequestWithURL(withUrl: ReqConst.SERVER_URL + "updateStore", withParam: parameters, withImages: ImageArray) { (isSuccess, response) in
                // Your Will Get Response here
                self.dismissLoadingView()
                if isSuccess == true{
                    let result = response["result_code"] as Any
                    print("Result: \(result)")
                    if result as! String == "0"{
                        let appearance = SCLAlertView.SCLAppearance(
                            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
                            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
                            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
                            showCloseButton: true
                        )
                        let alert = SCLAlertView(appearance: appearance)
                        alert.addButton(Language().ok) {
                            gMyStoreDetailViewController?.dismissViewController()
                        }
                        alert.showWarning(Language().accountprogress, subTitle: Language().accountprogresstext)
                    }
                }
            }
        }else{            
            self.showLoadingView()
            APIs().postRequestWithURL(withUrl: ReqConst.SERVER_URL + "updateStore", withParam: parameters) { (isSuccess, response) in
                // Your Will Get Response here
                self.dismissLoadingView()
                if isSuccess == true{
                    let result = response["result_code"] as Any
                    print("Result: \(result)")
                    if result as! String == "0"{
                        let appearance = SCLAlertView.SCLAppearance(
                            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
                            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
                            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
                            showCloseButton: true
                        )
                        let alert = SCLAlertView(appearance: appearance)
                        alert.addButton(Language().ok) {
                            gMyStoreDetailViewController?.dismissViewController()
                        }
                        alert.showWarning(Language().accountprogress, subTitle: Language().accountprogresstext)
                    }
                }
            }
        }
        
    }
    
    @IBAction func checkComUse(_ sender: Any) {
        if edt_store_name.isEnabled{
            if isChecked == true{
                isChecked = false
                if lang == "ar"{
                    btn_comuse.setImage(noselectediconar, for: .normal)
                }else{
                    btn_comuse.setImage(noCheckBox, for: .normal)
                }
            }else{
                isChecked = true
                if lang == "ar"{
                    btn_comuse.setImage(selectediconar, for: .normal)
                }else{
                    btn_comuse.setImage(checkbox, for: .normal)
                }
                self.openCompriceList()
            }
        }else{
            if gStore.priceId > 0{
                if lang == "ar"{
                    btn_comuse.setImage(selectediconar, for: .normal)
                }else{
                    btn_comuse.setImage(checkbox, for: .normal)
                }
            }else{
                if lang == "ar"{
                    btn_comuse.setImage(noselectediconar, for: .normal)
                }else{
                    btn_comuse.setImage(noCheckBox, for: .normal)
                }
            }
        }
    }
    
    func getCompanyPrices()
    {
        APIs.getComprices(handleCallback:{
            comprices, result_code in
            print(result_code)
            self.compriceListData.removeAll()
            if result_code == "0"{
                self.compriceListData = comprices!
            }
            
        })
    }
    
    func openCompriceList(){
        
        let alert = UIAlertController(title: Language().naql_company, message: Language().selectprice, preferredStyle: .alert)
        
        for i in 0..<self.compriceListData.count{
            let priceStr = String(self.compriceListData[i].price) + " " + self.compriceListData[i].description
            
            let price_action = UIAlertAction(title: priceStr, style: UIAlertAction.Style.default){(ACTION) in
                self.priceId = self.compriceListData[i].id
            }
            
            alert.addAction(price_action)
            
        }
        
        let close = UIAlertAction(title: "Close", style: .destructive){(ACTION) in
            self.isChecked = false
            if lang == "ar"{
                self.btn_comuse.setImage(self.noselectediconar, for: .normal)
            }else{
                self.btn_comuse.setImage(self.noCheckBox, for: .normal)
            }
            self.priceId = 0
        }
        
        alert.addAction(close)
        self.present(alert, animated:true, completion:nil);
        
    }
    
}
