//
//  Coupon.swift
//  Qhome
//
//  Created by LGH419 on 7/22/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import Foundation

class Coupon{
    var id:Int64 = 0
    var userId:Int64 = 0
    var imei:String = ""
    var discount:Int = 0
    var expireTime:Int64 = 0
    var option:String = ""
    var status:String = ""
}

var gCoupon:Coupon = Coupon()
