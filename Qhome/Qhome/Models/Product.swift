//
//  Product.swift
//  Qhome
//
//  Created by LGH419 on 7/17/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import Foundation

class Product{
    var idx:Int64 = 0
    var storeId:Int64 = 0
    var userId:Int64 = 0
    var name:String = ""
    var pictureUrl:String = ""
    var category:String = ""
    var description:String = ""
    var price:Float = 0.0
    var newPrice:Float = 0.0
    var unit:String = ""
    var likes:Int64 = 0
    var isLiked:Bool = false
    var status:String = ""
    var registered_time:String = ""
    var arName:String = ""
    var arCategory:String = ""
    var arDescription:String = ""
    
    var storeName:String = ""
    var storeARName:String = ""
    
    var pictureList = [String]()
}

var gProduct:Product = Product()
var gSavedProducts = [Product]()
