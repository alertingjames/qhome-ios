//
//  WishlistListViewController.swift
//  Qhome
//
//  Created by LGH419 on 7/19/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit
import Kingfisher

class WishlistListViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var wishList: UITableView!
    var products = [Product]()
    var gCell:WishlistItemCell!
    var cells = [WishlistItemCell]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.wishList.delegate = self
        self.wishList.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getWishlistProducts()
    }
    
    func getWishlistProducts(){
        self.products.removeAll()
        self.showLoadingView()
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
                    gCartViewController.lbl_wishlist.text = Language().wishlist
                    self.wishList.isHidden = true
                    self.noResult()
                }else{
                    gCartViewController.lbl_wishlist.text = Language().wishlist + " (" + String(products!.count) + ")"
                    self.wishList.isHidden = false
                    gCartViewController.noResultFrame.view.removeFromSuperview()
                }
                
                self.wishList.delegate = self
                self.wishList.dataSource = self
                
                self.wishList.reloadData()
                
                self.getCarts()
            }
        })
    }
    
    func noResult(){
        gCartViewController.noResultFrame.img_icon.image = UIImage(named: "ic_empty_wishlist")
        gCartViewController.noResultFrame.lbl_cap.text = Language().wishlist_empty
        gCartViewController.view_container.addSubview(gCartViewController!.noResultFrame.view)
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
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:WishlistItemCell = tableView.dequeueReusableCell(withIdentifier: "WishlistItemCell", for: indexPath) as! WishlistItemCell
        
        let index:Int = indexPath.row
        
        if products[index].pictureUrl != ""{
            loadPicture(imageView: cell.picture, url: URL(string: products[index].pictureUrl)!)
        }
        
        if lang == "ar" {
            cell.lbl_productname.text = products[index].arName
            cell.lbl_storename.text = products[index].storeARName
            cell.lbl_price.text = "QR " + String(products[index].price)
        }else{
            cell.lbl_productname.text = products[index].name
            cell.lbl_storename.text = products[index].storeName
            cell.lbl_price.text = String(products[index].price) + " QR"
        }
        
        cell.btn_delete.tag = indexPath.row
        cell.btn_delete.addTarget(self, action: #selector(deleted), for: .touchUpInside)
        cell.btn_addcart.tag = indexPath.row
        cell.btn_addcart.addTarget(self, action: #selector(addCart), for: .touchUpInside)
        
        self.cells.append(cell)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        gProduct = products[indexPath.row]
        self.toDetail()
    }
    
    func toDetail(){
        print("Go To Product Detail!!!")
        var pDetailFrame:PDetailViewController = (self.storyboard!.instantiateViewController(withIdentifier: "PDetailViewController") as? PDetailViewController)!
        pDetailFrame.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: pDetailFrame.view.frame.size.height)
        
        UIView.animate(withDuration: 0.3){() -> Void in
            gCartViewController!.view.addSubview(pDetailFrame.view)
            gCartViewController!.addChild(pDetailFrame)
        }
        
    }
    
    @objc func deleted(sender : UIButton){
        let cell:WishlistItemCell = cells[sender.tag]
        let product = self.products[sender.tag]
        APIs.unsaveProduct(product_id:product.idx, imei_id: gIMEI, handleCallback: {
            result_code in
            print(result_code)
            if result_code == "0"{
                let index = self.products.firstIndex{$0 === product}
                self.products.remove(at: index!)
                if self.products.count == 0{
                    gCartViewController.lbl_wishlist.text = Language().wishlist
                    self.noResult()
                }else{
                    gCartViewController.lbl_wishlist.text = Language().wishlist + " (" + String(self.products.count) + ")"
                    gCartViewController.noResultFrame.view.removeFromSuperview()
                }
                
                self.wishList.reloadData()
            }
            else{
                self.showToast(msg: Language().serverissue)
            }
        })
    }
    
    var selectedProduct:Product!
    
    @objc func addCart(sender : UIButton){
        let cell:WishlistItemCell = cells[sender.tag]
        let product = self.products[sender.tag]
        self.selectedProduct = product
        
        let count = 1
        
        self.addToCart(pictureUrl: product.pictureUrl, imei_id: gIMEI, producerId: product.userId, storeId: product.storeId, storeName: product.storeName, storeARName: product.storeARName, productId: product.idx, productName: product.name, productARName: product.arName, category: product.category, arCategory: product.arCategory, price: product.price, unit: "qr", quantity: count, compriceId: 0)
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
        showLoadingView()
        APIs.addWishlistToCart(picture_url:pictureUrl, imei_id:imei_id, producer_id: producerId, store_id: storeId, store_name: storeName, store_ar_name: storeARName, product_id: productId, product_name:productName, product_ar_name: productARName, category: category, ar_category: arCategory,
                               price: price, unit: unit, quantity: quantity, compriceId: compriceId, handleCallback:{
                                result_code in
                                self.dismissLoadingView()
                                print(result_code)
                                if result_code == "0"{
                                    let index = self.products.firstIndex{$0 === self.selectedProduct}
                                    self.products.remove(at: index!)
                                    if self.products.count == 0{
                                        gCartViewController.lbl_wishlist.text = Language().wishlist
                                        self.noResult()
                                    }else{
                                        gCartViewController.lbl_wishlist.text = Language().wishlist + " (" + String(self.products.count) + ")"
                                        gCartViewController.noResultFrame.view.removeFromSuperview()
                                    }
                                    
                                    if self.products.count == 0{
                                        
                                    }
                                    
                                    self.wishList.reloadData()
                                    self.getCarts()
                                }
        })
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
                
                var label = ""
                if gCartItemsCount == 0{
                    label = Language().cart
                }else{
                    label = Language().cart + " (" + String(gCartItemsCount) + ")"
                }
                
                if gCartViewController != nil{
                    gCartViewController.lbl_cart.attributedText = NSAttributedString(string: label, attributes: gCartViewController.unSelAttrs)
                }
            }
        })
        
    }

}
