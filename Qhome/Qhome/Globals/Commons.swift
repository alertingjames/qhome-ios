//
//  Commons.swift
//  Qhome
//
//  Created by LGH419 on 7/7/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import Foundation
import UIKit
import CoreData

var gFCMToken:String = ""
var gBadgeCount:Int = 0

var lang:String!
var isMenuOpen:Bool = false
var darkBackg:DarkBackgroundViewController!
var homeButton:UIButton!
var gMainMenu:MainMenuViewController!
var gNotificationEnabled:Bool = true
var gHomeViewController:HomeViewController!
var gSignupViewController:SignupViewController!
var gRegisterStoreViewController:RegisterStoreViewController!
var gContactUsViewController:ContactUsViewController? = nil
var gCategory:String!
var gMinPrice:Int64 = 0
var gMaxPrice:Int64 = Int64(MAX_PRODUCT_PRICE)
var gPriceSort:Int = 0
var gNameSort:Int = 0
var gCategoryViewController:CategoryViewController!
var gMyStoreProfileViewController:MyStoreProfileViewController!
var gMyStoreDetailViewController:MyStoreDetailViewController? = nil
var gStoreDetailViewController:StoreDetailViewController? = nil
var gStoreProductsViewController:StoreProductsViewController!
var gHelpViewController:HelpViewController? = nil
var gCheckoutViewController:CheckoutViewController!
var gPhoneId:Int64 = 0
var gAddressId:Int64 = 0
var gCouponId:Int64 = 0
var gOrderItems = [OrderItem]()
var gSelectedOrderStatus:Int = 0
var gMyOrdersViewController:MyOrdersViewController!
var gOrderStatus:OrderStatus = OrderStatus()
var gItem:OrderItem = OrderItem()
var gIMEI:String!
var gStores = [Store]()
var gMyStores = [Store]()
var gCartItemsCount:Int = 0
var gEmail:String!
var gCartViewController:CartViewController!
var gProductOption:String!
var gAddrOption:String!
var gAddressViewController:AddressViewController!
var gTotalPrice:Double = 0.0
var gOrderID:String!
var gOrderDate:String!
var gComPriceId:Int64 = 0
var gCompanyViewController:CompanyViewController!
var gCAdminViewController:CAdminViewController!
