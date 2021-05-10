//
//  OrderStatus.swift
//  Qhome
//
//  Created by LGH419 on 7/23/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import Foundation

class OrderStatus{
    var statusStr = [String : String]()
    var nextStatus = [String : String]()
    var nextStatusStr = [String : String]()
    var statusIndex = [String : Int]()
    
    func initOrderStatus(){
        
        statusStr["placed"] = Language().placed
        statusStr["confirmed"] = Language().confirmed
        statusStr["prepared"] = Language().prepared
        statusStr["ready"] = Language().ready
        statusStr["delivered"] = Language().delivered
        
        nextStatus["placed"] = "confirmed"
        nextStatus["confirmed"] = "prepared"
        nextStatus["prepared"] = "ready"
        nextStatus["ready"] = "delivered"
        
        nextStatusStr["placed"] = Language().confirm
        nextStatusStr["confirmed"] = Language().prepare
        nextStatusStr["prepared"] = Language().ready
        nextStatusStr["ready"] = Language().delivery
        nextStatusStr["delivered"] = Language().completed
        
        statusIndex["placed"] = 0
        statusIndex["confirmed"] = 1
        statusIndex["prepared"] = 2
        statusIndex["ready"] = 3
        statusIndex["delivered"] = 4
        
    }
}
