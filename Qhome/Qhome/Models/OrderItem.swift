
//
//  OrderItem.swift
//  Qhome
//
//  Created by LGH419 on 7/22/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import Foundation

class OrderItem{
    var idx:Int64 = 0
    var orderId:Int64 = 0
    var userId:Int64 = 0
    var imei:String = ""
    var producerId:Int64 = 0
    var storeId:Int64 = 0
    var storeName:String = ""
    var storeARName:String = ""
    var productId:Int64 = 0
    var productName:String = ""
    var productARName:String = ""
    var category:String = ""
    var arCategory:String = ""
    var price:Float = 0.0
    var unit:String = ""
    var quantity:Int64 = 0
    var dateTime:String = ""
    var pictureUrl:String = ""
    var status:String = ""
    var orderID:String = ""
    var contact:String = ""
    var discount:Int = 0
    var compriceStr:String = ""
    var producerContact:String = ""
}

var gOrderItem:OrderItem = OrderItem()
