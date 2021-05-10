//
//  MyStoreNewProductViewController.swift
//  Qhome
//
//  Created by LGH419 on 7/18/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit
import SCLAlertView
import Kingfisher

class MyStoreNewProductViewController: BaseViewController {
    
    @IBOutlet weak var img_logo: UIImageView!
    @IBOutlet weak var lbl_storename: UILabel!
    @IBOutlet weak var view_opencamera: UIView!
    @IBOutlet weak var btn_opencamera: UIButton!
    @IBOutlet weak var view_picturelist: UIView!
    @IBOutlet weak var image_scrollview: UIScrollView!
    @IBOutlet weak var pagecontroll: UIPageControl!
    @IBOutlet weak var view_productname: UIView!
    @IBOutlet weak var edt_productname: UITextField!
    @IBOutlet weak var edt_product_arname: UITextField!
    @IBOutlet weak var view_category: UIView!
    @IBOutlet weak var edt_category: UITextField!
    @IBOutlet weak var edt_arcategory: UITextField!
    @IBOutlet weak var view_desc: UIView!
    @IBOutlet weak var edt_desc: UITextView!
    @IBOutlet weak var edt_ardesc: UITextView!
    @IBOutlet weak var btn_submit: UIButton!
    @IBOutlet weak var view_price: UIView!
    @IBOutlet weak var edt_price: UITextField!
    
    var sliderImagesArray = NSMutableArray()
    var sliderImageFilesArray = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        gMyStoreDetailViewController!.lbl_title.text = Language().mystore
        img_logo.layer.cornerRadius = 8
        edt_price.keyboardType = UIKeyboardType.decimalPad
        
        self.loadPicture(imageView: img_logo, url: URL(string: gStore.logoUrl)!)
        if lang == "ar"{
            lbl_storename.text = gStore.arName
        }else{
            lbl_storename.text = gStore.name
        }
        
        setRoundShadowView(view: view_productname, corner: 5)
        setRoundShadowView(view: view_price, corner: 5)
        setRoundShadowView(view: view_category, corner: 5)
        setRoundShadowView(view: view_desc, corner: 5)
        setRoundShadowButton(button: btn_submit, corner: 25)
        edt_desc.delegate = self
        edt_desc.layer.cornerRadius = 3
        edt_desc.layer.borderWidth = 1
        edt_desc.layer.borderColor = UIColor(rgb: 0xd9d9d9, alpha: 0.8).cgColor
        edt_desc.setPlaceholder(string: Language().write_something)
        edt_desc.textContainerInset = UIEdgeInsets(top: 8, left: 4, bottom: 50, right: 4)
        
        image_scrollview.delegate = self
        
