//
//  Store.swift
//  Qhome
//
//  Created by LGH419 on 7/12/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import Foundation

class Store{
    var idx:Int64 = 0
    var userId:Int64 = 0
    var name:String = ""
    var logoUrl:String = ""
    var category:String = ""
    var category2:String = ""
    var description:String = ""
    var ratings:Float = 0.0
    var reviews:Int64 = 0
    var likes:Int64 = 0
    var isLiked:Bool = false
    var status:String = ""
    var registered_time:String = ""
    var arName:String = ""
    var arCategory:String = ""
    var arCategory2:String = ""
    var arDescription:String = ""
    var priceId:Int64 = 0
}

var gStore:Store = Store()
