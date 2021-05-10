//
//  Phone.swift
//  Qhome
//
//  Created by LGH419 on 7/19/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import Foundation

class Phone{
    var idx:Int64 = 0
    var userId:Int64 = 0
    var imei:String = ""
    var phoneNumber:String = ""
    var status:String = ""
}

var gPhone = Phone()
var gPhones = [Phone]()
