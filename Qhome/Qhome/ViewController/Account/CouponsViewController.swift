//
//  CouponsViewController.swift
//  Qhome
//
//  Created by LGH419 on 7/28/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit

class CouponsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var view_nav: UIView!
    @IBOutlet weak var view_tabs: UIView!
    @IBOutlet weak var view_unused: UIView!
    @IBOutlet weak var lbl_unused: UILabel!
    @IBOutlet weak var view_used: UIView!
    @IBOutlet weak var lbl_used: UILabel!
    @IBOutlet weak var view_expired: UIView!
    @IBOutlet weak var lbl_expired: UILabel!
    @IBOutlet weak var view_unused_indicator: UIView!
    @IBOutlet weak var view_used_indicator: UIView!
    @IBOutlet weak var view_expired_indicator: UIView!
    @IBOutlet weak var couponList: UITableView!
    
    let unSelAttrs = [
        NSAttributedString.Key.foregroundColor : lightPrimaryColor,
        NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
        ] as [NSAttributedString.Key : Any]
    
    let selAttrs = [
        NSAttributedString.Key.foregroundColor : primaryColor,
        NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15),
        ] as [NSAttributedString.Key : Any]
    
    var coupons = [Coupon]()
    var availables = [Coupon]()
    var useds = [Coupon]()
    var expireds = [Coupon]()

    override func viewDidLoad() {
        super.viewDidLoad()

        addShadowToBar(view: view_nav)
        
        self.couponList.delegate = self
        self.couponList.dataSource = self
        
        var tap = UITapGestureRecognizer(target: self, action: #selector(self.tappedUnused(_:)))
        self.view_unused.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.tappedUsed(_:)))
        self.view_used.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.tappedExpired(_:)))
        self.view_expired.addGestureRecognizer(tap)
        
        self.selUnused()
        
    }
    
    @objc func tappedUnused(_ sender: UITapGestureRecognizer? = nil) {
        self.selUnused()
    }
    
    @objc func tappedUsed(_ sender:UITapGestureRecognizer? = nil){
        self.selUsed()
    }
    
    @objc func tappedExpired(_ sender:UITapGestureRecognizer? = nil){
        self.selExpired()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func getCoupons(){
        
        self.coupons.removeAll()
        self.availables.removeAll()
        self.useds.removeAll()
        self.expireds.removeAll()
        
        self.showLoadingView()
        APIs.getCoupons(member_id: thisUser.idx, handleCallback: {
            availables, useds, expireds, result_code in
            print(result_code)
            self.dismissLoadingView()
            if result_code == "0"{
                for coupon in availables!{
                    self.coupons.append(coupon)
                    self.availables.append(coupon)
                }
                for coupon in useds!{
                    self.useds.append(coupon)
                }
                for coupon in expireds!{
                    self.expireds.append(coupon)
                }
                if self.coupons.count == 0{
                    self.showToast(msg: Language().no_coupon)
                }
                self.couponList.reloadData()
            }
        })
        
    }
    
    func resetTabs(){
        
        self.lbl_unused.attributedText = NSAttributedString(string: Language().unused, attributes: unSelAttrs)
        self.lbl_used.attributedText = NSAttributedString(string: Language().used, attributes: unSelAttrs)
        self.lbl_expired.attributedText = NSAttributedString(string: Language().expired, attributes: unSelAttrs)
        
        self.view_unused_indicator.isHidden = true
        self.view_used_indicator.isHidden = true
        self.view_expired_indicator.isHidden = true
        
    }
    
    func selUnused(){
        self.resetTabs()
        self.lbl_unused.attributedText = NSAttributedString(string: Language().unused, attributes: selAttrs)
        self.view_unused_indicator.isHidden = false
        self.getCoupons()
    }
    
    func selUsed(){
        self.resetTabs()
        self.lbl_used.attributedText = NSAttributedString(string: Language().used, attributes: selAttrs)
        self.view_used_indicator.isHidden = false
        self.coupons.removeAll()
        for coupon in self.useds{
            self.coupons.append(coupon)
        }
        if self.coupons.count == 0{
            self.showToast(msg: Language().no_coupon)
        }
        self.couponList.reloadData()
    }
    
    func selExpired(){
        self.resetTabs()
        self.lbl_expired.attributedText = NSAttributedString(string: Language().expired, attributes: selAttrs)
        self.view_expired_indicator.isHidden = false
        self.coupons.removeAll()
        for coupon in self.expireds{
            self.coupons.append(coupon)
        }
        if self.coupons.count == 0{
            self.showToast(msg: Language().no_coupon)
        }
        self.couponList.reloadData()
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismissViewController()
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
        return 120.0
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

}
