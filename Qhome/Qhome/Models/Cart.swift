//
//  Cart.swift
//  Qhome
//
//  Created by LGH419 on 7/19/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import Foundation

class Cart{
    var idx:Int64 = 0
    var imei:String = ""
    var producerId:Int64 = 0
    var productId:Int64 = 0
    var storeId:Int64 = 0
    var storeName:String = ""
    var storeARName:String = ""
    var productName:String = ""
    var productARName:String = ""
    var pictureUrl:String = ""
    var category:String = ""
    var arCategory:String = ""
    var description:String = ""
    var price:Float = 0.0
    var unit:String = ""
    var quantity:Int64 = 0
    var dateTime:String = ""
    var status:String = ""
    var priceId:Int64 = 0
}

var gCart = Cart()
var gCartItems = [Cart]()
