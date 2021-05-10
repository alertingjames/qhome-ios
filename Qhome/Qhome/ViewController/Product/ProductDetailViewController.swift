//
//  ProductDetailViewController.swift
//  Qhome
//
//  Created by LGH419 on 7/20/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit
import Kingfisher
import Auk
import DynamicBlurView
import GSImageViewerController

class ProductDetailViewController: BaseViewController {
    
    private var lastContentOffset: CGFloat = 0
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var view_nav: UIView!
    @IBOutlet weak var image_scrollview: UIScrollView!
    @IBOutlet weak var txt_desc: UITextView!
    @IBOutlet weak var lbl_productname: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var lbl_storename: UILabel!
    @IBOutlet weak var view_pictures: UIView!
    
    @IBOutlet weak var lbl_storename_nav: UILabel!
    @IBOutlet weak var view_cart: UIView!
    @IBOutlet weak var view_count: UIView!
    @IBOutlet weak var lbl_count: UILabel!
    @IBOutlet weak var view_footer: UIView!
    @IBOutlet weak var lbl_count2: UILabel!
    
    var sliderImagesArray = NSMutableArray()
    var count:Int = 1
    
    var blurView:DynamicBlurView!
    
    var colors = [UIColor.red.cgColor, UIColor.green.cgColor, UIColor.cyan.cgColor, UIColor.yellow.cgColor, UIColor.blue.cgColor]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setGradientBackground(colorBottom: UIColor.white, colorTop: UIColor(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.0), view: view_footer)

        scrollview.delegate = self
        image_scrollview.auk.settings.contentMode = .scaleAspectFill
        // background settings
//        image_scrollview.auk.settings.pageControl.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
//        image_scrollview.auk.settings.placeholderImage = UIImage(named: "placeholder.jpg")
        
        self.blurView = DynamicBlurView(frame: self.view_pictures.bounds)
        
        lbl_count2.text = String(count)
        
        if lang == "ar"{
            lbl_storename.text = gStore.arName
            lbl_storename_nav.text = ""
            lbl_price.text = "QR " + String(gProduct.price)
            lbl_productname.text = gProduct.arName
            txt_desc.text = gProduct.arDescription
        }else{
            lbl_storename.text = gStore.name
            lbl_storename_nav.text = ""
            lbl_price.text = String(gProduct.price) + " QR"
            lbl_productname.text = gProduct.name
            txt_desc.text = gProduct.description
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.toCart(_:)))
        self.view_cart.addGestureRecognizer(tap)
        
        self.getProductPictures()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {        
        if gProduct.userId == thisUser.idx{
            self.view_footer.isHidden = true
        }
    }
    
    @objc func toCart(_ sender: UITapGestureRecognizer? = nil) {
        let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "CartViewController"))!
        conVC.modalPresentationStyle = .fullScreen
        transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
    }
    
    func getProductPictures(){
        
        APIs.getProductPictures(product_id: gProduct.idx, handleCallback: {
            pictures, result_code in
            print(result_code)
            if result_code == "0"{
                self.sliderImagesArray.addObjects(from: pictures!)
                
                for pic in pictures!{
                    self.sliderImagesArray.add(pic.url)
                    self.image_scrollview.auk.show(url: pic.url)
                }
                
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.tappedScrollView(_:)))
                self.image_scrollview.addGestureRecognizer(tap)
            }
        })
        
    }
    
    @objc func tappedScrollView(_ sender: UITapGestureRecognizer? = nil) {
        let index = self.image_scrollview.auk.currentPageIndex
        print("tapped on Image: \(index)")
        let images = self.image_scrollview.auk.images
        let image = images[index!]
        
        let imageInfo   = GSImageInfo(image: image , imageMode: .aspectFit)
        let transitionInfo = GSTransitionInfo(fromView: self.image_scrollview)
        let imageViewer = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
        
        imageViewer.dismissCompletion = {
            print("dismissCompletion")
        }
        
        present(imageViewer, animated: true, completion: nil)
    }
    
    @IBAction func back(_ sender: Any) {
        if gStoreDetailViewController != nil{
            gStoreDetailViewController?.getCart(imei: gIMEI)
        }
        self.view.removeFromSuperview()
//        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func increase(_ sender: Any) {
        count = count + 1
        lbl_count2.text = String(count)
    }
    
    @IBAction func decrease(_ sender: Any) {
        if count > 1{
            count = count - 1
            lbl_count2.text = String(count)
        }
    }
    
    @IBAction func addCart(_ sender: Any) {
        
        self.addToCart(pictureUrl: gProduct.pictureUrl, imei_id: gIMEI, producerId: gProduct.userId, storeId: gStore.idx, storeName: gStore.name, storeARName: gStore.arName, productId: gProduct.idx, productName: gProduct.name, productARName: gProduct.arName, category: gProduct.category, arCategory: gProduct.arCategory, price: gProduct.price, unit: "qr", quantity: self.count, compriceId:gComPriceId)
    }
    
    func addToCart(pictureUrl:String,
                  imei_id:String,
                  producerId:Int64,
                  storeId: Int64,
                  storeName:String,
                  storeARName:String,
                  productId:Int64,
                  productName:String,
                  productARName:String,
                  category:String,
                  arCategory:String,
                  price:Float,
                  unit:String,
                  quantity:Int,
                  compriceId:Int64
        )
    {
        self.view.endEditing(true)
        showLoadingView()
        APIs.addProductToCart(picture_url:pictureUrl, imei_id:imei_id, producer_id: producerId, store_id: storeId, store_name: storeName, store_ar_name: storeARName, product_id: productId, product_name:productName, product_ar_name: productARName, category: category, ar_category: arCategory,
                              price: price, unit: unit, quantity: quantity, compriceId: compriceId, handleCallback:{
            result_code in
            self.dismissLoadingView()
            print(result_code)
            if result_code == "0"{
                let conVC = AppDelegate.currentStoryboard.instantiateViewController(withIdentifier: "CartViewController")
                conVC.modalPresentationStyle = .fullScreen
                self.transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
            }
        })
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.lastContentOffset > scrollView.contentOffset.y) {
            // move down
            // print("Now scrolling down\(scrollView.contentOffset.y)")
            if scrollView.contentOffset.y < 200{
                lbl_storename_nav.text = ""
                if lang == "ar"{
                    lbl_storename.text = gStore.arName
                }else{
                    lbl_storename.text = gStore.name
                }
                view_nav.layer.backgroundColor = nil
                
                if scrollView.contentOffset.y < 50{
                    self.blurView.alpha = 0
                }
            }
        }
        else if (self.lastContentOffset < scrollView.contentOffset.y) {
            // move up
            // print("Now scrolling up\(scrollView.contentOffset.y)")
            if scrollView.contentOffset.y > 100{
                if lang == "ar"{
                    lbl_storename_nav.text = gStore.arName
                }else{
                    lbl_storename_nav.text = gStore.name
                }
                lbl_storename.text = ""
                view_nav.layer.backgroundColor = primaryColor.cgColor
                
                self.blurView.alpha = 1
                self.blurView.blurRadius = 10
                self.view_pictures.addSubview(self.blurView)
                
            }
        }
        
        // update the new position acquired
        self.lastContentOffset = scrollView.contentOffset.y
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
