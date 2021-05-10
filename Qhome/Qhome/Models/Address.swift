//
//  Address.swift
//  Qhome
//
//  Created by LGH419 on 7/19/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import Foundation

class Address{
    var idx:Int64 = 0
    var userId:Int64 = 0
    var imei:String = ""
    var address:String = ""
    var area:String = ""
    var street:String = ""
    var house:String = ""
    var status:String = ""
}

var gAddress = Address()
var gAddresses = [Address]()
