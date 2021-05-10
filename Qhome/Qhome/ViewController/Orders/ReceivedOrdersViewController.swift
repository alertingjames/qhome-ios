//
//  ReceivedOrdersViewController.swift
//  Qhome
//
//  Created by LGH419 on 7/24/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit
import SCLAlertView
import Kingfisher

class ReceivedOrdersViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var view_nav: UIView!
    @IBOutlet weak var btn_search: UIButton!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var view_searchbar: UIView!
    @IBOutlet weak var edt_search: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
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
    
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img4: UIImageView!
    @IBOutlet weak var img5: UIImageView!
    @IBOutlet weak var line1: UIView!
    @IBOutlet weak var line2: UIView!
    @IBOutlet weak var line3: UIView!
    @IBOutlet weak var line4: UIView!
    
    var imgArray = [UIImageView]()
    var lineArray = [UIView]()
    
    @IBOutlet weak var orderItemList: UITableView!
    
    var orderItems = [OrderItem]()
    var searchOrderItems = [OrderItem]()
    
    let unSelAttrs = [
        NSAttributedString.Key.foregroundColor : lightPrimaryColor,
        NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
        ] as [NSAttributedString.Key : Any]
    
    let selAttrs = [
        NSAttributedString.Key.foregroundColor : primaryColor,
        NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15),
        ] as [NSAttributedString.Key : Any]
    

    override func viewDidLoad() {
        super.viewDidLoad()

        addShadowToBar(view: view_nav)
        
        orderItemList.delegate = self
        orderItemList.dataSource = self
        
        gSelectedOrderStatus = 0
        
        edt_search.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                             for: UIControl.Event.editingChanged)
        
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
        
        initPage()
        

    }
    
    func initPage(){
        self.appearTrackFrame(selStatus: gSelectedOrderStatus)
        self.selectedTab(selStatus: gSelectedOrderStatus)
        if gSelectedOrderStatus == 0{
            if lang == "ar"{
                self.scrollView.setContentOffset(CGPoint(x: scrollView.contentSize.width - scrollView.frame.size.width, y: 0.0), animated: true)
            }else{
                self.scrollView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
            }
        }else if gSelectedOrderStatus == 1{
            if lang == "ar"{
                self.scrollView.setContentOffset(CGPoint(x: scrollView.contentSize.width - scrollView.frame.size.width, y: 0.0), animated: true)
            }else{
                self.scrollView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
            }
        }else if gSelectedOrderStatus == 2{
            if lang == "ar"{
                self.scrollView.setContentOffset(CGPoint(x: scrollView.contentSize.width - scrollView.frame.size.width - self.view_placed.frame.width, y: 0.0), animated: true)
            }else{
                self.scrollView.setContentOffset(CGPoint(x: self.view_placed.frame.width, y: 0.0), animated: true)
            }
        }else if gSelectedOrderStatus == 3{
            if lang == "ar"{
                self.scrollView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
            }else{
                self.scrollView.setContentOffset(CGPoint(x: self.scrollView.contentSize.width - self.scrollView.frame.width, y: 0.0), animated: true)
            }
        }else if gSelectedOrderStatus == 4{
            if lang == "ar"{
                self.scrollView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
            }else{
                self.scrollView.setContentOffset(CGPoint(x: self.scrollView.contentSize.width - self.scrollView.frame.width, y: 0.0), animated: true)
            }
        }
        self.getOrders(status:gSelectedOrderStatus)
    }
    
    @objc func toPlaced(_ sender: UITapGestureRecognizer? = nil) {
        if gSelectedOrderStatus != 0{
            gSelectedOrderStatus = 0
            initPage()
        }
    }
    
    @objc func toConfirmed(_ sender: UITapGestureRecognizer? = nil) {
        if gSelectedOrderStatus != 1{
            gSelectedOrderStatus = 1
            initPage()
        }
    }
    
    @objc func toPrepared(_ sender: UITapGestureRecognizer? = nil) {
        if gSelectedOrderStatus != 2{
            gSelectedOrderStatus = 2
            initPage()
        }
    }
    
    @objc func toReady(_ sender: UITapGestureRecognizer? = nil) {
        if gSelectedOrderStatus != 3{
            gSelectedOrderStatus = 3
            initPage()
        }
    }
    
    @objc func toDelivered(_ sender: UITapGestureRecognizer? = nil) {
        if gSelectedOrderStatus != 4{
            gSelectedOrderStatus = 4
            initPage()
        }
    }
    
    func selectedTab(selStatus:Int){
        resetTabs()
        if selStatus == 0{
            self.lbl_placed.attributedText = NSAttributedString(string: Language().neworders, attributes: selAttrs)
            self.view_placed_indicator.isHidden = false
        }else if selStatus == 1{
            self.lbl_confirmed.attributedText = NSAttributedString(string: Language().confirmed, attributes: selAttrs)
            self.view_confirmed_indicator.isHidden = false
        }else if selStatus == 2{
            self.lbl_prepared.attributedText = NSAttributedString(string: Language().prepared, attributes: selAttrs)
            self.view_prepared_indicator.isHidden = false
        }else if selStatus == 3{
            self.lbl_ready.attributedText = NSAttributedString(string: Language().ready, attributes: selAttrs)
            self.view_ready_indicator.isHidden = false
        }else if selStatus == 4{
            self.lbl_completed.attributedText = NSAttributedString(string: Language().delivered, attributes: selAttrs)
            self.view_completed_indicator.isHidden = false
        }
    }
    
    func resetTabs(){
        
        self.lbl_placed.attributedText = NSAttributedString(string: Language().neworders, attributes: unSelAttrs)
        self.lbl_confirmed.attributedText = NSAttributedString(string: Language().confirmed, attributes: unSelAttrs)
        self.lbl_prepared.attributedText = NSAttributedString(string: Language().prepared, attributes: unSelAttrs)
        self.lbl_ready.attributedText = NSAttributedString(string: Language().ready, attributes: unSelAttrs)
        self.lbl_completed.attributedText = NSAttributedString(string: Language().delivered, attributes: unSelAttrs)
        
        self.view_placed_indicator.isHidden = true
        self.view_confirmed_indicator.isHidden = true
        self.view_prepared_indicator.isHidden = true
        self.view_ready_indicator.isHidden = true
        self.view_completed_indicator.isHidden = true
        
    }
    
    func appearTrackFrame(selStatus:Int){
        imgArray = [img1, img2, img3, img4, img5]
        lineArray = [line1, line2, line3, line4]
        
        for node in imgArray{
            node.image = UIImage(named: "gray_circle")
        }
        for line in lineArray{
            line.backgroundColor = UIColor(rgb: 0xD1D1D1, alpha: 1.0)
        }
        for i in 0...imgArray.count - 1{
            if i <= selStatus{
                if lang == "ar"{
                    imgArray[i].image = UIImage(named: "marroon_circle_flip")
                }else{
                    imgArray[i].image = UIImage(named: "marroon_circle")
                }
            }
            if i == 0{
                continue
            }else{
                if i <= selStatus{
                    lineArray[i - 1].backgroundColor = primaryColor
                }
            }
        }
    }
    
    @IBAction func back(_ sender: Any) {
        dismissViewController()
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
            self.orderItems = searchOrderItems
            self.orderItemList.reloadData()
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text == ""{
            self.getOrders(status: gSelectedOrderStatus)
        }else{
            orderItems = filter(keyword: (textField.text?.lowercased())!)
            if orderItems.isEmpty{
                self.showToast(msg: Language().noresult)
            }
            self.orderItemList.reloadData()
        }
    }
    
    func filter(keyword:String) -> [OrderItem]{
        if keyword == ""{
            return searchOrderItems
        }
        var filtereds = [OrderItem]()
        for item in searchOrderItems{
            if item.orderID.lowercased().contains(keyword){
                filtereds.append(item)
            }else{
                if item.productName.lowercased().contains(keyword){
                    filtereds.append(item)
                }else{
                    if item.contact.lowercased().contains(keyword){
                        filtereds.append(item)
                    }else{
                        if String(item.price).contains(keyword){
                            filtereds.append(item)
                        }else{
                            if item.storeName.contains(keyword){
                                filtereds.append(item)
                            }
                        }
                    }
                }
            }
        }
        return filtereds
    }
    
    func getOrders(status:Int){
        self.orderItems.removeAll()
        self.searchOrderItems.removeAll()
        
        APIs.getOrderItems(member_id: thisUser.idx, handleCallback: {
            orderItems, result_code in
            print(result_code)
            if result_code == "0"{
                for item in orderItems!{
                    if status == 0{
                        if item.status == "placed"{
                            self.orderItems.append(item)
                            self.searchOrderItems.append(item)
                        }
                    }else if status == 1{
                        if item.status == "confirmed"{
                            self.orderItems.append(item)
                            self.searchOrderItems.append(item)
                        }
                    }else if status == 2{
                        if item.status == "prepared"{
                            self.orderItems.append(item)
                            self.searchOrderItems.append(item)
                        }
                    }else if status == 3{
                        if item.status == "ready"{
                            self.orderItems.append(item)
                            self.searchOrderItems.append(item)
                        }
                    }else if status == 4{
                        if item.status == "delivered"{
                            self.orderItems.append(item)
                            self.searchOrderItems.append(item)
                        }
                    }
                }
                
                if self.orderItems.count == 0{
                    self.orderItemList.isHidden = true
                    self.showToast(msg: Language().noresult)
                }else{
                    self.orderItemList.isHidden = false
                }
                
                self.orderItemList.reloadData()
                self.orderItemList.setContentOffset(CGPoint.zero, animated:true)
                
                self.getItemStatus(status: "placed", orderItems: orderItems!)
                self.getItemStatus(status: "confirmed", orderItems: orderItems!)
                self.getItemStatus(status: "prepared", orderItems: orderItems!)
                self.getItemStatus(status: "ready", orderItems: orderItems!)
                self.getItemStatus(status: "delivered", orderItems: orderItems!)
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ReceivedOrderItemCell = tableView.dequeueReusableCell(withIdentifier: "ReceivedOrderItemCell", for: indexPath) as! ReceivedOrderItemCell
        
        let index:Int = indexPath.row
        
        cell.lbl_orderID.text = self.orderItems[index].orderID
        if lang == "ar" {
            cell.lbl_price.text = "QR " + String(self.orderItems[index].price)
        }else{
            cell.lbl_price.text = String(self.orderItems[index].price) + " QR"
        }
        cell.lbl_datetime.text = self.getDateFromTimeStamp(timeStamp: Double(self.orderItems[index].dateTime)!/1000)
        
        cell.lbl_productname.text = self.orderItems[index].productName
        cell.lbl_storename.text = self.orderItems[index].storeName
        if lang == "ar"{
            cell.lbl_quantity.text = String(self.orderItems[index].quantity) + " X"
        }else{
            cell.lbl_quantity.text = "X " + String(self.orderItems[index].quantity)
        }
        cell.lbl_status.text = gOrderStatus.statusStr[self.orderItems[index].status]!
        cell.lbl_phone.text = self.orderItems[index].contact
        
        if self.orderItems[index].pictureUrl != ""{
            self.loadPicture(imageView: cell.img_picture, url: URL(string: self.orderItems[index].pictureUrl)!)
        }
        
        cell.btn_cancel.layer.cornerRadius = 3
        cell.btn_cancel.layer.borderColor = UIColor.lightGray.cgColor
        cell.btn_cancel.layer.borderWidth = 1
        
        cell.btn_cancel.tag = index
        cell.btn_cancel.addTarget(self, action: #selector(cancelOrder), for: .touchUpInside)
        
        if self.orderItems[index].status == "delivered"{
            cell.btn_cancel.isHidden = true
            cell.btn_process.layer.backgroundColor = UIColor.white.cgColor
            cell.btn_process.layer.borderColor = primaryColor.cgColor
            cell.btn_process.layer.borderWidth = 1.5
            cell.btn_process.text(Language().completed)
            cell.btn_process.setTitleColor(primaryColor, for: .normal)
        }else{
            cell.btn_cancel.isHidden = false
            cell.btn_process.layer.backgroundColor = primaryColor.cgColor
            cell.btn_process.layer.borderColor = primaryColor.cgColor
            cell.btn_process.layer.borderWidth = 0
            setRoundShadowButton(button: cell.btn_process, corner: 3)
            cell.btn_process.text(gOrderStatus.nextStatusStr[self.orderItems[index].status]!)
            cell.btn_process.setTitleColor(UIColor.white, for: .normal)
            cell.btn_process.tag = index
            cell.btn_process.addTarget(self, action: #selector(processOrder), for: .touchUpInside)
        }
        
        cell.view_content.tag = index
        var tap = UITapGestureRecognizer(target: self, action: #selector(self.toDetail(_:)))
        cell.view_content.addGestureRecognizer(tap)
        
        cell.view_contact.tag = index
        tap = UITapGestureRecognizer(target: self, action: #selector(self.toContact(_:)))
        cell.view_contact.addGestureRecognizer(tap)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 270.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let item = self.orderItems[indexPath.row]
//
//        let conVC = AppDelegate.currentStoryboard.instantiateViewController(withIdentifier: "OrderDetailViewController")
//        transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
    }
    
    @objc func processOrder(sender : UIButton){
        let item = self.orderItems[sender.tag]
        if item.status != "delivered"{
            let nextStatus = gOrderStatus.nextStatus[item.status]
            APIs.progressOrderItems(member_id: thisUser.idx, item_id: item.idx, next_status: nextStatus!, handleCallback: {
                orderItems, result_code in
                print(result_code)
                if result_code == "0"{
                    gSelectedOrderStatus = gOrderStatus.statusIndex[nextStatus as! String]!
                    self.initPage()
                }else{
                    self.showToast(msg: Language().customerordercanceled)
                    self.initPage()
                }
            })
            
        }
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
            let item = self.orderItems[sender.tag]
            APIs.cancelOrderItem(item_id:item.idx, handleCallback: {
                result_code in
                print(result_code)
                if result_code == "0"{
                    self.showToast(msg: Language().canceled)
                    self.initPage()
                }
            })
        }
        alert.showWarning(Language().warning, subTitle: Language().surecancel)
        
    }
    
    @objc func toDetail(_ sender: UITapGestureRecognizer? = nil) {
        let tag = sender?.view?.tag
        gItem = self.orderItems[tag!]
        
        showLoadingView()
        APIs.getOrderById(order_id: gItem.orderId, handleCallback:{
            order, result_code in
            self.dismissLoadingView()
            print(result_code)
            if result_code == "0"{
                gOrder = order!
                let conVC = AppDelegate.currentStoryboard.instantiateViewController(withIdentifier: "ReceivedOrderDetailViewController")
                conVC.modalPresentationStyle = .fullScreen
                self.transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
            }else{
                self.showToast(msg: Language().serverissue)
            }
        })
    }
    
    @objc func toContact(_ sender: UITapGestureRecognizer? = nil) {
        let tag = sender?.view?.tag
        let item = self.orderItems[tag!]
        self.dialNumber(number: item.contact)
    }
    
    func dialNumber(number : String) {
        if let url = URL(string: "tel://\(number)"),
            UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            // add error message here
        }
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
    
    func loadPicture(imageView:UIImageView, url:URL){
        let processor = DownsamplingImageProcessor(size: imageView.frame.size)
            >> ResizingImageProcessor(referenceSize: imageView.frame.size, mode: .aspectFill)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "appicon.jpg"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
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
