//
//  CouponListViewController.swift
//  Qhome
//
//  Created by LGH419 on 7/22/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit

class CouponListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var view_nav: UIView!
    @IBOutlet weak var view_donot: UIView!
    @IBOutlet weak var couponList: UITableView!
    
    var coupons = [Coupon]()

    override func viewDidLoad() {
        super.viewDidLoad()

        addShadowToBar(view: view_nav)
        setRoundShadowView(view: view_donot, corner: 3)
        
        self.couponList.delegate = self
        self.couponList.dataSource = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dontUseCoupon(_:)))
        self.view_donot.addGestureRecognizer(tap)
        
    }
    
    @objc func dontUseCoupon(_ sender: UITapGestureRecognizer? = nil) {
        gCouponId = 0
        gCheckoutViewController.pDiscount = 0
        gCheckoutViewController.applyCoupon()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getCoupons()
    }
    
    func getCoupons(){
        
        self.coupons.removeAll()
        
        APIs.getCoupons(member_id: thisUser.idx, handleCallback: {
            availables, useds, expireds, result_code in
            print(result_code)
            if result_code == "0"{
                for coupon in availables!{
                    self.coupons.append(coupon)
                }
                
                if self.coupons.count == 0{
                    self.couponList.isHidden = true
                    self.showToast(msg: Language().no_coupon)
                }else{
                    self.couponList.isHidden = false
                }
                
                self.couponList.reloadData()
            }
        })
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.coupons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:CouponItemCell = tableView.dequeueReusableCell(withIdentifier: "CouponItemCell", for: indexPath) as! CouponItemCell
        
        let index:Int = indexPath.row
        if lang == "ar"{
            cell.lbl_discount.text = "%" + String(self.coupons[index].discount)
        }else{
            cell.lbl_discount.text = String(self.coupons[index].discount) + "%"
        }
        
        cell.lbl_expiretime.text = self.getDateFromTimeStamp(timeStamp: Double(self.coupons[index].expireTime/1000))
        setRoundShadowView(view: cell.view_content, corner: 3)
        cell.view_separator.addDashBorder(color: primaryColor)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 98.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        gCouponId = self.coupons[indexPath.row].id
        gCheckoutViewController.pDiscount = self.coupons[indexPath.row].discount
        gCheckoutViewController.applyCoupon()
    }
    
    func getDateFromTimeStamp(timeStamp : Double) -> String {
        
        let date = NSDate(timeIntervalSince1970: timeStamp)
        
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "dd MMM YY, hh:mm a"
        // UnComment below to get only time
        //  dayTimePeriodFormatter.dateFormat = "hh:mm a"
        
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        return dateString
    }

    @IBAction func close(_ sender: Any) {
        gCheckoutViewController.closeCouponList()
    }
    

}
