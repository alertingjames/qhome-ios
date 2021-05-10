//
//  APIs.swift
//  Qhome
//
//  Created by LGH419 on 7/7/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class APIs {
    
    static func login(email : String, password: String, role:String, handleCallback: @escaping (User?, String) -> ())
    {
        //NSLog(url)
        
        let params = [
            "email":email,
            "password":password,
            "role":role
        ] as [String : Any]
        
        Alamofire.request(ReqConst.SERVER_URL + "login", method: .post, parameters: params).responseJSON { response in
            
            if response.result.isFailure{
                handleCallback(nil, "Server issue")
            }
            else
            {
                let json = JSON(response.result.value!)
                NSLog("\(json)")
                if(json["result_code"].stringValue == "0"){
                    
                    let data = json["data"].object as! [String: Any]
                    let user = User()
                    user.idx = data["id"] as! Int64
                    user.name = data["name"] as! String
                    user.email = data["email"] as! String
                    user.password = data["password"] as! String
                    user.area = data["area"] as! String
                    user.address = data["address"] as! String
                    user.phone_number = data["phone_number"] as! String
                    user.street = data["street"] as! String
                    user.auth_status = data["auth_status"] as! String
                    user.registered_time = data["registered_time"] as! String
                    user.house = data["house"] as! String
                    user.instagram = data["instagram"] as! String
                    user.role = data["role"] as! String
                    user.status = data["status"] as! String
                    user.stores = Int(data["stores"] as! String)!
                    user.token = data["token"] as! String
                    
                    handleCallback(user, "0")
                }
                else if(json["result_code"].stringValue == "1"){
                    handleCallback(nil, "1")
                }else if(json["result_code"].stringValue == "2"){
                    handleCallback(nil, "2")
                }else{
                    handleCallback(nil, "Server issue")
                }
                
            }
        }
    }
    
    static func register(name:String, imei:String, email : String, password: String, phone_number: String, instagram: String, address: String, area: String, street: String, house: String, role: String, handleCallback: @escaping (User?, String) -> ())
    {
        //NSLog(url)
        
        let params = [
            "name":name,
            "imei_id":imei,
            "email":email,
            "password":password,
            "phone_number":phone_number,
            "instagram":instagram,
            "address":address,
            "area":area,
            "street":street,
            "house":house,
            "role":role
        ] as [String : Any]
        
        Alamofire.request(ReqConst.SERVER_URL + "registerMember", method: .post, parameters: params).responseJSON { response in
            
            if response.result.isFailure{
                handleCallback(nil, "Server issue")
            }
            else
            {
                let json = JSON(response.result.value!)
                NSLog("Registration Result!!!\(json)")
                if(json["result_code"].stringValue == "0"){
                    
                    let data = json["data"].object as! [String: Any]
                    let user = User()
                    user.idx = data["id"] as! Int64
                    user.name = data["name"] as! String
                    user.email = data["email"] as! String
                    user.password = data["password"] as! String
                    user.area = data["area"] as! String
                    user.address = data["address"] as! String
                    user.phone_number = data["phone_number"] as! String
                    user.street = data["street"] as! String
                    user.auth_status = data["auth_status"] as! String
                    user.registered_time = data["registered_time"] as! String
                    user.house = data["house"] as! String
                    user.instagram = data["instagram"] as! String
                    user.role = data["role"] as! String
                    user.status = data["status"] as! String
                    user.stores = Int(data["stores"] as! String)!
                    user.token = data["token"] as! String
                    
                    handleCallback(user, "0")
                }
                else if(json["result_code"].stringValue == "1"){
                    handleCallback(nil, "1")
                }else if(json["result_code"].stringValue == "2"){
                    handleCallback(nil, "2")
                }else{
                    handleCallback(nil, "Server issue")
                }
                
            }
        }
    }
    
    static func registerGuest(imei_id:String, handleCallback: @escaping () -> ())
    {
        //NSLog(url)
        
        let params = [
            "imei_id":imei_id
        ] as [String : Any]
        
        Alamofire.request(ReqConst.SERVER_URL + "regGuest", method: .post, parameters: params).responseJSON { response in
            
        }
    }
    
    static func getStores(member_id:Int64, handleCallback: @escaping ([Store]?, String) -> ())
    {
        //NSLog(url)
        
        let params = [
            "member_id":String(member_id),
        ] as [String : Any]
        
        Alamofire.request(ReqConst.SERVER_URL + "getStores", method: .post, parameters: params).responseJSON { response in
            
            if response.result.isFailure{
                handleCallback(nil, "Server issue")
            }
            else
            {
                let json = JSON(response.result.value!)
                NSLog("Stores: \(json)")
                if(json["result_code"].stringValue == "0"){
                    var stores = [Store]()
                    let dataArray = json["data"].arrayObject as! [[String: Any]]
                    
                    for data in dataArray{
                        let store = Store()
                        store.idx = data["id"] as! Int64
                        store.userId = Int64(data["member_id"] as! String)!
                        store.name = data["name"] as! String
                        store.logoUrl = data["logo_url"] as! String
                        store.arName = data["ar_name"] as! String
                        store.category = data["category"] as! String
                        store.arCategory = data["ar_category"] as! String
                        store.category2 = data["category2"] as! String
                        store.arCategory2 = data["ar_category2"] as! String
                        store.description = data["description"] as! String
                        store.arDescription = data["ar_description"] as! String
                        store.ratings = Float(data["ratings"] as! String)!
                        store.reviews = Int64(data["reviews"] as! String)!
                        store.registered_time = data["registered_time"] as! String
                        store.status = data["status"] as! String
                        store.likes = Int64(data["likes"] as! String)!
                        if data["isLiked"] as! String == "yes"{
                            store.isLiked = true
                        }else if data["isLiked"] as! String == "no"{
                            store.isLiked = false
                        }else if data["isLiked"] as! String == ""{
                            store.isLiked = false
                        }
                        
                        var priceIdStr = "0"
                        if data["price_id"] as! String != ""{
                            priceIdStr = (data["price_id"] as! String?)!
                        }
                        
                        store.priceId = Int64(priceIdStr)!
                        
                        stores.append(store)
                    }
                    
                    handleCallback(stores, "0")
                }
            }
        }
    }
    
    static func likeStore(store_id : Int64, member_id: Int64, handleCallback: @escaping (String) -> ())
    {
        //NSLog(url)
        
        let params = [
            "store_id":String(store_id),
            "member_id":String(member_id),
        ] as [String : Any]
        
        Alamofire.request(ReqConst.SERVER_URL + "likeStore", method: .post, parameters: params).responseJSON { response in
            
            if response.result.isFailure{
                handleCallback("Server issue")
            }
            else
            {
                let json = JSON(response.result.value!)
                NSLog("\(json)")
                if(json["result_code"].stringValue == "0"){
                    handleCallback("0")
                }
                else{
                    handleCallback("Server issue")
                }
                
            }
        }
    }
    
    static func unLikeStore(store_id : Int64, member_id: Int64, handleCallback: @escaping (String) -> ())
    {
        //NSLog(url)
        
        let params = [
            "store_id":String(store_id),
            "member_id":String(member_id),
        ] as [String : Any]
        
        Alamofire.request(ReqConst.SERVER_URL + "unLikeStore", method: .post, parameters: params).responseJSON { response in
            
            if response.result.isFailure{
                handleCallback("Server issue")
            }
            else
            {
                let json = JSON(response.result.value!)
                NSLog("\(json)")
                if(json["result_code"].stringValue == "0"){
                    handleCallback("0")
                }
                else{
                    handleCallback("Server issue")
                }
                
            }
        }
    }
    
    static func getCarts(imei_id : String, handleCallback: @escaping ([Cart]?, String) -> ())
    {
        //NSLog(url)
        
        let params = [
            "imei_id":imei_id
        ] as [String : Any]
        
        Alamofire.request(ReqConst.SERVER_URL + "getCartItems", method: .post, parameters: params).responseJSON { response in
            
            if response.result.isFailure{
                handleCallback(nil, "Server issue")
            }
            else
            {
                let json = JSON(response.result.value!)
                NSLog("\(json)")
                if(json["result_code"].stringValue == "0"){
                    var carts = [Cart]()
                    let dataArray = json["data"].arrayObject as! [[String: Any]]
                    
                    for data in dataArray{
                        let cart = Cart()
                        cart.idx = data["id"] as! Int64
                        cart.imei = data["imei_id"] as! String
                        cart.producerId = Int64(data["producer_id"] as! String)!
                        cart.storeId = Int64(data["store_id"] as! String)!
                        cart.storeName = data["store_name"] as! String
                        cart.storeARName = data["ar_store_name"] as! String
                        cart.pictureUrl = data["picture_url"] as! String
                        cart.category = data["category"] as! String
                        cart.arCategory = data["ar_category"] as! String
                        cart.productId = Int64(data["product_id"] as! String)!
                        cart.productName = data["product_name"] as! String
                        cart.productARName = data["ar_product_name"] as! String
                        cart.price = Float(data["price"] as! String)!
                        cart.unit = data["unit"] as! String
                        cart.quantity = Int64(data["quantity"] as! String)!
                        var priceId = "0"
                        if data["price_id"] as! String != ""{
                            priceId = (data["price_id"] as! String?)!
                        }
                        cart.priceId = Int64(priceId)!
                        
                        carts.append(cart)
                    }
                    
                    handleCallback(carts, "0")
                    
                }
                else{
                    handleCallback(nil, "Server issue")
                }
                
            }
        }
    }
    
    static func getAds(handleCallback: @escaping (String, String, String, String, String, String, String) -> ())
    {
        //NSLog(url)
        
        let params = [
            :
        ] as [String : Any]
        
        Alamofire.request(ReqConst.SERVER_URL + "getAds", method: .post, parameters: params).responseJSON { response in
            
            if response.result.isFailure{
                handleCallback("", "", "", "", "", "", "Server issue")
            }
            else
            {
                let json = JSON(response.result.value!)
                NSLog("\(json)")
                if(json["result_code"].stringValue == "0"){
                    let data = json["data"].object as! [String: Any]
                    let adPic1 = data["adPic1"] as! String
                    let adPic2 = data["adPic2"] as! String
                    let adPic3 = data["adPic3"] as! String
                    let adStore1 = data["adStore1"] as! String
                    let adStore2 = data["adStore2"] as! String
                    let adStore3 = data["adStore3"] as! String
                    
                    handleCallback(adPic1, adPic2, adPic3, adStore1, adStore2, adStore3, "0")
                }
                else{
                    handleCallback("", "", "", "", "", "", "Server issue")
                }
                
            }
        }
    }
    
    static func verifyEmail(email : String, handleCallback: @escaping (User?, String) -> ())
    {
        //NSLog(url)
        
        let params = [
            "email":email
        ] as [String : Any]
        
        Alamofire.request(ReqConst.SERVER_URL + "verify", method: .post, parameters: params).responseJSON { response in
            
            if response.result.isFailure{
                handleCallback(nil, "Server issue")
            }
            else
            {
                let json = JSON(response.result.value!)
                NSLog("Result for Email Verification!!!\(json)")
                if(json["result_code"].stringValue == "0"){
                    
                    let data = json["data"].object as! [String: Any]
                    let user = User()
                    user.idx = data["id"] as! Int64
                    user.name = data["name"] as! String
                    user.email = data["email"] as! String
                    user.password = data["password"] as! String
                    user.area = data["area"] as! String
                    user.address = data["address"] as! String
                    user.phone_number = data["phone_number"] as! String
                    user.street = data["street"] as! String
                    user.auth_status = data["auth_status"] as! String
                    user.registered_time = data["registered_time"] as! String
                    user.house = data["house"] as! String
                    user.instagram = data["instagram"] as! String
                    user.role = data["role"] as! String
                    user.status = data["status"] as! String
                    user.stores = Int(data["stores"] as! String)!
                    user.token = data["token"] as! String
                    
                    handleCallback(user, "0")
                }
                else{
                    handleCallback(nil, "Server issue")
                }
                
            }
        }
    }
    
    static func getFavoriteStores(member_id : Int64, handleCallback: @escaping ([Store]?, String) -> ())
    {
        //NSLog(url)
        
        let params = [
            "member_id":String(member_id)
        ] as [String : Any]
        
        Alamofire.request(ReqConst.SERVER_URL + "favoriteStores", method: .post, parameters: params).responseJSON { response in
            
            if response.result.isFailure{
                handleCallback(nil, "Server issue")
            }
            else
            {
                let json = JSON(response.result.value!)
                NSLog("\(json)")
                if(json["result_code"].stringValue == "0"){
                    var stores = [Store]()
                    let dataArray = json["data"].arrayObject as! [[String: Any]]
                    
                    for data in dataArray{
                        let store = Store()
                        store.idx = data["id"] as! Int64
                        store.userId = Int64(data["member_id"] as! String)!
                        store.name = data["name"] as! String
                        store.logoUrl = data["logo_url"] as! String
                        store.arName = data["ar_name"] as! String
                        store.category = data["category"] as! String
                        store.arCategory = data["ar_category"] as! String
                        store.category2 = data["category2"] as! String
                        store.arCategory2 = data["ar_category2"] as! String
                        store.description = data["description"] as! String
                        store.arDescription = data["ar_description"] as! String
                        store.ratings = Float(data["ratings"] as! String)!
                        store.reviews = Int64(data["reviews"] as! String)!
                        store.registered_time = data["registered_time"] as! String
                        store.status = data["status"] as! String
                        store.likes = Int64(data["likes"] as! String)!
                        if data["isLiked"] as! String == "yes"{
                            store.isLiked = true
                        }else if data["isLiked"] as! String == "no"{
                            store.isLiked = false
                        }else if data["isLiked"] as! String == ""{
                            store.isLiked = false
                        }
                        
                        stores.append(store)
                    }
                    
                    handleCallback(stores, "0")
                    
                }
                else{
                    handleCallback(nil, "Server issue")
                }
                
            }
        }
    }
    
    static func getNotifications(member_id : Int64, handleCallback: @escaping ([Notification]?, String) -> ())
    {
        //NSLog(url)
        
        let params = [
            "receiver_id":String(member_id)
            ] as [String : Any]
        
        Alamofire.request(ReqConst.SERVER_URL + "getNotifications", method: .post, parameters: params).responseJSON { response in
            
            if response.result.isFailure{
                handleCallback(nil, "Server issue")
            }
            else
            {
                let json = JSON(response.result.value!)
                NSLog("\(json)")
                if(json["result_code"].stringValue == "0"){
                    var notis = [Notification]()
                    let dataArray = json["data"].arrayObject as! [[String: Any]]
                    
                    for data in dataArray{
                        let noti = Notification()
                        noti.idx = data["id"] as! Int64
                        noti.receiver_id = Int64(data["receiver_id"] as! String)!
                        noti.imei = data["imei_id"] as! String
                        noti.sender_id = Int64(data["sender_id"] as! String)!
                        noti.sender_name = data["sender_name"] as! String
                        noti.sender_email = data["sender_email"] as! String
                        noti.sender_phone = data["sender_phone"] as! String
                        noti.date_time = data["date_time"] as! String
                        noti.message = data["message"] as! String
                        noti.image = data["image_message"] as! String                        
                        
                        notis.append(noti)
                    }
                    
                    handleCallback(notis, "0")
                    
                }
                else{
                    handleCallback(nil, "Server issue")
                }
                
            }
        }
    }
    
    static func delNotification(noti_id : Int64, handleCallback: @escaping (String) -> ())
    {
        //NSLog(url)
        
        let params = [
            "notification_id":String(noti_id),
        ] as [String : Any]
        
        Alamofire.request(ReqConst.SERVER_URL + "delNotification", method: .post, parameters: params).responseJSON { response in
            
            if response.result.isFailure{
                handleCallback("Server issue")
            }
            else
            {
                let json = JSON(response.result.value!)
                NSLog("\(json)")
                if(json["result_code"].stringValue == "0"){
                    handleCallback("0")
                }
                else{
                    handleCallback("Server issue")
                }
                
            }
        }
    }
    
    static func getOrderItems(member_id : Int64, handleCallback: @escaping ([OrderItem]?, String) -> ())
    {
        //NSLog(url)
        
        let params = [
            "me_id":String(member_id)
        ] as [String : Any]
        
        Alamofire.request(ReqConst.SERVER_URL + "receivedOrderItems", method: .post, parameters: params).responseJSON { response in
            
            if response.result.isFailure{
                handleCallback(nil, "Server issue")
            }
            else
            {
                let json = JSON(response.result.value!)
                NSLog("\(json)")
                if(json["result_code"].stringValue == "0"){
                    var orderItems = [OrderItem]()
                    let dataArray = json["data"].arrayObject as! [[String: Any]]
                    
                    for data in dataArray{
                        let item = OrderItem()
                        item.idx = data["id"] as! Int64
                        item.orderId = Int64(data["order_id"] as! String)!
                        item.userId = Int64(data["member_id"] as! String)!
                        item.imei = data["imei_id"] as! String
                        item.producerId = Int64(data["producer_id"] as! String)!
                        item.storeId = Int64(data["store_id"] as! String)!
                        item.storeName = data["store_name"] as! String
                        item.storeARName = data["ar_store_name"] as! String
                        item.productId = Int64(data["product_id"] as! String)!
                        item.productName = data["product_name"] as! String
                        item.productARName = data["ar_product_name"] as! String
                        item.category = data["category"] as! String
                        item.arCategory = data["ar_category"] as! String
                        item.price = Float(data["price"] as! String)!
                        item.unit = data["unit"] as! String
                        item.quantity = Int64(data["quantity"] as! String)!
                        item.dateTime = data["date_time"] as! String
                        item.pictureUrl = data["picture_url"] as! String
                        item.status = data["status"] as! String
                        item.orderID = data["orderID"] as! String
                        item.contact = data["contact"] as! String
                        item.discount = Int(data["discount"] as! String)!
                        
                        orderItems.append(item)
                    }
                    
                    handleCallback(orderItems, "0")
                    
                }
                else{
                    handleCallback(nil, "Server issue")
                }
                
            }
        }
    }
    
    
    static func getComOrderItems(handleCallback: @escaping ([OrderItem]?, String) -> ())
    {
        //NSLog(url)
        
        let params = [
            :
        ] as [String : Any]
        
        Alamofire.request(ReqConst.SERVER_URL + "comOrderItems", method: .post, parameters: params).responseJSON { response in
            
            if response.result.isFailure{
                handleCallback(nil, "Server issue")
            }
            else
            {
                let json = JSON(response.result.value!)
                NSLog("\(json)")
                if(json["result_code"].stringValue == "0"){
                    var orderItems = [OrderItem]()
                    let dataArray = json["data"].arrayObject as! [[String: Any]]
                    
                    for data in dataArray{
                        let item = OrderItem()
                        item.idx = data["id"] as! Int64
                        item.orderId = Int64(data["order_id"] as! String)!
                        item.userId = Int64(data["member_id"] as! String)!
                        item.imei = data["imei_id"] as! String
                        item.producerId = Int64(data["producer_id"] as! String)!
                        item.storeId = Int64(data["store_id"] as! String)!
                        item.storeName = data["store_name"] as! String
                        item.storeARName = data["ar_store_name"] as! String
                        item.productId = Int64(data["product_id"] as! String)!
                        item.productName = data["product_name"] as! String
                        item.productARName = data["ar_product_name"] as! String
                        item.category = data["category"] as! String
                        item.arCategory = data["ar_category"] as! String
                        item.price = Float(data["price"] as! String)!
                        item.unit = data["unit"] as! String
                        item.quantity = Int64(data["quantity"] as! String)!
                        item.dateTime = data["date_time"] as! String
                        item.pictureUrl = data["picture_url"] as! String
                        item.status = data["status"] as! String
                        item.orderID = data["orderID"] as! String
                        item.contact = data["contact"] as! String
                        item.discount = Int(data["discount"] as! String)!

                        item.compriceStr = (data["comprice"] as! String?)!
                        item.producerContact = (data["producer_contact"] as! String?)!
                        
                        orderItems.append(item)
                    }
                    
                    handleCallback(orderItems, "0")
                    
                }
                else{
                    handleCallback(nil, "Server issue")
                }
                
            }
        }
    }
    
    
    
    
    
    
    static func getPhones(member_id : Int64, imei_id:String, handleCallback: @escaping ([Phone]?, String) -> ())
    {
        //NSLog(url)
        
        let params = [
            "member_id":String(member_id),
            "imei_id":imei_id
        ] as [String : Any]
        
        Alamofire.request(ReqConst.SERVER_URL + "getPhones", method: .post, parameters: params).responseJSON { response in
            
            if response.result.isFailure{
                handleCallback(nil, "Server issue")
            }
            else
            {
                let json = JSON(response.result.value!)
                NSLog("\(json)")
                if(json["result_code"].stringValue == "0"){
                    var phones = [Phone]()
                    let dataArray = json["data"].arrayObject as! [[String: Any]]
                    
                    for data in dataArray{
                        let phone = Phone()
                        phone.idx = data["id"] as! Int64
                        phone.userId = Int64(data["member_id"] as! String)!
                        phone.imei = data["imei_id"] as! String
                        phone.phoneNumber = data["phone_number"] as! String
                        phone.status = data["status"] as! String
                        
                        phones.append(phone)
                    }
                    
                    handleCallback(phones, "0")
                    
                }
                else{
                    handleCallback(nil, "Server issue")
                }
                
            }
        }
    }
    
    
    static func getAddresses(member_id : Int64, imei_id:String, handleCallback: @escaping ([Address]?, String) -> ())
    {
        //NSLog(url)
        
        let params = [
            "member_id":String(member_id),
            "imei_id":imei_id
            ] as [String : Any]
        
        Alamofire.request(ReqConst.SERVER_URL + "getAddresses", method: .post, parameters: params).responseJSON { response in
            
            if response.result.isFailure{
                handleCallback(nil, "Server issue")
            }
            else
            {
                let json = JSON(response.result.value!)
                NSLog("\(json)")
                if(json["result_code"].stringValue == "0"){
                    var addrs = [Address]()
                    let dataArray = json["data"].arrayObject as! [[String: Any]]
                    
                    for data in dataArray{
                        let addr = Address()
                        addr.idx = data["id"] as! Int64
                        addr.userId = Int64(data["member_id"] as! String)!
                        addr.imei = data["imei_id"] as! String
                        addr.address = data["address"] as! String
                        addr.area = data["area"] as! String
                        addr.street = data["street"] as! String
                        addr.house = data["house"] as! String
                        addr.status = data["status"] as! String
                        
                        addrs.append(addr)
                    }
                    
                    handleCallback(addrs, "0")
                    
                }
                else{
                    handleCallback(nil, "Server issue")
                }
                
            }
        }
    }
    
    static func getStoreProducts(imei_id:String, handleCallback: @escaping ([Product]?, String) -> ())
    {
        //NSLog(url)
        
        let params = [
            "imei_id":imei_id
        ] as [String : Any]
        
        Alamofire.request(ReqConst.SERVER_URL + "getProducts", method: .post, parameters: params).responseJSON { response in
            
            if response.result.isFailure{
                handleCallback(nil, "Server issue")
            }
            else
            {
                let json = JSON(response.result.value!)
                NSLog("\(json)")
                if(json["result_code"].stringValue == "0"){
                    var products = [Product]()
                    let dataArray = json["data"].arrayObject as! [[String: Any]]
                    
                    for data in dataArray{
                        let product = Product()
                        product.idx = data["id"] as! Int64
                        product.storeId = Int64(data["store_id"] as! String)!
                        product.userId = Int64(data["member_id"] as! String)!
                        product.name = data["name"] as! String
                        product.arName = data["ar_name"] as! String
                        product.category = data["category"] as! String
                        product.arCategory = data["ar_category"] as! String
                        product.description = data["description"] as! String
                        product.arDescription = data["ar_description"] as! String
                        product.pictureUrl = data["picture_url"] as! String
                        product.price = Float(data["price"] as! String)!
                        product.unit = data["unit"] as! String
                        product.newPrice = Float(data["new_price"] as! String)!
                        product.registered_time = data["registered_time"] as! String
                        product.status = data["status"] as! String
                        if data["isLiked"] as! String == "yes"{
                            product.isLiked = true
                        }else if data["isLiked"] as! String == "no"{
                            product.isLiked = false
                        }else if data["isLiked"] as! String == ""{
                            product.isLiked = false
                        }
                        
                        products.append(product)
                    }
                    
                    handleCallback(products, "0")
                    
                }
                else{
                    handleCallback(nil, "Server issue")
                }
                
            }
        }
    }
    
    static func saveProduct(product_id : Int64, imei_id: String, handleCallback: @escaping (String) -> ())
    {
        //NSLog(url)
        
        let params = [
            "product_id":String(product_id),
            "imei_id":imei_id,
        ] as [String : Any]
        
        Alamofire.request(ReqConst.SERVER_URL + "saveProduct", method: .post, parameters: params).responseJSON { response in
            
            if response.result.isFailure{
                handleCallback("Server issue")
            }
            else
            {
                let json = JSON(response.result.value!)
                NSLog("\(json)")
                if(json["result_code"].stringValue == "0"){
                    handleCallback("0")
                }
                else{
                    handleCallback("Server issue")
                }
                
            }
        }
    }
    
    static func unsaveProduct(product_id : Int64, imei_id: String, handleCallback: @escaping (String) -> ())
    {
        //NSLog(url)
        
        let params = [
            "product_id":String(product_id),
            "imei_id":imei_id,
        ] as [String : Any]
        
        Alamofire.request(ReqConst.SERVER_URL + "unsaveProduct", method: .post, parameters: params).responseJSON { response in
            
            if response.result.isFailure{
                handleCallback("Server issue")
            }
            else
            {
                let json = JSON(response.result.value!)
                NSLog("\(json)")
                if(json["result_code"].stringValue == "0"){
                    handleCallback("0")
                }
                else{
                    handleCallback("Server issue")
                }
                
            }
        }
    }
    
    static func submitMessage(member_id : Int64, message: String, type:String, handleCallback: @escaping (String) -> ())
    {
        //NSLog(url)
        
        let params = [
            "member_id":String(member_id),
            "message":message,
            "type":type
        ] as [String : Any]
        
        Alamofire.request(ReqConst.SERVER_URL + "contactAdmin", method: .post, parameters: params).responseJSON { response in
            
            if response.result.isFailure{
                handleCallback("Server issue")
            }
            else
            {
                let json = JSON(response.result.value!)
                NSLog("\(json)")
                if(json["result_code"].stringValue == "0"){
                    handleCallback("0")
                }
                else{
                    handleCallback("Server issue")
                }
                
            }
        }
    }
    
    static func touchCompany(member_id : Int64, message: String, handleCallback: @escaping (String) -> ())
    {
        //NSLog(url)
        
        let params = [
            "member_id":String(member_id),
            "message":message,
        ] as [String : Any]
        
        Alamofire.request(ReqConst.SERVER_URL + "touchCompany", method: .post, parameters: params).responseJSON { response in
            
            if response.result.isFailure{
                handleCallback("Server issue")
            }
            else
            {
                let json = JSON(response.result.value!)
                NSLog("\(json)")
                if(json["result_code"].stringValue == "0"){
                    handleCallback("0")
                }
                else{
                    handleCallback("Server issue")
                }
                
            }
        }
    }
    
    static func getProductPictures(product_id : Int64, handleCallback: @escaping ([Picture]?, String) -> ())
    {
        //NSLog(url)
        
        let params = [
            "product_id":String(product_id),
        ] as [String : Any]
        
        Alamofire.request(ReqConst.SERVER_URL + "getProductPictures", method: .post, parameters: params).responseJSON { response in
            
            if response.result.isFailure{
                handleCallback(nil, "Server issue")
            }
            else
            {
                let json = JSON(response.result.value!)
                NSLog("\(json)")
                if(json["result_code"].stringValue == "0"){
                    var pictures = [Picture]()
                    let dataArray = json["data"].arrayObject as! [[String: Any]]
                    
                    for data in dataArray{
                        let pic = Picture()
                        pic.idx = data["id"] as! Int64
                        pic.url = data["picture_url"] as! String
                        
                        pictures.append(pic)
                    }
                    
                    handleCallback(pictures, "0")
                    
                }
                else{
                    handleCallback(nil, "Server issue")
                }
                
            }
        }
    }
    
    static func addProductToCart(
        picture_url:String,
        imei_id:String,
        producer_id:Int64,
        store_id:Int64,
        store_name:String,
        store_ar_name:String,
        product_id : Int64,
        product_name:String,
        product_ar_name:String,
        category:String,
        ar_category:String,
        price:Float,
        unit:String,
        quantity:Int,
        compriceId:Int64,
        handleCallback: @escaping (String) -> ())
    {
        //NSLog(url)
        
        let params = [
            "picture_url":picture_url,
            "imei_id":imei_id,
            "producer_id":String(producer_id),
            "store_id":String(store_id),
            "store_name":store_name,
            "ar_store_name":store_ar_name,
            "product_id":String(product_id),
            "product_name":product_name,
            "ar_product_name":product_ar_name,
            "category":category,
            "ar_category":ar_category,
            "price":String(price),
            "unit":unit,
            "quantity":String(quantity),
            "comprice_id":String(compriceId)
        ] as [String : Any]
        
        Alamofire.request(ReqConst.SERVER_URL + "addToCart", method: .post, parameters: params).responseJSON { response in
            
            if response.result.isFailure{
                handleCallback("Server issue")
            }
            else
            {
                let json = JSON(response.result.value!)
                NSLog("\(json)")
                if(json["result_code"].stringValue == "0"){
                    
                    handleCallback("0")
                }
                else{
                    handleCallback("Server issue")
                }
                
            }
        }
    }
    
    static func delCartItem(item_id : Int64, handleCallback: @escaping (String) -> ())
    {
        //NSLog(url)
        
        let params = [
            "item_id":String(item_id),
        ] as [String : Any]
        
        Alamofire.request(ReqConst.SERVER_URL + "delCartItem", method: .post, parameters: params).responseJSON { response in
            
            if response.result.isFailure{
                handleCallback("Server issue")
            }
            else
            {
                let json = JSON(response.result.value!)
                NSLog("\(json)")
                if(json["result_code"].stringValue == "0"){
                    handleCallback("0")
                }
                else{
                    handleCallback("Server issue")
                }
                
            }
        }
    }
    
    static func addCartToWishlist(item_id : Int64, imei_id:String, handleCallback: @escaping (String) -> ())
    {
        //NSLog(url)
        
        let params = [
            "item_id":String(item_id),
            "imei_id":imei_id
        ] as [String : Any]
        
        Alamofire.request(ReqConst.SERVER_URL + "addCartToWishlist", method: .post, parameters: params).responseJSON { response in
            
            if response.result.isFailure{
                handleCallback("Server issue")
            }
            else
            {
                let json = JSON(response.result.value!)
                NSLog("\(json)")
                if(json["result_code"].stringValue == "0"){
                    handleCallback("0")
                }
                else{
                    handleCallback("Server issue")
                }
                
            }
        }
    }
    
    static func updateCartItemQuantity(item_id : Int64, quantity:Int, handleCallback: @escaping (String) -> ())
    {
        //NSLog(url)
        
        let params = [
            "item_id":String(item_id),
            "quantity":String(quantity)
        ] as [String : Any]
        
        Alamofire.request(ReqConst.SERVER_URL + "updateCartItemQuantity", method: .post, parameters: params).responseJSON { response in
            
            if response.result.isFailure{
                handleCallback("Server issue")
            }
            else
            {
                let json = JSON(response.result.value!)
                NSLog("\(json)")
                if(json["result_code"].stringValue == "0"){
                    handleCallback("0")
                }
                else{
                    handleCallback("Server issue")
                }
                
            }
        }
    }
    
    static func getProduct(product_id: Int64, imei_id: String, handleCallback: @escaping (Product?, String) -> ())
    {
        //NSLog(url)
        
        let params = [
            "product_id":String(product_id),
            "imei_id":imei_id
        ] as [String : Any]
        
        Alamofire.request(ReqConst.SERVER_URL + "productInfo", method: .post, parameters: params).responseJSON { response in
            
            if response.result.isFailure{
                handleCallback(nil, "Server issue")
            }
            else
            {
                let json = JSON(response.result.value!)
                NSLog("\(json)")
                if(json["result_code"].stringValue == "0"){
                    
                    let data = json["data"].object as! [String: Any]
                    let product = Product()
                    product.idx = data["id"] as! Int64
                    product.storeId = Int64(data["store_id"] as! String)!
                    product.userId = Int64(data["member_id"] as! String)!
                    product.name = data["name"] as! String
                    product.arName = data["ar_name"] as! String
                    product.category = data["category"] as! String
                    product.arCategory = data["ar_category"] as! String
                    product.description = data["description"] as! String
                    product.arDescription = data["ar_description"] as! String
                    product.pictureUrl = data["picture_url"] as! String
                    product.price = Float(data["price"] as! String)!
                    product.unit = data["unit"] as! String
                    product.newPrice = Float(data["new_price"] as! String)!
                    product.registered_time = data["registered_time"] as! String
                    product.status = data["status"] as! String
                    if data["isLiked"] as! String == "yes"{
                        product.isLiked = true
                    }else if data["isLiked"] as! String == "no"{
                        product.isLiked = false
                    }else if data["isLiked"] as! String == ""{
                        product.isLiked = false
                    }
                    
                    product.storeName = data["store_name"] as! String
                    product.storeARName = data["ar_store_name"] as! String
                    
                    handleCallback(product, "0")
                    
                }else{
                    handleCallback(nil, "Server issue")
                }
                
            }
        }
    }
    
    static func getSavedProducts(imei_id:String, handleCallback: @escaping ([Product]?, String) -> ())
    {
        //NSLog(url)
        
        let params = [
            "imei_id":imei_id
        ] as [String : Any]
        
        Alamofire.request(ReqConst.SERVER_URL + "getSavedProducts", method: .post, parameters: params).responseJSON { response in
            
            if response.result.isFailure{
                handleCallback(nil, "Server issue")
            }
            else
            {
                let json = JSON(response.result.value!)
                NSLog("\(json)")
                if(json["result_code"].stringValue == "0"){
                    var products = [Product]()
                    let dataArray = json["data"].arrayObject as! [[String: Any]]
                    
                    for data in dataArray{
                        let product = Product()
                        product.idx = data["id"] as! Int64
                        product.storeId = Int64(data["store_id"] as! String)!
                        product.userId = Int64(data["member_id"] as! String)!
                        product.name = data["name"] as! String
                        product.arName = data["ar_name"] as! String
                        product.category = data["category"] as! String
                        product.arCategory = data["ar_category"] as! String
                        product.description = data["description"] as! String
                        product.arDescription = data["ar_description"] as! String
                        product.pictureUrl = data["picture_url"] as! String
                        product.price = Float(data["price"] as! String)!
                        product.unit = data["unit"] as! String
                        product.newPrice = Float(data["new_price"] as! String)!
                        product.registered_time = data["registered_time"] as! String
                        product.status = data["status"] as! String
                        if data["isLiked"] as! String == "yes"{
                            product.isLiked = true
                        }else if data["isLiked"] as! String == "no"{
                            product.isLiked = false
                        }else if data["isLiked"] as! String == ""{
                            product.isLiked = false
                        }
                        
                        product.storeName = data["store_name"] as! String
                        product.storeARName = data["ar_store_name"] as! String
                        
                        products.append(product)
                    }
                    
                    handleCallback(products, "0")
                    
                }
                else{
                    handleCallback(nil, "Server issue")
                }
                
            }
        }
    }
    
    static func addWishlistToCart(
        picture_url:String,
        imei_id:String,
        producer_id:Int64,
        store_id:Int64,
        store_name:String,
        store_ar_name:String,
        product_id : Int64,
        product_name:String,
        product_ar_name:String,
        category:String,
        ar_category:String,
        price:Float,
        unit:String,
        quantity:Int,
        compriceId:Int64,
        handleCallback: @escaping (String) -> ())
    {
        //NSLog(url)
        
        let params = [
            "picture_url":picture_url,
            "imei_id":imei_id,
            "producer_id":String(producer_id),
            "store_id":String(store_id),
            "store_name":store_name,
            "ar_store_name":store_ar_name,
            "product_id":String(product_id),
            "product_name":product_name,
            "ar_product_name":product_ar_name,
            "category":category,
            "ar_category":ar_category,
            "price":String(price),
            "unit":unit,
            "quantity":String(quantity),
            "comprice_id":String(compriceId)
        ] as [String : Any]
        
        Alamofire.request(ReqConst.SERVER_URL + "addWishlistToCart", method: .post, parameters: params).responseJSON { response in
            
            if response.result.isFailure{
                handleCallback("Server issue")
            }
            else
            {
                let json = JSON(response.result.value!)
                NSLog("\(json)")
                if(json["result_code"].stringValue == "0"){
                    
                    handleCallback("0")
                }
                else{
                    handleCallback("Server issue")
                }
                
            }
        }
    }
    
    static func getRatings(store_id:Int64, handleCallback: @escaping ([Rating]?, String) -> ())
    {
        //NSLog(url)
        
        let params = [
            "store_id":String(store_id)
        ] as [String : Any]
        
        Alamofire.request(ReqConst.SERVER_URL + "getRatings", method: .post, parameters: params).responseJSON { response in
            
            if response.result.isFailure{
                handleCallback(nil, "Server issue")
            }
            else
            {
                let json = JSON(response.result.value!)
                NSLog("\(json)")
                if(json["result_code"].stringValue == "0"){
                    var ratings = [Rating]()
                    let dataArray = json["data"].arrayObject as! [[String: Any]]
                    
                    for data in dataArray{
                        let rating = Rating()
                        rating.idx = data["id"] as! Int64
                        rating.storeId = Int64(data["store_id"] as! String)!
                        rating.userId = Int64(data["member_id"] as! String)!
                        rating.userName = data["member_name"] as! String
                        rating.userPictureUrl = data["member_photo"] as! String
                        rating.rating = Double(data["rating"] as! String)!
                        rating.subject = data["subject"] as! String
                        rating.description = data["description"] as! String
                        rating.date = data["date_time"] as! String
                        rating.lang = data["lang"] as! String
                        
                        ratings.append(rating)
                    }
                    
                    handleCallback(ratings, "0")
                    
                }
                else{
                    handleCallback(nil, "Server issue")
                }
                
            }
        }
    }
    
    static func submitRate(member_id:Int64, store_id:Int64, subject:String, rating:Double, description:String, lang:String, handleCallback: @escaping (String, String, String, String) -> ())
    {
        //NSLog(url)
        
        let params = [
            "member_id":String(member_id),
            "store_id":String(store_id),
            "subject":subject,
            "rating":String(rating),
            "description":description,
            "lang":lang
        ] as [String : Any]
        
        Alamofire.request(ReqConst.SERVER_URL + "placeStoreFeedback", method: .post, parameters: params).responseJSON { response in
            
            if response.result.isFailure{
                handleCallback("", "", "", "Server issue")
            }
            else
            {
                let json = JSON(response.result.value!)
                NSLog("\(json)")
                if(json["result_code"].stringValue == "0"){
                    handleCallback(
                        json["ratings"].stringValue,
                        json["reviews"].stringValue,
                        json["lang"].stringValue,
                        "0"
                    )                    
                }
                else{
                    handleCallback("", "", "", "Server issue")
                }
                
            }
        }
    }
    
    func postImageRequestWithURL(withUrl strURL: String,withParam postParam: Dictionary<String, Any>,withImages imageArray:NSMutableArray,completion:@escaping (_ isSuccess: Bool, _ response:NSDictionary) -> Void)
    {
        
        Alamofire.upload(multipartFormData: { (MultipartFormData) in
            
            // Here is your Image Array
            for (imageDic) in imageArray
            {
                let imageDic = imageDic as! NSDictionary
                
                for (key,valus) in imageDic
                {
                    MultipartFormData.append(valus as! Data, withName:key as! String, fileName: String(NSDate().timeIntervalSince1970) + ".jpg", mimeType: "image/jpg")
                }
            }
            
            // Here is your Post paramaters
            for (key, value) in postParam
            {
                MultipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
            
        }, usingThreshold: UInt64.init(), to: strURL, method: .post) { (result) in
            
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    
                    if response.response?.statusCode == 200
                    {
                        let json = response.result.value as? NSDictionary
                        
                        completion(true,json!);
                    }
                    else
                    {
                        completion(false,[:]);
                    }
                }
                
            case .failure(let encodingError):
                print(encodingError)
                
                completion(false,[:]);
            }
            
        }
    }
    
    func postRequestWithURL(withUrl strURL: String,withParam postParam: Dictionary<String, Any>,completion:@escaping (_ isSuccess: Bool, _ response:NSDictionary) -> Void)
    {
        
        Alamofire.upload(multipartFormData: { (MultipartFormData) in
            
            // Here is your Post paramaters
            for (key, value) in postParam
            {
                MultipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
            
        }, usingThreshold: UInt64.init(), to: strURL, method: .post) { (result) in
            
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    
                    if response.response?.statusCode == 200
                    {
                        let json = response.result.value as? NSDictionary
                        
                        completion(true,json!);
                    }
                    else
                    {
                        completion(false,[:]);
                    }
                }
                
            case .failure(let encodingError):
                print(encodingError)
                
                completion(false,[:]);
            }
            
        }
    }
    
    static func updateMember(member_id: Int64, name:String, email : String, phone_number: String, instagram: String, address: String, area: String, street: String, house: String, handleCallback: @escaping (User?, String) -> ())
    {
        //NSLog(url)
        
        let params = [
            "member_id":String(member_id),
            "name":name,
            "email":email,
            "phone_number":phone_number,
            "instagram":instagram,
            "address":address,
            "area":area,
            "street":street,
            "house":house
        ] as [String : Any]
        
        Alamofire.request(ReqConst.SERVER_URL + "updateMember", method: .post, parameters: params).responseJSON { response in
            
            if response.result.isFailure{
                handleCallback(nil, "Server issue")
            }
            else
            {
                let json = JSON(response.result.value!)
                NSLog("\(json)")
                if(json["result_code"].stringValue == "0"){
                    
                    let data = json["data"].object as! [String: Any]
                    let user = User()
                    user.idx = data["id"] as! Int64
                    user.name = data["name"] as! String
                    user.email = data["email"] as! String
                    user.password = data["password"] as! String
                    user.area = data["area"] as! String
                    user.address = data["address"] as! String
                    user.phone_number = data["phone_number"] as! String
                    user.street = data["street"] as! String
                    user.auth_status = data["auth_status"] as! String
                    user.registered_time = data["registered_time"] as! String
                    user.house = data["house"] as! String
                    user.instagram = data["instagram"] as! String
                    user.role = data["role"] as! String
                    user.status = data["status"] as! String
                    user.stores = Int(data["stores"] as! String)!
                    user.token = data["token"] as! String
                    
                    handleCallback(user, "0")
                }
                else if(json["result_code"].stringValue == "1"){
                    handleCallback(nil, "1")
                }else{
                    handleCallback(nil, "Server issue")
                }
                
            }
        }
    }
    
    static func delAddress(addr_id : Int64, handleCallback: @escaping (String) -> ())
    {
        //NSLog(url)
        
        let params = [
            "addr_id":String(addr_id),
            ] as [String : Any]
        
        Alamofire.request(ReqConst.SERVER_URL + "delAddress", method: .post, parameters: params).responseJSON { response in
            
            if response.result.isFailure{
                handleCallback("Server issue")
            }
            else
            {
                let json = JSON(response.result.value!)
                NSLog("\(json)")
                if(json["result_code"].stringValue == "0"){
                    handleCallback("0")
                }
                else{
                    handleCallback("Server issue")
                }
                
            }
        }
    }
    
    static func delPhone(phone_id : Int64, handleCallback: @escaping (String) -> ())
    {
        //NSLog(url)
        
        let params = [
            "phone_id":String(phone_id),
            ] as [String : Any]
        
        Alamofire.request(ReqConst.SERVER_URL + "delPhone", method: .post, parameters: params).responseJSON { response in
            
            if response.result.isFailure{
                handleCallback("Server issue")
            }
            else
            {
                let json = JSON(response.result.value!)
                NSLog("\(json)")
                if(json["result_code"].stringValue == "0"){
                    handleCallback("0")
                }
                else{
                    handleCallback("Server issue")
                }
                
            }
        }
    }
    
    static func savePhone(member_id : Int64, imei_id:String, phone_number:String, handleCallback: @escaping (String) -> ())
    {
        //NSLog(url)
        
        let params = [
            "member_id":String(member_id),
            "imei_id":imei_id,
            "phone_number":phone_number
            ] as [String : Any]
        
        Alamofire.request(ReqConst.SERVER_URL + "savePhoneNumber", method: .post, parameters: params).responseJSON { response in
            
            if response.result.isFailure{
                handleCallback("Server issue")
            }
            else
            {
                let json = JSON(response.result.value!)
                NSLog("\(json)")
                if(json["result_code"].stringValue == "0"){
                    handleCallback("0")
                }
                else{
                    handleCallback("Server issue")
                }
                
            }
        }
    }
    
    static func saveAddress(member_id : Int64, imei_id:String, address:String, area:String, street:String, house:String, handleCallback: @escaping (String) -> ())
    {
        //NSLog(url)
        
        let params = [
            "member_id":String(member_id),
            "imei_id":imei_id,
            "address":address,
            "area":area,
            "street":street,
            "house":house
        ] as [String : Any]
        
        Alamofire.request(ReqConst.SERVER_URL + "saveAddress", method: .post, parameters: params).responseJSON { response in
            
            if response.result.isFailure{
                handleCallback("Server issue")
            }
            else
            {
                let json = JSON(response.result.value!)
                NSLog("\(json)")
                if(json["result_code"].stringValue == "0"){
                    handleCallback("0")
                }
                else{
                    handleCallback("Server issue")
                }
                
            }
        }
    }
    
    static func submitAppRate(member_id:Int64, store_id:Int64, subject:String, rating:Double, description:String, lang:String, handleCallback: @escaping (String) -> ())
    {
        //NSLog(url)
        
        let params = [
            "member_id":String(member_id),
            "store_id":String(store_id),
            "subject":subject,
            "rating":String(rating),
            "description":description,
            "lang":lang
            ] as [String : Any]
        
        Alamofire.request(ReqConst.SERVER_URL + "placeAppFeedback", method: .post, parameters: params).responseJSON { response in
            
            if response.result.isFailure{
                handleCallback("Server issue")
            }
            else
            {
                let json = JSON(response.result.value!)
                NSLog("\(json)")
                if(json["result_code"].stringValue == "0"){
                    handleCallback("0")
                }
                else{
                    handleCallback("Server issue")
                }
                
            }
        }
    }
    
    
    static func getMyLuckyInfo(member_id:Int64, handleCallback: @escaping (String, String) -> ())
    {
        //NSLog(url)
        
        let params = [
            "member_id":String(member_id)
        ] as [String : Any]
        
        Alamofire.request(ReqConst.SERVER_URL + "getMyLuckyInfo", method: .post, parameters: params).responseJSON { response in
            
            if response.result.isFailure{
                handleCallback("", "Server issue")
            }
            else
            {
                let json = JSON(response.result.value!)
                NSLog("\(json)")
                if(json["result_code"].stringValue == "0"){
                    handleCallback(
                        "", "0"
                    )
                }else if(json["result_code"].stringValue == "1"){
                    let data = json["data"].object as! [String: Any]
                    let status = data["status"] as! String
                    
                    handleCallback(
                        status, "1"
                    )
                }else if(json["result_code"].stringValue == "2"){
                    let data = json["data"].object as! [String: Any]
                    let memberName = data["member_name"] as! String
                    
                    handleCallback(
                        memberName, "2"
                    )
                }
                else{
                    handleCallback("", "Server issue")
                }
                
            }
        }
    }
    
    static func postLuckyInfo(member_id:Int64, handleCallback: @escaping (String, String) -> ())
    {
        //NSLog(url)
        
        let params = [
            "member_id":String(member_id)
        ] as [String : Any]
        
        Alamofire.request(ReqConst.SERVER_URL + "postLuckyInfo", method: .post, parameters: params).responseJSON { response in
            
            if response.result.isFailure{
                handleCallback("", "Server issue")
            }
            else
            {
                let json = JSON(response.result.value!)
                NSLog("\(json)")
                if(json["result_code"].stringValue == "0"){
                    handleCallback(
                        "", "0"
                    )
                }else if(json["result_code"].stringValue == "1"){
                    let data = json["data"].object as! [String: Any]
                    let memberName = data["member_name"] as! String
                    
                    handleCallback(
                        memberName, "1"
                    )
                }
                else{
                    handleCallback("", "Server issue")
                }
                
            }
        }
    }
    
    static func getCoupons(member_id:Int64, handleCallback: @escaping ([Coupon]?, [Coupon]?, [Coupon]?, String) -> ())
    {
        //NSLog(url)
        
        let params = [
            "me_id":String(member_id)
        ] as [String : Any]
        
        Alamofire.request(ReqConst.SERVER_URL + "getCoupons", method: .post, parameters: params).responseJSON { response in
            
            if response.result.isFailure{
                handleCallback(nil, nil, nil, "Server issue")
            }
            else
            {
                let json = JSON(response.result.value!)
                NSLog("\(json)")
                if(json["result_code"].stringValue == "0"){
                    var availables = [Coupon]()
                    var useds = [Coupon]()
                    var expireds = [Coupon]()
                    
                    let availablesArray = json["availables"].arrayObject as! [[String: Any]]
                    
                    for data in availablesArray{
                        let coupon = Coupon()
                        coupon.id = data["id"] as! Int64
                        coupon.discount = Int(Int64(data["discount"] as! String)!)
                        coupon.expireTime = Int64(data["expire_time"] as! String)!
                        
                        availables.append(coupon)
                    }
                    
                    let usedsArray = json["useds"].arrayObject as! [[String: Any]]
                    
                    for data in usedsArray{
                        let coupon = Coupon()
                        coupon.id = data["id"] as! Int64
                        coupon.discount = Int(Int64(data["discount"] as! String)!)
                        coupon.expireTime = Int64(data["expire_time"] as! String)!
                        
                        useds.append(coupon)
                    }
                    
                    let expiredsArray = json["expireds"].arrayObject as! [[String: Any]]
                    
                    for data in expiredsArray{
                        let coupon = Coupon()
                        coupon.id = data["id"] as! Int64
                        coupon.discount = Int(Int64(data["discount"] as! String)!)
                        coupon.expireTime = Int64(data["expire_time"] as! String)!
                        
                        expireds.append(coupon)
                    }
                    
                    handleCallback(availables, useds, expireds, "0")
                    
                }
                else{
                    handleCallback(nil, nil, nil, "Server issue")
                }
                
            }
        }
    }
    
    static func getUserOrders(me_id:Int64, handleCallback: @escaping ([Order]?, String) -> ())
    {
        //NSLog(url)
        
        let params = [
            "me_id":String(me_id)
        ] as [String : Any]
        
        Alamofire.request(ReqConst.SERVER_URL + "getUserOrders", method: .post, parameters: params).responseJSON { response in
            
            if response.result.isFailure{
                handleCallback(nil, "Server issue")
            }
            else
            {
                let json = JSON(response.result.value!)
                NSLog("\(json)")
                if(json["result_code"].stringValue == "0"){
                    var orders = [Order]()
                    let dataArray = json["data"].arrayObject as! [[String: Any]]
                    
                    for data in dataArray{
                        let order = Order()
                        order.idx = data["id"] as! Int64
                        order.imei = data["imei_id"] as! String
                        order.userId = Int64(data["member_id"] as! String)!
                        order.orderID = data["orderID"] as! String
                        order.dateTime = data["date_time"] as! String
                        order.email = data["email"] as! String
                        order.address = data["address"] as! String
                        order.addressLine = data["address_line"] as! String
                        order.phone_number = data["phone_number"] as! String
                        order.status = data["status"] as! String
                        order.price = Float(data["price"] as! String)!
                        order.unit = data["unit"] as! String
                        order.shipping = Float(data["shipping"] as! String)!
                        order.discount = Int(data["discount"] as! String)!
                        
                        var items = [OrderItem]()
                        let itemArray = data["items"] as! [[String: Any]]
                        for item in itemArray{
                            let orderItem = OrderItem()
                            orderItem.idx = item["id"] as! Int64
                            orderItem.imei = item["imei_id"] as! String
                            orderItem.userId = Int64(item["member_id"] as! String)!
                            orderItem.orderID = item["orderID"] as! String
                            orderItem.dateTime = item["date_time"] as! String
                            orderItem.producerId = Int64(item["producer_id"] as! String)!
                            orderItem.storeId = Int64(item["store_id"] as! String)!
                            orderItem.productId = Int64(item["product_id"] as! String)!
                            orderItem.storeName = item["store_name"] as! String
                            orderItem.storeARName = item["ar_store_name"] as! String
                            orderItem.productName = item["product_name"] as! String
                            orderItem.productARName = item["ar_product_name"] as! String
                            orderItem.category = item["category"] as! String
                            orderItem.arCategory = item["ar_category"] as! String
                            orderItem.status = item["status"] as! String
                            orderItem.pictureUrl = item["picture_url"] as! String
                            orderItem.contact = item["contact"] as! String
                            orderItem.price = Float(item["price"] as! String)!
                            orderItem.unit = item["unit"] as! String
                            orderItem.quantity = Int64(item["quantity"] as! String)!
                            orderItem.discount = Int(item["discount"] as! String)!
                            
                            items.append(orderItem)
                        }
                        
                        order.orderItems = items
                        
                        orders.append(order)
                    }
                    
                    handleCallback(orders, "0")
                    
                }
                else{
                    handleCallback(nil, "Server issue")
                }
                
            }
        }
    }
    
    static func getUserOrderItems(member_id : Int64, handleCallback: @escaping ([OrderItem]?, String) -> ())
    {
        //NSLog(url)
        
        let params = [
            "me_id":String(member_id)
            ] as [String : Any]
        
        Alamofire.request(ReqConst.SERVER_URL + "userOrderItems", method: .post, parameters: params).responseJSON { response in
            
            if response.result.isFailure{
                handleCallback(nil, "Server issue")
            }
            else
            {
                let json = JSON(response.result.value!)
                NSLog("\(json)")
                if(json["result_code"].stringValue == "0"){
                    var orderItems = [OrderItem]()
                    let dataArray = json["data"].arrayObject as! [[String: Any]]
                    
                    for data in dataArray{
                        let item = OrderItem()
                        item.idx = data["id"] as! Int64
                        item.orderId = Int64(data["order_id"] as! String)!
                        item.userId = Int64(data["member_id"] as! String)!
                        item.imei = data["imei_id"] as! String
                        item.producerId = Int64(data["producer_id"] as! String)!
                        item.storeId = Int64(data["store_id"] as! String)!
                        item.storeName = data["store_name"] as! String
                        item.storeARName = data["ar_store_name"] as! String
                        item.productId = Int64(data["product_id"] as! String)!
                        item.productName = data["product_name"] as! String
                        item.productARName = data["ar_product_name"] as! String
                        item.category = data["category"] as! String
                        item.arCategory = data["ar_category"] as! String
                        item.price = Float(data["price"] as! String)!
                        item.unit = data["unit"] as! String
                        item.quantity = Int64(data["quantity"] as! String)!
                        item.dateTime = data["date_time"] as! String
                        item.pictureUrl = data["picture_url"] as! String
                        item.status = data["status"] as! String
                        item.orderID = data["orderID"] as! String
                        item.contact = data["contact"] as! String
                        item.discount = Int(data["discount"] as! String)!
                        
                        orderItems.append(item)
                    }
                    
                    handleCallback(orderItems, "0")
                    
                }
                else{
                    handleCallback(nil, "Server issue")
                }
                
            }
        }
    }
    
    static func delOrder(order_id : Int64, handleCallback: @escaping (String) -> ())
    {
        //NSLog(url)
        
        let params = [
            "order_id":String(order_id),
        ] as [String : Any]
        
        Alamofire.request(ReqConst.SERVER_URL + "delOrder", method: .post, parameters: params).responseJSON { response in
            
            if response.result.isFailure{
                handleCallback("Server issue")
            }
            else
            {
                let json = JSON(response.result.value!)
                NSLog("\(json)")
                if(json["result_code"].stringValue == "0"){
                    handleCallback("0")
                }
                else{
                    handleCallback("Server issue")
                }
                
            }
        }
    }
    
    static func cancelOrderItem(item_id : Int64, handleCallback: @escaping (String) -> ())
    {
        //NSLog(url)
        
        let params = [
            "item_id":String(item_id),
            ] as [String : Any]
        
        Alamofire.request(ReqConst.SERVER_URL + "cancelOrderItem", method: .post, parameters: params).responseJSON { response in
            
            if response.result.isFailure{
                handleCallback("Server issue")
            }
            else
            {
                let json = JSON(response.result.value!)
                NSLog("\(json)")
                if(json["result_code"].stringValue == "0"){
                    handleCallback("0")
                }
                else{
                    handleCallback("Server issue")
                }
                
            }
        }
    }
    
    static func progressOrderItems(member_id : Int64, item_id:Int64, next_status:String, handleCallback: @escaping ([OrderItem]?, String) -> ())
    {
        //NSLog(url)
        
        let params = [
            "me_id":String(member_id),
            "item_id":String(item_id),
            "next": next_status
        ] as [String : Any]
        
        Alamofire.request(ReqConst.SERVER_URL + "progressOrderItem", method: .post, parameters: params).responseJSON { response in
            
            if response.result.isFailure{
                handleCallback(nil, "Server issue")
            }
            else
            {
                let json = JSON(response.result.value!)
                NSLog("\(json)")
                if(json["result_code"].stringValue == "0"){
                    var orderItems = [OrderItem]()
                    let dataArray = json["data"].arrayObject as! [[String: Any]]
                    
                    for data in dataArray{
                        let item = OrderItem()
                        item.idx = data["id"] as! Int64
                        item.orderId = Int64(data["order_id"] as! String)!
                        item.userId = Int64(data["member_id"] as! String)!
                        item.imei = data["imei_id"] as! String
                        item.producerId = Int64(data["producer_id"] as! String)!
                        item.storeId = Int64(data["store_id"] as! String)!
                        item.storeName = data["store_name"] as! String
                        item.storeARName = data["ar_store_name"] as! String
                        item.productId = Int64(data["product_id"] as! String)!
                        item.productName = data["product_name"] as! String
                        item.productARName = data["ar_product_name"] as! String
                        item.category = data["category"] as! String
                        item.arCategory = data["ar_category"] as! String
                        item.price = Float(data["price"] as! String)!
                        item.unit = data["unit"] as! String
                        item.quantity = Int64(data["quantity"] as! String)!
                        item.dateTime = data["date_time"] as! String
                        item.pictureUrl = data["picture_url"] as! String
                        item.status = data["status"] as! String
                        item.orderID = data["orderID"] as! String
                        item.contact = data["contact"] as! String
                        item.discount = Int(data["discount"] as! String)!
                        
                        orderItems.append(item)
                    }
                    
                    handleCallback(orderItems, "0")
                    
                }
                else{
                    handleCallback(nil, "Server issue")
                }
                
            }
        }
    }
    
    
    static func getOrderById(order_id:Int64, handleCallback: @escaping (Order?, String) -> ())
    {
        //NSLog(url)
        
        let params = [
            "order_id":String(order_id)
            ] as [String : Any]
        
        Alamofire.request(ReqConst.SERVER_URL + "orderById", method: .post, parameters: params).responseJSON { response in
            
            if response.result.isFailure{
                handleCallback(nil, "Server issue")
            }
            else
            {
                let json = JSON(response.result.value!)
                NSLog("\(json)")
                if(json["result_code"].stringValue == "0"){
                    let data = json["data"].object as! [String: Any]
                    let order = Order()
                    order.idx = data["id"] as! Int64
                    order.imei = data["imei_id"] as! String
                    order.userId = Int64(data["member_id"] as! String)!
                    order.orderID = data["orderID"] as! String
                    order.dateTime = data["date_time"] as! String
                    order.email = data["email"] as! String
                    order.address = data["address"] as! String
                    order.addressLine = data["address_line"] as! String
                    order.phone_number = data["phone_number"] as! String
                    order.status = data["status"] as! String
                    order.price = Float(data["price"] as! String)!
                    order.unit = data["unit"] as! String
                    order.shipping = Float(data["shipping"] as! String)!
                    order.discount = Int(data["discount"] as! String)!
                    order.company = data["company"] as! String
                    
                    var items = [OrderItem]()
                    let itemArray = data["items"] as! [[String: Any]]
                    for item in itemArray{
                        let orderItem = OrderItem()
                        orderItem.idx = item["id"] as! Int64
                        orderItem.imei = item["imei_id"] as! String
                        orderItem.userId = Int64(item["member_id"] as! String)!
                        orderItem.orderID = item["orderID"] as! String
                        orderItem.dateTime = item["date_time"] as! String
                        orderItem.producerId = Int64(item["producer_id"] as! String)!
                        orderItem.storeId = Int64(item["store_id"] as! String)!
                        orderItem.productId = Int64(item["product_id"] as! String)!
                        orderItem.storeName = item["store_name"] as! String
                        orderItem.storeARName = item["ar_store_name"] as! String
                        orderItem.productName = item["product_name"] as! String
                        orderItem.productARName = item["ar_product_name"] as! String
                        orderItem.category = item["category"] as! String
                        orderItem.arCategory = item["ar_category"] as! String
                        orderItem.status = item["status"] as! String
                        orderItem.pictureUrl = item["picture_url"] as! String
                        orderItem.contact = item["contact"] as! String
                        orderItem.price = Float(item["price"] as! String)!
                        orderItem.unit = item["unit"] as! String
                        orderItem.quantity = Int64(item["quantity"] as! String)!
                        orderItem.discount = Int(item["discount"] as! String)!
                        orderItem.compriceStr = item["comprice"] as! String
                        
                        items.append(orderItem)
                    }
                    
                    order.orderItems = items
                    
                    handleCallback(order, "0")
                }
                else{
                    handleCallback(nil, "Server issue")
                }
                
            }
        }
    }
    
    func postImageArrayRequestWithURL(withUrl strURL: String,withParam postParam: Dictionary<String, Any>,withImages imageArray:NSMutableArray,completion:@escaping (_ isSuccess: Bool, _ response:NSDictionary) -> Void)
    {
        
        Alamofire.upload(multipartFormData: { (MultipartFormData) in
            
            // Here is your Image Array
            for image in imageArray
            {
                let imageData = image as! Data
                
                MultipartFormData.append(imageData, withName:"file" + String(imageArray.index(of: image)), fileName: String(NSDate().timeIntervalSince1970) + ".jpg", mimeType: "image/jpg")
            }
            
            // Here is your Post paramaters
            for (key, value) in postParam
            {
                MultipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
            
        }, usingThreshold: UInt64.init(), to: strURL, method: .post) { (result) in
            
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    
                    if response.response?.statusCode == 200
                    {
                        let json = response.result.value as? NSDictionary
                        
                        completion(true,json!);
                    }
                    else
                    {
                        completion(false,[:]);
                    }
                }
                
            case .failure(let encodingError):
                print(encodingError)
                
                completion(false,[:]);
            }
            
        }
    }
    
    static func registerFCMToken(member_id:Int64, token:String, handleCallback: @escaping (String, String) -> ())
    {
        //NSLog(url)
        let params = [
            "fcm_token":token,
            "member_id": String(member_id),
            ] as [String : Any]
        
        Alamofire.request(ReqConst.SERVER_URL + "uploadfcmtoken", method: .post, parameters: params).responseJSON { response in
            
            if response.result.isFailure{
                handleCallback("", "Server issue")
            }
            else
            {
                let json = JSON(response.result.value!)
                if(json["result_code"].stringValue == "0"){
                    handleCallback(json["fcm_token"].stringValue, "0")
                }else {
                    handleCallback("", "Server issue")
                }
            }
        }
    }
    
    static func checkMember(member_id:Int64, handleCallback: @escaping (String) -> ())
    {
        //NSLog(url)
        let params = [
            "member_id": String(member_id),
            ] as [String : Any]
        
        Alamofire.request(ReqConst.SERVER_URL + "checkmember", method: .post, parameters: params).responseJSON { response in
            
            if response.result.isFailure{
                handleCallback("Server issue")
            }
            else
            {
                let json = JSON(response.result.value!)
                if(json["result_code"].stringValue == "0"){
                    handleCallback("0")
                }else if(json["result_code"].stringValue == "1"){
                    handleCallback("1")
                }
                else {
                    handleCallback("Server issue")
                }
            }
        }
    }
    
    static func checkStore(store_id:Int64, handleCallback: @escaping (String) -> ())
    {
        //NSLog(url)
        let params = [
            "store_id": String(store_id),
            ] as [String : Any]
        
        Alamofire.request(ReqConst.SERVER_URL + "checkstore", method: .post, parameters: params).responseJSON { response in
            
            if response.result.isFailure{
                handleCallback("Server issue")
            }
            else
            {
                let json = JSON(response.result.value!)
                if(json["result_code"].stringValue == "0"){
                    handleCallback("0")
                }else if(json["result_code"].stringValue == "1"){
                    handleCallback("1")
                }
                else {
                    handleCallback("Server issue")
                }
            }
        }
    }
    
    static func getProducerInstagram(member_id:Int64, handleCallback: @escaping (String, String) -> ())
    {
        //NSLog(url)
        let params = [
            "member_id": String(member_id),
            ] as [String : Any]
        
        Alamofire.request(ReqConst.SERVER_URL + "getInstagram", method: .post, parameters: params).responseJSON { response in
            
            if response.result.isFailure{
                handleCallback("", "Server issue")
            }
            else
            {
                let json = JSON(response.result.value!)
                if(json["result_code"].stringValue == "0"){
                    handleCallback(json["instagram"].stringValue, "0")
                }else {
                    handleCallback("", "Server issue")
                }
            }
        }
    }
    
    static func deleteProduct(product_id : Int64, handleCallback: @escaping (String) -> ())
    {
        //NSLog(url)
        
        let params = [
            "product_id":String(product_id),
            ] as [String : Any]
        
        Alamofire.request(ReqConst.SERVER_URL + "proddelete", method: .post, parameters: params).responseJSON { response in
            
            if response.result.isFailure{
                handleCallback("Server issue")
            }
            else
            {
                let json = JSON(response.result.value!)
                NSLog("\(json)")
                if(json["result_code"].stringValue == "0"){
                    handleCallback("0")
                }
                else{
                    handleCallback("Server issue")
                }
                
            }
        }
    }
    
    static func comlogin(password : String, handleCallback: @escaping (String) -> ())
    {
        //NSLog(url)
        
        let params = [
            "password":password,
        ] as [String : Any]
        
        Alamofire.request(ReqConst.SERVER_URL + "comlogin", method: .post, parameters: params).responseJSON { response in
            
            if response.result.isFailure{
                handleCallback("Server issue")
            }
            else
            {
                let json = JSON(response.result.value!)
                NSLog("\(json)")
                if(json["result_code"].stringValue == "0"){
                    handleCallback("0")
                }else if(json["result_code"].stringValue == "1"){
                    handleCallback("1")
                }
                else{
                    handleCallback("Server issue")
                }
                
            }
        }
    }
    
    static func getComprices(handleCallback: @escaping ([CompanyPrice]?, String) -> ())
    {
        //NSLog(url)
        
        let params = [
            :
        ] as [String : Any]
        
        Alamofire.request(ReqConst.SERVER_URL + "getComprices", method: .post, parameters: params).responseJSON { response in
            
            if response.result.isFailure{
                handleCallback(nil, "Server issue")
            }
            else
            {
                let json = JSON(response.result.value!)
                NSLog("\(json)")
                if(json["result_code"].stringValue == "0"){
                    var comprices = [CompanyPrice]()
                    let dataArray = json["data"].arrayObject as! [[String: Any]]
                    
                    for data in dataArray{
                        let comprice = CompanyPrice()
                        comprice.id = data["id"] as! Int64
                        comprice.price = Double(data["price"] as! String)!
                        comprice.description = data["description"] as! String
                        
                        comprices.append(comprice)
                    }
                    
                    handleCallback(comprices, "0")
                    
                }
                else{
                    handleCallback(nil, "Server issue")
                }
                
            }
        }
    }
    
}








































