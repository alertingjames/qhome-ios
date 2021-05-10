//
//  RegisterStoreViewController.swift
//  Qhome
//
//  Created by LGH419 on 7/15/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit
import YPImagePicker
import Alamofire
import SCLAlertView

class RegisterStoreViewController: BaseViewController {
    
    @IBOutlet weak var lbl_count: UILabel!
    @IBOutlet weak var view_nav: UIView!
    @IBOutlet weak var img_logo: UIImageView!
    @IBOutlet weak var view_store_name: UIView!
    @IBOutlet weak var edt_store_name: UITextField!
    @IBOutlet weak var edt_ar_store_name: UITextField!
    @IBOutlet weak var view_category: UIView!
    @IBOutlet weak var txt_category: UITextField!
    @IBOutlet weak var txt_ar_category: UITextField!
    @IBOutlet weak var view_description: UIView!
    @IBOutlet weak var edt_description: UITextView!
    @IBOutlet weak var edt_ar_description: UITextView!
    @IBOutlet weak var btn_submit: UIButton!
    @IBOutlet weak var btn_comuse: UIButton!
    
    var compriceListData = [CompanyPrice]()
    var priceId:Int64 = 0
    var isChecked:Bool = false
    
    let checkbox = UIImage(named: "checked_maroon")
    let noCheckBox = UIImage(named: "unchecked_maroon")
    
    let selectediconar = UIImage(named: "checked_maroon_flip")
    let noselectediconar = UIImage(named: "unchecked_maroon_flip")
    
    var picker:YPImagePicker!
    var imageFile:Data? = nil
    var ImageArray : NSMutableArray!
    
    var selCategories = [String]()
    var selARCategories = [String]()
    var categoryList:CategoryListViewController!
    var dark_background:DarkBackgroundViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        gRegisterStoreViewController = self

