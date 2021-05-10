//
//  WishlistViewController.swift
//  Qhome
//
//  Created by LGH419 on 7/21/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit
import Kingfisher
import SCLAlertView

class WishlistViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var view_nav: UIView!
    @IBOutlet weak var view_cart: UIView!
    @IBOutlet weak var view_count: UIView!
    @IBOutlet weak var lbl_count: UILabel!
    @IBOutlet weak var productList: UITableView!
    
    var products = [Product]()    

    override func viewDidLoad() {
        super.viewDidLoad()

        addShadowToBar(view: view_nav)
        
        productList.delegate = self
        productList.dataSource = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tappedCart(_:)))
        self.view_cart.addGestureRecognizer(tap)
        
        productList.estimatedRowHeight = 240.0
        productList.rowHeight = UITableView.automaticDimension
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getProducts()
        self.getCarts()
    }
    
    @objc func tappedCart(_ sender:UITapGestureRecognizer? = nil){
        let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "CartViewController"))!
        conVC.modalPresentationStyle = .fullScreen
        transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
    }
    
    func getProducts(){
        
        self.products.removeAll()
        
        APIs.getSavedProducts(imei_id: gIMEI, handleCallback: {
            products, result_code in
            print(result_code)
            self.dismissLoadingView()
            if result_code == "0"{
                for product in products!{
                    self.products.append(product)
                }
                
                print("Wishlist Items: \(self.products.count)")
                
                if products!.count == 0{
                    self.productList.isHidden = true
                    self.showToast(msg: Language().noresult)
                }else{
                    self.productList.isHidden = false
                }
                
                self.productList.reloadData()
                
            }
        })
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if products.count % 2 == 0{
            return products.count/2
        }else{
            return products.count/2 + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:WishlistItemUITableViewCell = tableView.dequeueReusableCell(withIdentifier: "WishlistItemUITableViewCell", for: indexPath) as! WishlistItemUITableViewCell
        
        let index:Int = indexPath.row * 2
        
        if let _ = products[exist: index]{
            if products[index].pictureUrl != ""{
                loadPicture(imageView: cell.img_logo1, url: URL(string: products[index].pictureUrl)!)
            }
            
            if lang == "ar" {
                cell.lbl_price1.text = "QR " + String(products[index].price)
            }else{
                cell.lbl_price1.text = String(products[index].price) + " QR"
            }
            
            cell.btn_delete1.tag = index
            cell.btn_delete1.addTarget(self, action: #selector(deleted), for: .touchUpInside)
            
            cell.view_item1.isHidden = false
            cell.view_item1.tag = index
            let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.tappedItem1(_:)))
            cell.view_item1.addGestureRecognizer(tap1)
            
        }else{
            cell.view_item1.isHidden = true
        }
        
        let index2:Int = indexPath.row * 2 + 1
        
        if let _ = products[exist: index2]{
            if products[index2].pictureUrl != ""{
                loadPicture(imageView: cell.img_logo2, url: URL(string: products[index2].pictureUrl)!)
            }
            
            if lang == "ar" {
                cell.lbl_price2.text = "QR " + String(products[index2].price)
            }else{
                cell.lbl_price2.text = String(products[index2].price) + " QR"
            }
            
            cell.btn_delete2.tag = index2
            cell.btn_delete2.addTarget(self, action: #selector(deleted), for: .touchUpInside)
            
            cell.view_item2.isHidden = false
            cell.view_item2.tag = index2
            let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.tappedItem2(_:)))
            cell.view_item2.addGestureRecognizer(tap2)
            
        }else{
            cell.view_item2.isHidden = true
        }
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 240.0
//    }
    
    @objc func deleted(sender : UIButton){
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: true
        )
        let alert = SCLAlertView(appearance: appearance)
        alert.addButton(Language().yes) {
            let product = self.products[sender.tag]
            
            APIs.unsaveProduct(product_id:product.idx, imei_id: gIMEI, handleCallback: {
                result_code in
                print(result_code)
                if result_code == "0"{
                    let index = self.products.firstIndex{$0 === product}
                    self.products.remove(at: index!)
                    
                    if self.products.count == 0{
                        self.showToast(msg: Language().noresult)
                    }
                    
                    self.productList.reloadData()
                }
                else{
                    self.showToast(msg: Language().serverissue)
                }
            })
            
        }
        alert.showWarning(Language().warning, subTitle: Language().suredelete)
        
    }
    
    @objc func tappedItem1(_ sender: UITapGestureRecognizer? = nil) {
        if let tag = sender?.view?.tag {
            print(tag)
            gProduct = self.products[tag]
            if thisUser.idx > 0{
                if gStore.userId != thisUser.idx{
                    
                }else{
                    
                }
            }else{
                
            }
            
            self.toDetail()
        }
    }
    
    @objc func tappedItem2(_ sender: UITapGestureRecognizer? = nil) {
        if let tag = sender?.view?.tag {
            print(tag)
            gProduct = self.products[tag]
            if thisUser.idx > 0{
                if gStore.userId != thisUser.idx{
                    
                }else{
                    
                }
            }else{
                
            }
            
            toDetail()
        }
    }
    
    func toDetail(){
        let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "PDetailViewController"))!
        conVC.modalPresentationStyle = .fullScreen
        transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
        
    }

    @IBAction func back(_ sender: Any) {
        dismissViewController()
    }
    
    func getCarts(){
        gCartItems.removeAll()
        gCartItemsCount = 0
        self.showLoadingView()
        APIs.getCarts(imei_id: gIMEI, handleCallback: {
            cartItems, result_code in
            print(result_code)
            self.dismissLoadingView()
            if result_code == "0"{
                for item in cartItems!{
                    gCartItems.append(item)
                    gCartItemsCount = gCartItemsCount + Int(item.quantity)
                }
                
                if gCartItemsCount == 0{
                    self.view_count.isHidden = true
                }else{
                    self.view_count.isHidden = false
                    self.lbl_count.text = String(gCartItemsCount)
                }
            }
        })
        
    }
    
}