        view_picturelist.visibility = .visible
        view_opencamera.visibility = .gone
        pagecontroll.numberOfPages = 0
        
    }
    
    func textViewDidChange(_ textView: UITextView) { //Handle the text changes here
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
    
    @IBAction func submit(_ sender: Any) {
        if self.sliderImageFilesArray.count == 0{
            self.showToast(msg: Language().loadproductpictures)
            return
        }
        
        if self.edt_productname.text == ""{
            self.showToast(msg: Language().enterproductname)
            return
        }
        
        if self.edt_arcategory.text == ""{
            self.showToast(msg: Language().choose_category)
            return
        }
        
        if self.edt_price.text == ""{
            self.showToast(msg: Language().enterproductprice)
            return
        }
        
        if String(self.edt_price.text!).isNumber() == false{
            self.showToast(msg: Language().entervalidnumberforprice)
            return
        }
        
        if self.edt_desc.text == ""{
            self.showToast(msg: Language().enterproductdescription)
            return
        }
        
        let parameters: [String:Any] = [
            "store_id" : String(gStore.idx),
            "member_id" : String(thisUser.idx),
            "name" : self.edt_productname.text as Any,
            "ar_name" : self.edt_product_arname.text as Any,
            "category" : self.edt_category.text as Any,
            "ar_category": self.edt_arcategory.text as Any,
            "price" : self.edt_price.text as Any,
            "unit" : "qr",
            "description": self.edt_desc.text as Any,
            "ar_description" : self.edt_ardesc.text as Any,
            "pic_count" : String(self.sliderImageFilesArray.count) as Any
        ]
        
        let ImageArray:NSMutableArray = []
        for image in self.sliderImageFilesArray{
            ImageArray.add(image as! Data)
        }
        
        self.showLoadingView()
        APIs().postImageArrayRequestWithURL(withUrl: ReqConst.SERVER_URL + "upProduct", withParam: parameters, withImages: ImageArray) { (isSuccess, response) in
            // Your Will Get Response here
            self.dismissLoadingView()
            print("Response: \(response)")
            if isSuccess == true{
                let result = response["result_code"] as Any
                print("Result: \(result)")
                if result as! String == "0"{
                    self.sliderImagesArray.removeAllObjects()
                    self.sliderImageFilesArray.removeAllObjects()
                    self.loadPictures()
                    self.edt_productname.text = ""
                    self.edt_product_arname.text = ""
                    self.edt_category.text = ""
                    self.edt_arcategory.text = ""
                    self.edt_price.text = ""
                    self.edt_desc.text = ""
                    self.edt_ardesc.text = ""
                    gMyStoreDetailViewController!.showToast(msg: Language().uploaded)
                    gMyStoreDetailViewController?.selProducts()
                }else{
                    self.showToast(msg: Language().serverissue)
                }
            }else{
                let message = "File size: " + String(response.fileSize()) + "\n" + "Description: " + response.description
                self.showToast(msg: "Issue: \n" + message)
            }
        }
    }
    
    @IBAction func delPicture(_ sender: Any) {
        if self.sliderImagesArray.count > 0{
            self.sliderImagesArray.remove(self.sliderImagesArray[self.pagecontroll.currentPage])
            self.sliderImageFilesArray.remove(self.sliderImageFilesArray[self.pagecontroll.currentPage])
            self.loadPictures()
        }
    }
    
    @IBAction func addPicture(_ sender: Any) {
        gMyStoreDetailViewController!.pickProductPicture()
    }
    
    @IBAction func openCategory(_ sender: Any) {
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: true
        )
        let alert = SCLAlertView(appearance: appearance)
        if lang == "ar"{
            alert.addButton(gStore.arCategory, backgroundColor: UIColor.blue, textColor: .white, showTimeout: nil, action: {
                self.edt_category.text = gStore.category
                self.edt_arcategory.text = gStore.arCategory
            })
            if gStore.arCategory2 != ""{
                alert.addButton(gStore.arCategory2, backgroundColor: UIColor.blue, textColor: .white, showTimeout: nil, action: {
                    self.edt_category.text = gStore.category2
                    self.edt_arcategory.text = gStore.arCategory2
                })
            }
        }else{
            alert.addButton(gStore.category, backgroundColor: UIColor.blue, textColor: .white, showTimeout: nil, action: {
                self.edt_category.text = gStore.category
                self.edt_arcategory.text = gStore.arCategory
            })
            if gStore.category2 != ""{
                alert.addButton(gStore.category2, backgroundColor: UIColor.blue, textColor: .white, showTimeout: nil, action: {
                    self.edt_category.text = gStore.category2
                    self.edt_arcategory.text = gStore.arCategory2
                })
            }
        }
        
        alert.showWarning(Language().choose_category, subTitle: "")
        
    }
    
    @IBAction func changePage(_ sender: Any) {
        let x = CGFloat(pagecontroll.currentPage) * image_scrollview.frame.size.width
        image_scrollview.setContentOffset(CGPoint(x: x,y :0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageNumber = round(image_scrollview.contentOffset.x / image_scrollview.frame.size.width)
        pagecontroll.currentPage = Int(pageNumber)
    }
    
    func loadPictures(){
        if sliderImagesArray.count > 0{
            self.image_scrollview.subviews.map { $0.removeFromSuperview() }
        }
        print("Files: \(sliderImageFilesArray.count)")
        for i in 0..<sliderImagesArray.count {
            var imageView : UIImageView
            let xOrigin = self.image_scrollview.frame.size.width * CGFloat(i)
            imageView = UIImageView(frame: CGRect(x: xOrigin, y: 0, width: self.image_scrollview.frame.size.width, height: self.image_scrollview.frame.size.height))
            imageView.isUserInteractionEnabled = true
//            let urlStr = sliderImagesArray.object(at: i)
//            print(image_scrollview,imageView, urlStr)
//
//            let url = URL(string: sliderImagesArray[i] as! String)
//            let data = try? Data(contentsOf: url!)
//            let image = UIImage(data: data!)
            imageView.image = (sliderImagesArray.object(at: i) as! UIImage)
            imageView.contentMode = UIView.ContentMode.scaleAspectFit
            self.image_scrollview.addSubview(imageView)
        }
        
        self.image_scrollview.isPagingEnabled = true
        self.image_scrollview.bounces = false
        self.image_scrollview.showsVerticalScrollIndicator = false
        self.image_scrollview.showsHorizontalScrollIndicator = false
        self.image_scrollview.contentSize = CGSize(width:
            self.image_scrollview.frame.size.width * CGFloat(sliderImagesArray.count), height: self.image_scrollview.frame.size.height)
                self.pagecontroll.addTarget(self, action: #selector(self.changePage(_ :)), for: UIControl.Event.valueChanged)
        
        self.pagecontroll.numberOfPages = sliderImagesArray.count
        
        let x = CGFloat(self.pagecontroll.numberOfPages - 1) * self.image_scrollview.frame.size.width
        self.image_scrollview.setContentOffset(CGPoint(x: x,y :0), animated: true)
        self.pagecontroll.currentPage = self.pagecontroll.numberOfPages - 1
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
    
}