        initUI()
        
        
    }
    
    func initUI(){
        
        addShadowToBar(view: view_nav)
        setRoundShadowView(view: view_store_name, corner: 5)
        setRoundShadowView(view: view_category, corner: 5)
        setRoundShadowView(view: view_description, corner: 5)
        setRoundShadowButton(button: btn_submit, corner: 25)
        
        edt_description.delegate = self
        edt_description.layer.cornerRadius = 3
        edt_description.layer.borderWidth = 1
        edt_description.layer.borderColor = UIColor(rgb: 0xd9d9d9, alpha: 0.8).cgColor
        edt_description.setPlaceholder(string: Language().write_something)
        edt_description.textContainerInset = UIEdgeInsets(top: 8, left: 4, bottom: 50, right: 4)
        
        let fixedWidth = self.edt_description.frame.size.width
        self.edt_description.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = self.edt_description.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = self.edt_description.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        self.edt_description.frame = newFrame
        
        var config = YPImagePickerConfiguration()
        config.wordings.libraryTitle = "Gallery"
        config.wordings.cameraTitle = "Camera"
        YPImagePickerConfiguration.shared = config
        picker = YPImagePicker()
        
        let logoTap = UITapGestureRecognizer(target: self, action: #selector(self.logoTapped(gesture:)))
        img_logo.addGestureRecognizer(logoTap)
        img_logo.isUserInteractionEnabled = true
        
        self.categoryList = self.storyboard!.instantiateViewController(withIdentifier: "CategoryListViewController") as? CategoryListViewController
        self.categoryList.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.dark_background = self.storyboard!.instantiateViewController(withIdentifier: "DarkBackgroundViewController") as? DarkBackgroundViewController
        self.dark_background.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        if gMyStores.count == 0{
            self.lbl_count.text = "1/2"
        }else if gMyStores.count == 1{
            self.lbl_count.text = "2/2"
        }
        
        self.getCompanyPrices()
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textView.checkPlaceholder()
        if textView.text == ""{
            textView.textContainerInset = UIEdgeInsets(top: 8, left: 4, bottom: 50, right: 4)
        }else{
            if textView.contentSize.height > 100{
                textView.textContainerInset = UIEdgeInsets(top: 8, left: 4, bottom: 15, right: 4)
            }else{
                textView.textContainerInset = UIEdgeInsets(top: 8, left: 4, bottom: 50, right: 4)
            }
        }
    }
    
    @objc func logoTapped(gesture: UIGestureRecognizer) {
        if (gesture.view as? UIImageView) != nil {
            print("Logo Tapped")
            picker.didFinishPicking { [picker] items, _ in
                if let photo = items.singlePhoto {
                    self.img_logo.image = photo.image
                    self.img_logo.layer.cornerRadius = 15
                    self.imageFile = photo.image.jpegData(compressionQuality: 0.8)
                }
                picker!.dismiss(animated: true, completion: nil)
            }
            present(picker, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func back(_ sender: Any) {
        gRegisterStoreViewController = nil
        dismissViewController()
    }
    
    @IBAction func submitStoreInfo(_ sender: Any) {
        if self.edt_store_name.text == ""{
            self.showToast(msg: Language().enterstorename)
            return
        }
        if self.edt_description.text == ""{
            self.showToast(msg: Language().enterdesc)
            return
        }
        if self.edt_ar_store_name.text == ""{
            self.showToast(msg: Language().enterstorenameinarabic)
            return
        }
        if self.edt_ar_description.text == ""{
            self.showToast(msg: Language().enterdescriptioninarabic)
            return
        }
        if self.selCategories.count == 0{
            self.showToast(msg: Language().choose_category)
            return
        }
        if self.imageFile == nil{
            self.showToast(msg: Language().loadlogo)
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
            "member_id" : String(thisUser.idx),
            "name" : self.edt_store_name.text as Any,
            "category" : cat1,
            "category2": cat2,
            "description": self.edt_description.text as Any,
            "ar_name": self.edt_ar_store_name.text as Any,
            "ar_category": acat1,
            "ar_category2" : acat2,
            "ar_description" : self.edt_ar_description.text as Any,
            "price_id" : String(self.priceId)
        ]
        
        // Here is your image is in DATA formate don’t send as UIImage formate
        let ImageDic = ["file" : imageFile!]
        // Here you can pass multiple image in array i am passing just one
        ImageArray = NSMutableArray(array: [ImageDic as NSDictionary])
        
        self.showLoadingView()
        APIs().postImageRequestWithURL(withUrl: ReqConst.SERVER_URL + "registerStore", withParam: parameters, withImages: ImageArray) { (isSuccess, response) in
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
                        let count = response["count"] as! String
                        if Int(count) == 1{
                            self.lbl_count.text = "2/2"
                            self.img_logo.image = nil
                            self.imageFile = nil
                            self.edt_store_name.text = ""
                            self.edt_ar_store_name.text = ""
                            self.edt_description.text = ""
                            self.edt_ar_description.text = ""
                            self.txt_category.text = ""
                            self.txt_ar_category.text = ""
                        }else{
                            gRegisterStoreViewController = nil
                            self.dismissViewController()
                        }
                    }
                    alert.showWarning(Language().accountprogress, subTitle: Language().accountprogresstext)
                }
            }else{
                let message = "File size: " + String(response.fileSize()) + "\n" + "Description: " + response.description
                self.showToast(msg: "Issue: \n" + message)
            }
        }
        
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
            self.addChild(self.dark_background)
            self.view.addSubview(self.dark_background.view)
            self.categoryList.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            self.addChild(self.categoryList)
            self.view.addSubview(self.categoryList.view)
        }
    }
    
    func closeCategoryList(){
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            self.categoryList.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            self.dark_background.view.removeFromSuperview()
        }){
            (finished) in
            self.dark_background.view.removeFromSuperview()
            self.categoryList.view.removeFromSuperview()
        }
    }
    
    
    @IBAction func checkCompanyUse(_ sender: Any) {
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
