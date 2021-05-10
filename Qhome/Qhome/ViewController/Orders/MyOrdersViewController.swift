//
//  MyOrdersViewController.swift
//  Qhome
//
//  Created by LGH419 on 7/23/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit
import SCLAlertView

class MyOrdersViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var view_all: UIView!
    @IBOutlet weak var lbl_all: UILabel!
    @IBOutlet weak var view_all_indicator: UIView!
    @IBOutlet weak var view_placed: UIView!
    @IBOutlet weak var lbl_placed: UILabel!
    @IBOutlet weak var view_placed_indicator: UIView!
    @IBOutlet weak var view_confirmed: UIView!
    @IBOutlet weak var lbl_confirmed: UILabel!
    @IBOutlet weak var view_confirmed_indicator: UIView!
    @IBOutlet weak var view_prepared: UIView!
    @IBOutlet weak var view_prepared_indicator: UIView!
    @IBOutlet weak var lbl_prepared: UILabel!
    @IBOutlet weak var view_ready_indicator: UIView!
    @IBOutlet weak var lbl_ready: UILabel!
    @IBOutlet weak var view_ready: UIView!
    @IBOutlet weak var view_completed: UIView!
    @IBOutlet weak var lbl_completed: UILabel!
    @IBOutlet weak var view_completed_indicator: UIView!
    @IBOutlet weak var view_placed_count: UIView!
    @IBOutlet weak var lbl_placed_count: UILabel!
    @IBOutlet weak var view_confirmed_count: UIView!
    @IBOutlet weak var lbl_confirmed_count: UILabel!
    @IBOutlet weak var view_prepared_count: UIView!
    @IBOutlet weak var lbl_prepared_count: UILabel!
    @IBOutlet weak var view_ready_count: UIView!
    @IBOutlet weak var lbl_ready_count: UILabel!
    @IBOutlet weak var view_completed_count: UIView!
    @IBOutlet weak var lbl_completed_count: UILabel!
    
    @IBOutlet weak var view_nav: UIView!
    @IBOutlet weak var btn_search: UIButton!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var view_searchbar: UIView!
    @IBOutlet weak var edt_search: UITextField!
    
    
    @IBOutlet weak var orderList: UITableView!
    
    var orders = [Order]()
    var searchOrders = [Order]()
    
    let unSelAttrs = [
        NSAttributedString.Key.foregroundColor : lightPrimaryColor,
        NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
        ] as [NSAttributedString.Key : Any]
    
    let selAttrs = [
        NSAttributedString.Key.foregroundColor : primaryColor,
        NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15),
        ] as [NSAttributedString.Key : Any]
    
    var myOrders2Frame:MyOrders2ViewController!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        gMyOrdersViewController = self

        addShadowToBar(view: view_nav)
        
        self.view_placed_count.isHidden = true
        self.view_confirmed_count.isHidden = true
        self.view_prepared_count.isHidden = true
        self.view_ready_count.isHidden = true
        self.view_completed_count.isHidden = true
        
        self.myOrders2Frame = self.storyboard!.instantiateViewController(withIdentifier: "MyOrders2ViewController") as? MyOrders2ViewController
        self.myOrders2Frame.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.myOrders2Frame.view.frame.size.height)
        
        orderList.delegate = self
        orderList.dataSource = self
        
        orderList.estimatedRowHeight = 120
        orderList.rowHeight = UITableView.automaticDimension
        
        edt_search.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                             for: UIControl.Event.editingChanged)
        
        self.resetTabs()
        self.lbl_all.attributedText = NSAttributedString(string: Language().all, attributes: selAttrs)
        self.view_all_indicator.isHidden = false
        if lang == "ar"{
            self.scrollView.setContentOffset(CGPoint(x: scrollView.contentSize.width - scrollView.frame.size.width, y: 0.0), animated: true)
        }else{
            self.scrollView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
        }
        
        var tap = UITapGestureRecognizer(target: self, action: #selector(self.toPlaced(_:)))
        self.view_placed.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.toConfirmed(_:)))
        self.view_confirmed.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.toPrepared(_:)))
        self.view_prepared.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.toReady(_:)))
        self.view_ready.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.toDelivered(_:)))
        self.view_completed.addGestureRecognizer(tap)
        
    }
    
    func toTappedPage(){
        UIView.animate(withDuration: 0.3){() -> Void in
            self.myOrders2Frame.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            self.myOrders2Frame.initPage()
            self.view.addSubview(self.myOrders2Frame.view)
            self.addChild(self.myOrders2Frame)
        }
    }
    
    @objc func toPlaced(_ sender: UITapGestureRecognizer? = nil) {
        gSelectedOrderStatus = 0
        self.toTappedPage()
    }
    
    @objc func toConfirmed(_ sender: UITapGestureRecognizer? = nil) {
        gSelectedOrderStatus = 1
        self.toTappedPage()
    }
    
    @objc func toPrepared(_ sender: UITapGestureRecognizer? = nil) {
        gSelectedOrderStatus = 2
        self.toTappedPage()
    }
    
    @objc func toReady(_ sender: UITapGestureRecognizer? = nil) {
        gSelectedOrderStatus = 3
        self.toTappedPage()
    }
    
    @objc func toDelivered(_ sender: UITapGestureRecognizer? = nil) {
        gSelectedOrderStatus = 4
        self.toTappedPage()
    }
    
    func resetTabs(){
        
        self.lbl_all.attributedText = NSAttributedString(string: Language().all, attributes: unSelAttrs)
        self.lbl_placed.attributedText = NSAttributedString(string: Language().placed, attributes: unSelAttrs)
        self.lbl_confirmed.attributedText = NSAttributedString(string: Language().confirmed, attributes: unSelAttrs)
        self.lbl_prepared.attributedText = NSAttributedString(string: Language().prepared, attributes: unSelAttrs)
        self.lbl_ready.attributedText = NSAttributedString(string: Language().ready, attributes: unSelAttrs)
        self.lbl_completed.attributedText = NSAttributedString(string: Language().delivered, attributes: unSelAttrs)
        
        self.view_all_indicator.isHidden = true
        self.view_placed_indicator.isHidden = true
        self.view_confirmed_indicator.isHidden = true
        self.view_prepared_indicator.isHidden = true
        self.view_ready_indicator.isHidden = true
        self.view_completed_indicator.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getOrders()
        self.getOrderItems()
    }
    
    @IBAction func search(_ sender: Any) {
        if view_searchbar.isHidden{
            view_searchbar.isHidden = false
            btn_search.setImage(cancel, for: .normal)
            lbl_title.isHidden = true
            
        }else{
            view_searchbar.isHidden = true
            btn_search.setImage(search, for: .normal)
            lbl_title.isHidden = false
            self.edt_search.text = ""
            self.orders = searchOrders
            self.orderList.reloadData()
        }
    }
    
    @IBAction func back(_ sender: Any) {
        gMyOrdersViewController = nil
        dismissViewController()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text == ""{
            self.getOrders()
        }else{
            orders = filter(keyword: (textField.text?.lowercased())!)
            if orders.isEmpty{
                self.showToast(msg: Language().noresult)
            }
            self.orderList.reloadData()
        }
    }
    
    func filter(keyword:String) -> [Order]{
        if keyword == ""{
            return searchOrders
        }
        var filtereds = [Order]()
        for order in searchOrders{
            if order.orderID.lowercased().contains(keyword){
                filtereds.append(order)
            }else{
                if order.address.lowercased().contains(keyword){
                    filtereds.append(order)
                }else{
                    if order.phone_number.lowercased().contains(keyword){
                        filtereds.append(order)
                    }else{
                        if String(order.price).contains(keyword){
                            filtereds.append(order)
                        }else{
                            if order.addressLine.contains(keyword){
                                filtereds.append(order)
                            }
                        }
                    }
                }
            }
        }
        return filtereds
    }
    
    func getOrders(){
        self.orders.removeAll()
        self.searchOrders.removeAll()
        self.showLoadingView()
        APIs.getUserOrders(me_id: thisUser.idx, handleCallback: {
            orders, result_code in
            print(result_code)
            self.dismissLoadingView()
            if result_code == "0"{
                for order in orders!{
                    self.orders.append(order)
                    self.searchOrders.append(order)
                }
                if self.orders.count == 0{
                    self.orderList.isHidden = true
                    self.showToast(msg: Language().noresult)
                }else{
                    self.orderList.isHidden = false
                }
                
                self.orderList.reloadData()
            }
        })
    
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:MyOrderCell = tableView.dequeueReusableCell(withIdentifier: "MyOrderCell", for: indexPath) as! MyOrderCell
        
        let index:Int = indexPath.row
        
        cell.lbl_orderID.text = self.orders[index].orderID
        if lang == "ar" {
            cell.lbl_price.text = "QR " + String(self.orders[index].price)
        }else{
            cell.lbl_price.text = String(self.orders[index].price) + " QR"
        }
        cell.lbl_date.text = self.getDateFromTimeStamp(timeStamp: Double(self.orders[index].dateTime)!/1000)
        
        cell.orderItems = self.orders[index].orderItems
        cell.itemList.reloadData()
        
        cell.btn_cancel.layer.cornerRadius = 3
        cell.btn_cancel.layer.borderColor = UIColor.lightGray.cgColor
        cell.btn_cancel.layer.borderWidth = 1
        
        cell.btn_cancel.tag = index
        cell.btn_cancel.addTarget(self, action: #selector(cancelOrder), for: .touchUpInside)
        
        setRoundShadowButton(button: cell.btn_reorder, corner: 3)
        cell.btn_reorder.tag = index
        cell.btn_reorder.addTarget(self, action: #selector(reorder), for: .touchUpInside)
        
        cell.view_content.tag = index
        var tap = UITapGestureRecognizer(target: self, action: #selector(self.toDetail(_:)))
        cell.view_content.addGestureRecognizer(tap)
        
        cell.view_content.sizeToFit()
        cell.view_content.layoutIfNeeded()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        
        print("tapped!!!")
        gOrder = self.orders[indexPath.row]
        let conVC = AppDelegate.currentStoryboard.instantiateViewController(withIdentifier: "OrderDetailViewController")
        conVC.modalPresentationStyle = .fullScreen
        transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
    }
    
    @objc func toDetail(_ sender: UITapGestureRecognizer? = nil) {
        let tag = sender?.view?.tag
        gOrder = self.orders[tag!]        
        let conVC = AppDelegate.currentStoryboard.instantiateViewController(withIdentifier: "OrderDetailViewController")
        conVC.modalPresentationStyle = .fullScreen
        transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
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
    
    @objc func reorder(sender : UIButton){
        gOrder = self.orders[sender.tag]
        
        gCartItems.removeAll()
        
        for index in (0...gOrder.orderItems.count - 1) {
            let cart = Cart()
            cart.idx = gOrder.orderItems[index].idx
            cart.imei = gOrder.orderItems[index].imei
            cart.producerId = gOrder.orderItems[index].producerId
            cart.pictureUrl = gOrder.orderItems[index].pictureUrl
            cart.productId = gOrder.orderItems[index].productId
            cart.productName = gOrder.orderItems[index].productName
            cart.productARName = gOrder.orderItems[index].productARName
            cart.storeId = gOrder.orderItems[index].storeId
            cart.storeName = gOrder.orderItems[index].storeName
            cart.storeARName = gOrder.orderItems[index].storeARName
            cart.category = gOrder.orderItems[index].category
            cart.arCategory = gOrder.orderItems[index].arCategory
            cart.price = gOrder.orderItems[index].price
            cart.unit = gOrder.orderItems[index].unit
            cart.quantity = gOrder.orderItems[index].quantity
            
            gCartItems.append(cart)
        }
        
        let conVC = AppDelegate.currentStoryboard.instantiateViewController(withIdentifier: "CheckoutViewController")
        conVC.modalPresentationStyle = .fullScreen
        transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
    }
    
    @objc func cancelOrder(sender : UIButton){
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: true
        )
        let alert = SCLAlertView(appearance: appearance)
        alert.addButton(Language().yes) {
            let order = self.orders[sender.tag]
            APIs.delOrder(order_id:order.idx, handleCallback: {
                result_code in
                print(result_code)
                if result_code == "0"{
                    let index = self.orders.firstIndex{$0 === order}
                    self.orders.remove(at: index!)
                    self.searchOrders.remove(at: index!)
                    self.orderList.reloadData()
                    self.getOrderItems()
                }
            })
        }
        alert.showWarning(Language().warning, subTitle: Language().surecancel)
        
    }
    
    func getOrderItems(){
        APIs.getUserOrderItems(member_id: thisUser.idx, handleCallback: {
            orderItems, result_code in
            print(result_code)
            if result_code == "0"{                
                self.getItemStatus(status: "placed", orderItems: orderItems!)
                self.getItemStatus(status: "confirmed", orderItems: orderItems!)
                self.getItemStatus(status: "prepared", orderItems: orderItems!)
                self.getItemStatus(status: "ready", orderItems: orderItems!)
                self.getItemStatus(status: "delivered", orderItems: orderItems!)
            }
        })
    }
    
    func getItemStatus(status:String, orderItems:[OrderItem]){
        var items = [OrderItem]()
        for item in orderItems{
            if item.status == status{
                items.append(item)
            }
        }
        if items.count > 0{
            print("\(status) : \(items.count)")
            if status == "placed"{
                self.view_placed_count.isHidden = false
                self.lbl_placed_count.text = String(items.count)
            }else if status == "confirmed"{
                self.view_confirmed_count.isHidden = false
                self.lbl_confirmed_count.text = String(items.count)
            }else if status == "prepared"{
                self.view_prepared_count.isHidden = false
                self.lbl_prepared_count.text = String(items.count)
            }else if status == "ready"{
                self.view_ready_count.isHidden = false
                self.lbl_ready_count.text = String(items.count)
            }else if status == "delivered"{
                self.view_completed_count.isHidden = false
                self.lbl_completed_count.text = String(items.count)
            }
            
        }else{
            if status == "placed"{
                self.view_placed_count.isHidden = true
            }else if status == "confirmed"{
                self.view_confirmed_count.isHidden = true
            }else if status == "prepared"{
                self.view_prepared_count.isHidden = true
            }else if status == "ready"{
                self.view_ready_count.isHidden = true
            }else if status == "delivered"{
                self.view_completed_count.isHidden = true
            }
        }
    }

}
