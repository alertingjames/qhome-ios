//
//  CheckoutViewController.swift
//  Qhome
//
//  Created by LGH419 on 7/22/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit
import Kingfisher

class CheckoutViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var view_nav: UIView!
    @IBOutlet weak var view_footer: UIView!
    @IBOutlet weak var lbl_subtotal: UILabel!
    @IBOutlet weak var lbl_shipping: UILabel!
    @IBOutlet weak var lbl_total: UILabel!
    @IBOutlet weak var btn_order: UIButton!
    @IBOutlet weak var lbl_addressline: UILabel!
    @IBOutlet weak var lbl_address: UILabel!
    @IBOutlet weak var lbl_phone: UILabel!
    @IBOutlet weak var view_address: UIView!
    @IBOutlet weak var view_phone: UIView!
    @IBOutlet weak var lbl_coupon: UILabel!
    @IBOutlet weak var view_bonus: UIView!
    @IBOutlet weak var OrderItemList: UICollectionView!
    
    var orderItems = [OrderItem]()
    
    var couponListFrame:CouponListViewController!
    var dark_background:DarkBackgroundViewController!
    
    var pDiscount = 0
    var subtotalPrice:Double = 0.0
    
    var companyF:Bool = false
    

    override func viewDidLoad() {
        super.viewDidLoad()

        gCheckoutViewController = self
        addShadowToBar(view: view_nav)
        setRoundShadowButton(button: btn_order, corner: 20)
        
        lbl_addressline.visibility = .gone
        
        gPhoneId = 0
        gAddressId = 0
        
        self.couponListFrame = self.storyboard!.instantiateViewController(withIdentifier: "CouponListViewController") as? CouponListViewController
        self.couponListFrame.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: self.couponListFrame.view.frame.size.height)
        
        self.dark_background = self.storyboard!.instantiateViewController(withIdentifier: "DarkBackgroundViewController") as? DarkBackgroundViewController
        self.dark_background.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        self.OrderItemList.delegate = self
        self.OrderItemList.dataSource = self
        
        var tap = UITapGestureRecognizer(target: self, action: #selector(self.selPhone(_:)))
        view_phone.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.selAddress(_:)))
        view_address.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.openCouponList(_:)))
        view_bonus.addGestureRecognizer(tap)
        
        self.getOrderItems()
    }
    
    @objc func selPhone(_ sender: UITapGestureRecognizer? = nil) {
        gAddrOption = "phone"
        let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "AddressViewController"))!
        conVC.modalPresentationStyle = .fullScreen
        transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
    }
    
    @objc func selAddress(_ sender: UITapGestureRecognizer? = nil) {
        gAddrOption = "address"
        let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "AddressViewController"))!
        conVC.modalPresentationStyle = .fullScreen
        transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getPhones()
        self.getAddresses()
    }
    
    @objc func openCouponList(_ sender: UITapGestureRecognizer? = nil) {
        if thisUser.idx > 0{
            UIView.animate(withDuration: 0.3){() -> Void in
                self.addChild(self.dark_background)
                self.view.addSubview(self.dark_background.view)
                self.couponListFrame.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                self.view.addSubview(self.couponListFrame.view)
                self.addChild(self.couponListFrame)
            }
        }else{
            let vc = AppDelegate.currentStoryboard.instantiateViewController(withIdentifier: "LoginViewController")
            transitionVc(vc: vc, duration: 0.3, type: .fromLeft)
        }
    }
    
    func closeCouponList(){
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            self.couponListFrame.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            self.dark_background.view.removeFromSuperview()
        }){
            (finished) in
            self.dark_background.view.removeFromSuperview()
            self.couponListFrame.view.removeFromSuperview()
        }
    }
    
    func applyCoupon(){
        var subtp = 0.0
        subtp = self.subtotalPrice - Double(self.subtotalPrice * Double(self.pDiscount / 100))
        if lang == "ar"{
            self.lbl_subtotal.text = "QR " + String(Double(subtp).roundToDecimal(2))
            self.lbl_shipping.text = "QR " + String(SHIPPING_PRICE.roundToDecimal(2))
            self.lbl_total.text = "QR " + String(Double(subtp + SHIPPING_PRICE).roundToDecimal(2))
        }else{
            self.lbl_subtotal.text = String(Double(subtp).roundToDecimal(2)) + " QR"
            self.lbl_shipping.text = "QR " + String(SHIPPING_PRICE.roundToDecimal(2)) + " QR"
            self.lbl_total.text = "QR " + String(Double(subtp + SHIPPING_PRICE).roundToDecimal(2)) + " QR"
        }
        
        if self.pDiscount > 0{
            self.lbl_coupon.text = Language().discount + ": -" + String(pDiscount) + "%"
        }else{
            self.lbl_coupon.text = Language().use_coupon
        }
        
        gTotalPrice = subtp + SHIPPING_PRICE
        
        self.closeCouponList()
    }
    
    func getOrderItems(){
        self.orderItems.removeAll()
        
        for index in (0...gCartItems.count - 1) {
            self.subtotalPrice = self.subtotalPrice + Double(gCartItems[index].price * Float(gCartItems[index].quantity))
            let item = OrderItem()
            item.pictureUrl = gCartItems[index].pictureUrl
            item.productName = gCartItems[index].productName
            item.productARName = gCartItems[index].productARName
            item.storeName = gCartItems[index].storeName
            item.storeARName = gCartItems[index].storeARName
            item.category = gCartItems[index].category
            item.arCategory = gCartItems[index].arCategory
            item.price = gCartItems[index].price
            item.quantity = gCartItems[index].quantity
            
            self.orderItems.append(item)
        }
        
        if orderItems.count == 0{
            self.OrderItemList.visibility = .gone
        }
        
        self.OrderItemList.reloadData()
        
        if lang == "ar"{
            self.lbl_subtotal.text = "QR" + " " + String(Double(self.subtotalPrice).roundToDecimal(2))
            self.lbl_shipping.text = "QR" + " " + String(Double(SHIPPING_PRICE).roundToDecimal(2))
            self.lbl_total.text = "QR" + " " + String(Double(self.subtotalPrice + SHIPPING_PRICE).roundToDecimal(2))
        }else{
            self.lbl_subtotal.text = String(Double(self.subtotalPrice).roundToDecimal(2)) + " QR"
            self.lbl_shipping.text = String(Double(SHIPPING_PRICE).roundToDecimal(2)) + " QR"
            self.lbl_total.text = String(Double(self.subtotalPrice + SHIPPING_PRICE).roundToDecimal(2)) + " QR"
        }
        
        gTotalPrice = self.subtotalPrice + SHIPPING_PRICE
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
    
    
    @IBAction func back(_ sender: Any) {
        dismissViewController()
    }
    
    @IBAction func order(_ sender: Any) {
        if (self.lbl_phone.text?.localizedLowercase.contains("Add"))!{
            self.showToast(msg: Language().enter_phone)
            return
        }
        if (self.lbl_address.text?.localizedLowercase.contains("Add"))!{
            self.showToast(msg: Language().enter_address)
            return
        }
        
        var email = ""
        if thisUser.idx > 0{
            email = thisUser.email
        }
        
        let orderItemsJsonStr = self.createOrderItemJsonString()
        
        var company = ""
        if companyF{
            company = "naql"
        }
        
        let parameters: [String:String] = [
            "member_id" : String(thisUser.idx),
            "imei_id" : gIMEI,
            "orderID" : self.randomString(length: 12).localizedUppercase,
            "price": String(Double(gTotalPrice).roundToDecimal(2)),
            "unit": "qr",
            "shipping": String(SHIPPING_PRICE),
            "email": email,
            "address" : self.lbl_address.text!,
            "address_line" : self.lbl_addressline.text!,
            "phone_number": self.lbl_phone.text!,
            "coupon_id":String(gCouponId),
            "discount": String(self.pDiscount),
            "company": company,
            "orderItems" : orderItemsJsonStr
        ]
        
        self.showLoadingView()
        APIs().postRequestWithURL(withUrl: ReqConst.SERVER_URL + "uploadOrder", withParam: parameters) { (isSuccess, response) in
            // Your Will Get Response here
            self.dismissLoadingView()
            if isSuccess == true{
                let result = response["result_code"] as Any
                print("Result: \(result)")
                if result as! String == "0"{
                    let orderID = response["orderID"] as! String
                    let orderDateTime = self.getDateFromTimeStamp(timeStamp: Double(response["date_time"] as! String)!/1000)
                    self.showToast(msg: Language().order_submited)
                    let conVC = AppDelegate.currentStoryboard.instantiateViewController(withIdentifier: "OrderPlacedViewController")
                    conVC.modalPresentationStyle = .fullScreen
                    gOrderID = orderID
                    gOrderDate = orderDateTime
                    self.transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
                }
            }
        }
    }
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    
    func getDateFromTimeStamp(timeStamp : Double) -> String {
        
        let date = NSDate(timeIntervalSince1970: timeStamp)
        
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "dd MMM YY, hh:mm a"
        // UnComment below to get only time
        //  dayTimePeriodFormatter.dateFormat = "hh:mm a"
        
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        return dateString
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:OrderItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderItemCell", for: indexPath) as! OrderItemCell
        let index:Int = indexPath.row
        cell.img_picture.layer.cornerRadius = 5
        self.loadPicture(imageView: cell.img_picture, url: URL(string: self.orderItems[index].pictureUrl)!)
        if lang == "ar"{
            cell.lbl_quantity.text = String(self.orderItems[index].quantity) + " X"
        }else{
            cell.lbl_quantity.text = "X " + String(self.orderItems[index].quantity)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        gOrderItems = self.orderItems
        let conVC = AppDelegate.currentStoryboard.instantiateViewController(withIdentifier: "ItemListViewController")
        conVC.modalPresentationStyle = .fullScreen
        transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
    }
    
    func getPhones(){
        self.showLoadingView()
        APIs.getPhones(member_id: thisUser.idx, imei_id: gIMEI, handleCallback: {
            phones, result_code in
            print(result_code)
            self.dismissLoadingView()
            if result_code == "0"{
                gPhones.removeAll()
                for phone in phones!{
                    gPhones.append(phone)
                }
                
                if gPhones.count > 0{
                    self.lbl_phone.text = (gPhones[Int(gPhoneId)]).phoneNumber
                }else{
                    if thisUser.idx > 0{
                        self.lbl_phone.text = thisUser.phone_number
                    }
                }
            }
        })
    }
    
    func getAddresses(){
        self.showLoadingView()
        APIs.getAddresses(member_id: thisUser.idx, imei_id: gIMEI, handleCallback: {
            addresses, result_code in
            print(result_code)
            self.dismissLoadingView()
            if result_code == "0"{
                gAddresses.removeAll()
                for address in addresses!{
                    gAddresses.append(address)
                }
                
                if thisUser.idx == 0{
                    if gAddresses.count > 0{
                        self.lbl_address.text = gAddresses[Int(gAddressId)].address
                        self.lbl_addressline.visibility = .visible
                        self.lbl_addressline.text = gAddresses[Int(gAddressId)].area + ", " + gAddresses[Int(gAddressId)].street + ", " + gAddresses[Int(gAddressId)].house
                    }
                }else if thisUser.idx > 0 && thisUser.address == ""{
                    if gAddresses.count > 0{
                        self.lbl_address.text = gAddresses[Int(gAddressId)].address
                        self.lbl_addressline.visibility = .visible
                        self.lbl_addressline.text = gAddresses[Int(gAddressId)].area + ", " + gAddresses[Int(gAddressId)].street + ", " + gAddresses[Int(gAddressId)].house
                    }
                }else{
                    if gAddresses.count > 0{
                        self.lbl_address.text = gAddresses[Int(gAddressId)].address
                        self.lbl_addressline.visibility = .visible
                        self.lbl_addressline.text = gAddresses[Int(gAddressId)].area + ", " + gAddresses[Int(gAddressId)].street + ", " + gAddresses[Int(gAddressId)].house
                    }else{
                        self.lbl_address.text = thisUser.address
                        self.lbl_addressline.visibility = .visible
                        self.lbl_addressline.text = thisUser.area + ", " + thisUser.street + ", " + thisUser.house
                    }
                }
            }
        })
    }
    
    func createOrderItemJsonString() -> String{
        var jsonArray = [Any]()
        for item in gCartItems{
            let jsonObject: [String: String] = [
                    "member_id": String(thisUser.idx),
                    "producer_id": String(item.productId),
                    "imei_id": gIMEI,
                    "store_id": String(item.storeId),
                    "store_name": item.storeName,
                    "ar_store_name":item.storeARName,
                    "product_id": String(item.productId),
                    "product_name":item.productName,
                    "ar_product_name": item.productARName,
                    "category": item.category,
                    "ar_category": item.arCategory,
                    "price": String(Double(item.price).roundToDecimal(2)),
                    "unit": item.unit,
                    "quantity": String(item.quantity),
                    "picture_url": item.pictureUrl,
                    "comprice_id": String(item.priceId)
            ]
            
            if item.priceId > 0{
                self.companyF = true
            }
            
            jsonArray.append(jsonObject)
        }
        
        let jsonItemsObj:[String: Any] = [
            "orderItems":jsonArray
        ]
        
        let jsonStr = self.stringify(json: jsonItemsObj)
        return jsonStr
        
    }
    
    func stringify(json: Any, prettyPrinted: Bool = false) -> String {
        var options: JSONSerialization.WritingOptions = []
        if prettyPrinted {
            options = JSONSerialization.WritingOptions.prettyPrinted
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: options)
            if let string = String(data: data, encoding: String.Encoding.utf8) {
                return string
            }
        } catch {
            print(error)
        }
        return ""
    }

}
