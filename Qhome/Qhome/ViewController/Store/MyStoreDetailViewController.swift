//
//  MyStoreDetailViewController.swift
//  Qhome
//
//  Created by LGH419 on 7/18/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit
import YPImagePicker

class MyStoreDetailViewController: BaseViewController {
    
    @IBOutlet weak var view_nav: UIView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var view_profile: UIView!
    @IBOutlet weak var lbl_profile: UILabel!
    @IBOutlet weak var view_profile_indicator: UIView!
    @IBOutlet weak var view_products: UIView!
    @IBOutlet weak var lbl_products: UILabel!
    @IBOutlet weak var view_products_indicator: UIView!
    @IBOutlet weak var view_ratings: UIView!
    @IBOutlet weak var lbl_ratings: UILabel!
    @IBOutlet weak var view_ratings_indicator: UIView!
    @IBOutlet weak var view_addproduct: UIView!
    @IBOutlet weak var lbl_addproduct: UILabel!
    @IBOutlet weak var view_addproduct_indicator: UIView!
    @IBOutlet weak var view_container: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var picker:YPImagePicker!
    
    let unSelAttrs = [
        NSAttributedString.Key.foregroundColor : lightPrimaryColor,
        NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
        ] as [NSAttributedString.Key : Any]
    
    let selAttrs = [
        NSAttributedString.Key.foregroundColor : primaryColor,
        NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15),
        ] as [NSAttributedString.Key : Any]
    
    var storeProfileFrame:MyStoreProfileViewController!
    var storeProductsFrame:StoreProductsViewController!
    var storeRatingsFrame:MyStoreRatingsViewController!
    var storeNewProductFrame:MyStoreNewProductViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addShadowToBar(view: view_nav)
        gMyStoreDetailViewController = self
        
        var config = YPImagePickerConfiguration()
        config.wordings.libraryTitle = "Gallery"
        config.wordings.cameraTitle = "Camera"
        YPImagePickerConfiguration.shared = config
        picker = YPImagePicker()
        
        self.storeProfileFrame = self.storyboard!.instantiateViewController(withIdentifier: "MyStoreProfileViewController") as? MyStoreProfileViewController
        self.storeProfileFrame.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.storeProfileFrame.view.frame.size.height)
        
        self.storeProductsFrame = self.storyboard!.instantiateViewController(withIdentifier: "StoreProductsViewController") as? StoreProductsViewController
        self.storeProductsFrame.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.storeProductsFrame.view.frame.size.height)
        
        self.storeRatingsFrame = self.storyboard!.instantiateViewController(withIdentifier: "MyStoreRatingsViewController") as? MyStoreRatingsViewController
        self.storeRatingsFrame.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.storeRatingsFrame.view.frame.size.height)
        
        self.storeNewProductFrame = self.storyboard!.instantiateViewController(withIdentifier: "MyStoreNewProductViewController") as? MyStoreNewProductViewController
        self.storeNewProductFrame.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.storeNewProductFrame.view.frame.size.height)
        
        // So important!!!
        self.view_container.frame.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 93.0)
        
        var tap = UITapGestureRecognizer(target: self, action: #selector(self.tappedProfile(_:)))
        self.view_profile.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.tappedProducts(_:)))
        self.view_products.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.tappedRatings(_:)))
        self.view_ratings.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.tappedAddProduct(_:)))
        self.view_addproduct.addGestureRecognizer(tap)
        
        self.selProfile()
        
    }
    
    @objc func tappedProfile(_ sender: UITapGestureRecognizer? = nil) {
        self.selProfile()
    }
    
    @objc func tappedProducts(_ sender:UITapGestureRecognizer? = nil){
        self.selProducts()
    }
    
    @objc func tappedRatings(_ sender:UITapGestureRecognizer? = nil){
        self.selRatings()
    }
    
    @objc func tappedAddProduct(_ sender:UITapGestureRecognizer? = nil){
        self.selAddProduct()
    }
    
    func resetTabs(){
        
        self.lbl_profile.attributedText = NSAttributedString(string: Language().profile, attributes: unSelAttrs)
        self.lbl_products.attributedText = NSAttributedString(string: Language().products, attributes: unSelAttrs)
        self.lbl_ratings.attributedText = NSAttributedString(string: Language().ratings, attributes: unSelAttrs)
        self.lbl_addproduct.attributedText = NSAttributedString(string: Language().add_product, attributes: unSelAttrs)
        
        self.view_profile_indicator.isHidden = true
        self.view_products_indicator.isHidden = true
        self.view_ratings_indicator.isHidden = true
        self.view_addproduct_indicator.isHidden = true
        
    }
    
    func selProfile(){
        self.storeProductsFrame.view.removeFromSuperview()
        self.storeRatingsFrame.view.removeFromSuperview()
        self.storeNewProductFrame.view.removeFromSuperview()
        self.resetTabs()
        self.lbl_profile.attributedText = NSAttributedString(string: Language().profile, attributes: selAttrs)
        self.view_profile_indicator.isHidden = false
        if lang == "ar"{
            self.scrollView.setContentOffset(CGPoint(x: scrollView.contentSize.width - scrollView.frame.size.width, y: 0.0), animated: true)
        }else{
            self.scrollView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
        }
        
        UIView.animate(withDuration: 0.3){() -> Void in
            self.storeProfileFrame.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            self.view_container.addSubview(self.storeProfileFrame.view)
        }
    }
    
    func selProducts(){
        self.storeProfileFrame.view.removeFromSuperview()
        self.storeRatingsFrame.view.removeFromSuperview()
        self.storeNewProductFrame.view.removeFromSuperview()
        self.resetTabs()
        self.lbl_products.attributedText = NSAttributedString(string: Language().products, attributes: selAttrs)
        self.view_products_indicator.isHidden = false
        if lang == "ar"{
            self.scrollView.setContentOffset(CGPoint(x: scrollView.contentSize.width - scrollView.frame.size.width, y: 0.0), animated: true)
        }else{
            self.scrollView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
        }
        
        UIView.animate(withDuration: 0.3){() -> Void in
            self.storeProductsFrame.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            self.storeProductsFrame.productList.frame.size.height = self.view_container.frame.height - self.storeProductsFrame.view_header.frame.height - 10
            self.view_container.addSubview(self.storeProductsFrame.view)
        }
    }
    
    func selRatings(){
        self.storeProfileFrame.view.removeFromSuperview()
        self.storeProductsFrame.view.removeFromSuperview()
        self.storeNewProductFrame.view.removeFromSuperview()
        self.resetTabs()
        self.lbl_ratings.attributedText = NSAttributedString(string: Language().ratings, attributes: selAttrs)
        self.view_ratings_indicator.isHidden = false
        if lang == "ar"{
            self.scrollView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
        }else{
            self.scrollView.setContentOffset(CGPoint(x: scrollView.contentSize.width - scrollView.frame.size.width, y: 0.0), animated: true)
        }
        UIView.animate(withDuration: 0.3){() -> Void in
            self.storeRatingsFrame.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            self.storeRatingsFrame.ratingsList.frame.size.height = self.view_container.frame.height - 40
            self.view_container.addSubview(self.storeRatingsFrame.view)
        }
    }
    
    func selAddProduct(){
        self.storeProfileFrame.view.removeFromSuperview()
        self.storeProductsFrame.view.removeFromSuperview()
        self.storeRatingsFrame.view.removeFromSuperview()
        self.resetTabs()
        self.lbl_addproduct.attributedText = NSAttributedString(string: Language().add_product, attributes: selAttrs)
        self.view_addproduct_indicator.isHidden = false
        if lang == "ar"{
            self.scrollView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
        }else{
            self.scrollView.setContentOffset(CGPoint(x: scrollView.contentSize.width - scrollView.frame.size.width, y: 0.0), animated: true)
        }
        
        UIView.animate(withDuration: 0.3){() -> Void in
            self.storeNewProductFrame.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            self.storeNewProductFrame.view_picturelist.frame.size.width = UIScreen.main.bounds.width - 40
            self.storeNewProductFrame.view_picturelist.addDashBorder(color: primaryColor)
            self.view_container.addSubview(self.storeNewProductFrame.view)
        }
    }
    
    @IBAction func back(_ sender: Any) {
        gMyStoreProfileViewController = nil
        gMyStoreDetailViewController = nil
        dismissViewController()
    }
    
    func pickPicture(){
        picker.didFinishPicking { [picker] items, _ in
            if let photo = items.singlePhoto {
                self.storeProfileFrame.img_logo.image = photo.image
                self.storeProfileFrame.img_logo.layer.cornerRadius = 15
                self.storeProfileFrame.imageFile = photo.image.jpegData(compressionQuality: 0.8)
            }
            picker!.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
    
    func pickProductPicture(){
        picker.didFinishPicking { [picker] items, _ in
            if let photo = items.singlePhoto {
                self.storeNewProductFrame.sliderImagesArray.add(photo.image)
                let imageFile = photo.image.jpegData(compressionQuality: 0.8)
                self.storeNewProductFrame.sliderImageFilesArray.add(imageFile!)

                self.storeNewProductFrame.loadPictures()
            }
            picker!.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }

}
