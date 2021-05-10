//
//  StoreProductsViewController.swift
//  Qhome
//
//  Created by LGH419 on 7/17/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit
import Kingfisher
import SCLAlertView

class StoreProductsViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var edt_search: UITextField!
    @IBOutlet weak var productList: UITableView!
    
    @IBOutlet weak var view_header: UIView!
    @IBOutlet weak var view_searchbar: UIView!
    @IBOutlet weak var btn_category: UIButton!
    
    
    var products = [Product]()
    var searchProducts = [Product]()
    
    var saveButton:UIButton!
    var productId:Int64!
    
    var productDetailFrame:ProductDetailViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if gMyStoreDetailViewController != nil{
            if lang == "ar"{
                gMyStoreDetailViewController!.lbl_title.text = gStore.arName
            }else{
                gMyStoreDetailViewController!.lbl_title.text = gStore.name
            }
        }
        
        productDetailFrame = (self.storyboard!.instantiateViewController(withIdentifier: "ProductDetailViewController") as? ProductDetailViewController)!
        productDetailFrame.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: productDetailFrame.view.frame.size.height)
        
        edt_search.attributedPlaceholder = NSAttributedString(string: Language().search,
            attributes: [NSAttributedString.Key.foregroundColor: primaryColor])
        view_searchbar.layer.cornerRadius = 18

        productList.delegate = self
        productList.dataSource = self
        
        productList.estimatedRowHeight = 220.0
        productList.rowHeight = UITableView.automaticDimension
        
        edt_search.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                             for: UIControl.Event.editingChanged)
        
        if lang == "ar"{
            if gStore.arCategory2 == ""{
                self.btn_category.visibilityh = .gone
            }
        }else{
            if gStore.category2 == ""{
                self.btn_category.visibilityh = .gone
            }
        }
        
