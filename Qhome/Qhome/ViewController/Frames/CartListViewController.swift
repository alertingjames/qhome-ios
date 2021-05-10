//
//  CartListViewController.swift
//  Qhome
//
//  Created by LGH419 on 7/19/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit
import Kingfisher

class CartListViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var cartList: UITableView!
    var carts = [Cart]()
    var gCell:CartItemCell!
    var cells = [CartItemCell]()
    var total:Float = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.cartList.delegate = self
        self.cartList.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getCarts()
        self.getWishlistProducts()
    }
    
    func getCarts(){
        self.carts.removeAll()
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
                    self.carts.append(item)
                    gCartItemsCount = gCartItemsCount + Int(item.quantity)
                }
                
                print("Cart Items: \(self.carts.count)")
                
                if self.carts.count == 0{
                    self.cartList.isHidden = true
                    gCartViewController.view_footer.isHidden = true
                    gCartViewController.lbl_cart.text = Language().cart
                    self.noResult()
                }else{
                    self.cartList.isHidden = false
                    gCartViewController.view_footer.isHidden = false
                    gCartViewController.lbl_cart.text = Language().cart + " (" + String(gCartItemsCount) + ")"
                    gCartViewController.noResultFrame.view.removeFromSuperview()
                }
                
                self.cartList.delegate = self
                self.cartList.dataSource = self
                
                self.refreshTotal()
                
                self.cartList.reloadData()
            }
        })
        
    }
    
    func noResult(){
        gCartViewController.noResultFrame.img_icon.image = UIImage(named: "ic_empty_cart")
        gCartViewController.noResultFrame.lbl_cap.text = Language().cart_empty
        gCartViewController.view_container.addSubview(gCartViewController!.noResultFrame.view)
    }
    
    func refreshTotal(){
        total = 0.0
        for item in gCartItems{
            total = total + item.price * Float(item.quantity)
        }
        gCartViewController.lbl_total.text = Language().total + ": " + String(Double(total).roundToDecimal(2)) + " QR"
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
        return carts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:CartItemCell = tableView.dequeueReusableCell(withIdentifier: "CartItemCell", for: indexPath) as! CartItemCell
        
        let index:Int = indexPath.row
        
        if carts[index].pictureUrl != ""{
            loadPicture(imageView: cell.picture, url: URL(string: carts[index].pictureUrl)!)
        }
        
        print("Cart Pic: \(carts[index].pictureUrl)")
        
        if lang == "ar" {
            cell.lbl_productname.text = carts[index].productARName
            cell.lbl_storename.text = carts[index].storeARName
            cell.lbl_price.text = "QR " + String(carts[index].price)
        }else{
            cell.lbl_productname.text = carts[index].productName
            cell.lbl_storename.text = carts[index].storeName
            cell.lbl_price.text = String(carts[index].price) + " QR"
        }
        
        cell.btn_quantityok.isHidden = true
        cell.lbl_quantity.layer.borderColor = UIColor.lightGray.cgColor
        cell.lbl_quantity.layer.borderWidth = 1.0
        cell.lbl_quantity.layer.cornerRadius = 3
        cell.lbl_quantity.text = String(carts[index].quantity)
        cell.btn_delete.tag = indexPath.row
        cell.btn_delete.addTarget(self, action: #selector(deleted), for: .touchUpInside)
        cell.btn_addwishlist.tag = indexPath.row
        cell.btn_addwishlist.addTarget(self, action: #selector(addWishlist), for: .touchUpInside)
        cell.btn_increase.tag = indexPath.row
        cell.btn_increase.addTarget(self, action: #selector(increase), for: .touchUpInside)
        cell.btn_decrease.tag = indexPath.row
        cell.btn_decrease.addTarget(self, action: #selector(decrease), for: .touchUpInside)
        cell.btn_quantityok.tag = indexPath.row
        cell.btn_quantityok.addTarget(self, action: #selector(quantityok), for: .touchUpInside)
        
        self.cells.append(cell)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 147.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.getProduct(product_id: self.carts[indexPath.row].productId, imei_id: gIMEI)
    }
    
    @objc func deleted(sender : UIButton){
        let cell:CartItemCell = cells[sender.tag]
        let cart = self.carts[sender.tag]
        
        APIs.delCartItem(item_id:cart.idx, handleCallback: {
            result_code in
            print(result_code)
            if result_code == "0"{
                let index = self.carts.firstIndex{$0 === cart}
                self.carts.remove(at: index!)
                gCartItems.remove(at: index!)
                self.refreshCart()
            }
            else{
                self.showToast(msg: Language().serverissue)
            }
        })
    }
    
    func refreshCart(){
        
        gCartItemsCount = 0
        for item in self.carts{
            gCartItemsCount = gCartItemsCount + Int(item.quantity)
        }
        
        if self.carts.count == 0{
            self.cartList.isHidden = true
            gCartViewController.view_footer.isHidden = true
            gCartViewController.lbl_cart.text = Language().cart
            self.noResult()
        }else{
            self.cartList.isHidden = false
            gCartViewController.view_footer.isHidden = false
            gCartViewController.lbl_cart.text = Language().cart + " (" + String(gCartItemsCount) + ")"
            gCartViewController.noResultFrame.view.removeFromSuperview()
        }
        
        self.refreshTotal()
        
        cartList.reloadData()
        
        self.getWishlistProducts()
    }
    
    @objc func addWishlist(sender : UIButton){
        let cell:CartItemCell = cells[sender.tag]
        let cart = self.carts[sender.tag]
        
        APIs.addCartToWishlist(item_id:cart.idx, imei_id: gIMEI, handleCallback: {
            result_code in
            print(result_code)
            if result_code == "0"{
                let index = self.carts.firstIndex{$0 === cart}
                self.carts.remove(at: index!)
                gCartItems.remove(at: index!)
                self.refreshCart()
            }
            else{
                self.showToast(msg: Language().serverissue)
            }
        })
    }
    
    @objc func increase(sender : UIButton){
        let cell:CartItemCell = cells[sender.tag]
        cell.lbl_quantity.text = String(Int(cell.lbl_quantity.text!)! + 1)
        cell.btn_quantityok.isHidden = false
    }
    
    @objc func decrease(sender : UIButton){
        let cell:CartItemCell = cells[sender.tag]
        if Int(cell.lbl_quantity.text!)! > 1{
            cell.lbl_quantity.text = String(Int(cell.lbl_quantity.text!)! - 1)
            cell.btn_quantityok.isHidden = false
        }
    }
    
    @objc func quantityok(sender : UIButton){
        let cell:CartItemCell = cells[sender.tag]
        let cart = self.carts[sender.tag]
        
        APIs.updateCartItemQuantity(item_id:cart.idx, quantity: Int(cell.lbl_quantity.text!)!, handleCallback: {
            result_code in
            print(result_code)
            if result_code == "0"{
                cell.btn_quantityok.isHidden = true
                cart.quantity = Int64(cell.lbl_quantity.text!)!
                gCartItemsCount = 0
                for item in self.carts{
                    if item.idx == cart.idx{
                        item.quantity = Int64(cell.lbl_quantity.text!)!
                    }
                    gCartItemsCount = gCartItemsCount + Int(item.quantity)
                }
                
                if self.carts.count > 0{
                    gCartViewController.view_footer.isHidden = false
                    gCartViewController.lbl_cart.text = Language().cart + " (" + String(gCartItemsCount) + ")"
                }
            }
            else{
                self.showToast(msg: Language().serverissue)
            }
        })
    }
    
    func getProduct(product_id:Int64, imei_id: String)
    {
        APIs.getProduct(product_id: product_id, imei_id: imei_id, handleCallback:{
            product, result_code in
            print(result_code)
            if result_code == "0"{
                gProduct = product!
                gProductOption = "cart"
                self.toDetail()
            }
        })
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
    
    func getWishlistProducts(){
        APIs.getSavedProducts(imei_id: gIMEI, handleCallback: {
            products, result_code in
            print(result_code)
            if result_code == "0"{
                var label = ""
                if products!.count == 0{
                    label = Language().wishlist
                }else{
                    label = Language().wishlist + " (" + String(products!.count) + ")"
                }
                
                gCartViewController.lbl_wishlist.attributedText = NSAttributedString(string: label, attributes: gCartViewController.unSelAttrs)
            }
        })
    }

}
