//
//  Order.swift
//  Qhome
//
//  Created by LGH419 on 7/22/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import Foundation

class Order{
    var idx:Int64 = 0
    var userId:Int64 = 0
    var imei:String = ""
    var orderID:String = ""
    var price:Float = 0.0
    var unit:String = ""
    var shipping:Float = 0.0
    var dateTime:String = ""
    var email:String = ""
    var address:String = ""
    var addressLine:String = ""
    var phone_number:String = ""
    var status:String = ""
    var discount:Int = 0
    var company:String = ""
    
    var orderItems = [OrderItem]()
}

var gOrder:Order = Order()