//        self.getProducts()
        
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
                self.getProductsByCategory(category: gStore.arCategory)
            })
            if gStore.arCategory2 != ""{
                alert.addButton(gStore.arCategory2, backgroundColor: UIColor.blue, textColor: .white, showTimeout: nil, action: {
                    self.getProductsByCategory(category: gStore.arCategory2)
                })
            }
        }else{
            alert.addButton(gStore.category, backgroundColor: UIColor.blue, textColor: .white, showTimeout: nil, action: {
                self.getProductsByCategory(category: gStore.category)
            })
            if gStore.category2 != ""{
                alert.addButton(gStore.category2, backgroundColor: UIColor.blue, textColor: .white, showTimeout: nil, action: {
                    self.getProductsByCategory(category: gStore.category2)
                })
            }
        }
        
        alert.showWarning(Language().choose_category, subTitle: Language().thisstoreincludes2categories)
        
    }
    
    func getProductsByCategory(category:String){
        var prods = [Product]()
        for prod in self.products{
            if prod.category == category || prod.arCategory == category{
                prods.append(prod)
            }
        }
        if prods.count == 0{
            productList.isHidden = true
        }else{
            productList.isHidden = false
            self.products.removeAll()
            for prod in prods{
                self.products.append(prod)
            }
            self.productList.reloadData()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getProducts()
    }
    
    
    func getProducts(){
        
        self.products.removeAll()
        self.searchProducts.removeAll()
        
        self.showLoadingView()
        APIs.getStoreProducts(imei_id: gIMEI, handleCallback: {
            products, result_code in
            self.dismissLoadingView()
            print(result_code)
            if result_code == "0"{
                for prod in products!{
                    if prod.storeId == gStore.idx{
                        if prod.newPrice == 0{
                            if Int64(prod.price) >= gMinPrice && Int64(prod.price) <= gMaxPrice{
                                self.products.append(prod)
                                self.searchProducts.append(prod)
                            }
                        }else{
                            if Int64(prod.newPrice) >= gMinPrice && Int64(prod.newPrice) <= gMaxPrice{
                                self.products.append(prod)
                                self.searchProducts.append(prod)
                            }
                        }
                    }
                }
                
                var nSort:Bool!
                var pSort:Bool!
                
                if gNameSort == 1{
                    nSort = true
                }else if gNameSort == 2{
                    nSort = false
                }
                
                if gPriceSort == 1{
                    pSort = true
                }else if gPriceSort == 2{
                    pSort = false
                }
                
                var descriptorArray:[NSSortDescriptor] = []
                
                if gNameSort != 0{
                    let productNameSortDescriptor = NSSortDescriptor(key: "name", ascending: nSort)
                    descriptorArray.append(productNameSortDescriptor)
                }
                
                if gPriceSort != 0{
                    let productPriceSortDescriptor = NSSortDescriptor(key: "price", ascending: pSort)
                    descriptorArray.append(productPriceSortDescriptor)
                }
                
                if gPriceSort != 0 || gNameSort != 0 {
                    (self.products as NSArray).sortedArray(using: descriptorArray)
                }
                
                if self.products.count == 0{
                    self.productList.isHidden = true
                    self.showToast(msg: Language().noresult)
                }else{
                    self.productList.isHidden = false
                }
                
                self.productList.reloadData()
            }
            else{
                
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
        
        let cell:ProductItemCell = tableView.dequeueReusableCell(withIdentifier: "ProductItemCell", for: indexPath) as! ProductItemCell
        
        let index:Int = indexPath.row * 2
        
        if let _ = products[exist: index]{
            if products[index].pictureUrl != ""{
                loadPicture(imageView: cell.img_picture1, url: URL(string: products[index].pictureUrl)!)
            }
            
            if lang == "ar" {
                cell.lbl_price1.text = "QR " + String(products[index].price)
            }else{
                cell.lbl_price1.text = String(products[index].price) + " QR"
            }
            
            if products[index].isLiked{
                cell.btn_like1.setImage(liked, for: .normal)
            }else{
                cell.btn_like1.setImage(like, for: .normal)
            }
            
            if products[index].userId == thisUser.idx{
                cell.btn_del1.isHidden = false
            }else{
                cell.btn_del1.isHidden = true
            }
            
            if thisUser.idx > 0{
                if thisUser.idx == self.products[index].userId{
                    cell.btn_like1.isHidden = true
                }
            }else{
                cell.btn_like1.isHidden = false
            }
            
            cell.btn_like1.tag = index
            cell.btn_like1.addTarget(self, action: #selector(saveUnsaveProduct), for: .touchUpInside)
            
            cell.btn_del1.tag = index
            cell.btn_del1.addTarget(self, action: #selector(delProduct), for: .touchUpInside)
            
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
                loadPicture(imageView: cell.img_picture2, url: URL(string: products[index2].pictureUrl)!)
            }
            
            if lang == "ar" {
                cell.lbl_price2.text = "QR " + String(products[index2].price)
            }else{
                cell.lbl_price2.text = String(products[index2].price) + " QR"
            }
            
            if products[index2].isLiked{
                cell.btn_like2.setImage(liked, for: .normal)
            }else{
                cell.btn_like2.setImage(like, for: .normal)
            }
            
            if products[index2].userId == thisUser.idx{
                cell.btn_del2.isHidden = false
            }else{
                cell.btn_del2.isHidden = true
            }
            
            if thisUser.idx > 0{
                if thisUser.idx == self.products[index2].userId{
                    cell.btn_like2.isHidden = true
                }
            }else{
                cell.btn_like2.isHidden = false
            }
            
            cell.btn_like2.tag = index2
            cell.btn_like2.addTarget(self, action: #selector(saveUnsaveProduct), for: .touchUpInside)
            
            cell.btn_del2.tag = index2
            cell.btn_del2.addTarget(self, action: #selector(delProduct), for: .touchUpInside)
            
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
//        return 220.0
//    }
    
    
    @objc func saveUnsaveProduct(sender : UIButton){
        let product = self.products[sender.tag]
        saveButton = sender
        productId = product.idx
        if product.isLiked{
            self.unSaveProduct(product_id: product.idx)
        }else{
            self.saveProduct(product_id: product.idx)
        }
    }
    
    @objc func delProduct(sender : UIButton){
        let product = self.products[sender.tag]
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: true
        )
        let alert = SCLAlertView(appearance: appearance)
        alert.addButton(Language().yes) {
            self.showLoadingView()
            APIs.deleteProduct(product_id:product.idx, handleCallback: {
                result_code in
                print(result_code)
                self.dismissLoadingView()
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
    
    
    func saveProduct(product_id:Int64){
        APIs.saveProduct(product_id:product_id, imei_id: gIMEI, handleCallback: {
            result_code in
            print(result_code)
            if result_code == "0"{
                if self.saveButton != nil{
                    self.saveButton.setImage(UIImage(named: "ic_liked"), for: .normal)
                    for i in 0...self.products.count - 1{
                        let product = self.products[i]
                        if product.idx == self.productId{
                            product.isLiked = true
                            self.searchProducts[i].isLiked = true  // searched products
                        }
                    }
                }
            }
            else{
                self.showToast(msg: Language().serverissue)
            }
        })
    }
    
    func unSaveProduct(product_id:Int64){
        APIs.unsaveProduct(product_id:product_id, imei_id: gIMEI, handleCallback: {
            result_code in
            print(result_code)
            if result_code == "0"{
                if self.saveButton != nil{
                    self.saveButton.setImage(UIImage(named: "ic_like"), for: .normal)
                    for i in 0...self.products.count - 1{
                        let product = self.products[i]
                        if product.idx == self.productId{
                            product.isLiked = false
                            self.searchProducts[i].isLiked = false  // searched products
                        }
                    }
                }
            }
            else{
                self.showToast(msg: Language().serverissue)
            }
        })
    }
    
    @objc func tappedItem1(_ sender: UITapGestureRecognizer? = nil) {
        if self.loadingView.isAnimating{
            return
        }
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
        if self.loadingView.isAnimating{
            return
        }
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
        print("Go To Product Detail!!!")
        productDetailFrame = (self.storyboard!.instantiateViewController(withIdentifier: "ProductDetailViewController") as? ProductDetailViewController)!
        productDetailFrame.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: productDetailFrame.view.frame.size.height)
        productDetailFrame.getCart(imei: gIMEI)
        
        UIView.animate(withDuration: 0.3){() -> Void in
            if gMyStoreDetailViewController != nil{
                gMyStoreDetailViewController!.view.addSubview(self.productDetailFrame.view)
                gMyStoreDetailViewController!.addChild(self.productDetailFrame)
            }else if gStoreDetailViewController != nil{
                gComPriceId = gStoreDetailViewController!.companyPriceId
                gStoreDetailViewController!.view.addSubview(self.productDetailFrame.view)
                gStoreDetailViewController!.addChild(self.productDetailFrame)
            }
        }
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text == ""{
            self.getProducts()
        }else{
            products = filter(keyword: (textField.text?.lowercased())!)
            if products.isEmpty{
                self.showToast(msg: Language().noresult)
            }
            self.productList.reloadData()
        }
    }
    
    func filter(keyword:String) -> [Product]{
        if keyword == ""{
            return searchProducts
        }
        var filteredProducts = [Product]()
        for product in searchProducts{
            if product.name.lowercased().contains(keyword){
                filteredProducts.append(product)
            }else{
                if product.category.lowercased().contains(keyword){
                    filteredProducts.append(product)
                }else{
                    if product.description.lowercased().contains(keyword){
                        filteredProducts.append(product)
                    }else{
                        if product.arName.contains(keyword){
                            filteredProducts.append(product)
                        }else{
                            if product.arCategory.contains(keyword){
                                filteredProducts.append(product)
                            }else{
                                if product.arDescription.contains(keyword){
                                    filteredProducts.append(product)
                                }else{
                                    if String(product.price).contains(keyword){
                                        filteredProducts.append(product)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return filteredProducts
    }

}
