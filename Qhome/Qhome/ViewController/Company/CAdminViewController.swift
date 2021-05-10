//
//  CAdminViewController.swift
//  Qhome
//
//  Created by LGH419 on 10/2/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase
import FirebaseDatabase
import AudioToolbox

class CAdminViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var view_nav: UIView!
    @IBOutlet weak var btn_search: UIButton!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var view_searchbar: UIView!
    @IBOutlet weak var edt_search: UITextField!
    
    @IBOutlet weak var orderItemList: UITableView!
    
    @IBOutlet weak var view_noticount: UIView!
    @IBOutlet weak var lbl_noticount: UILabel!
    @IBOutlet weak var view_notification: UIView!
    
    var notiFrame:NotisViewController!
    
    var orderItems = [OrderItem]()
    var searchOrderItems = [OrderItem]()
    
    var count:Int = 0
    var refs = [DatabaseReference]()

    override func viewDidLoad() {
        super.viewDidLoad()

        gCAdminViewController = self
        
        addShadowToBar(view: view_nav)
        
        view_notification.visibilityh = .gone
        
        notiFrame = self.storyboard!.instantiateViewController(withIdentifier: "NotisViewController") as! NotisViewController
        
        view_noticount.isHidden = true
        
        orderItemList.delegate = self
        orderItemList.dataSource = self
        
        edt_search.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                             for: UIControl.Event.editingChanged)
        
        orderItemList.estimatedRowHeight = 190.0
        orderItemList.rowHeight = UITableView.automaticDimension
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.showNotifications(_:)))
        view_notification.addGestureRecognizer(tap)
        
        self.getAdminNotification()
    }
    
    @objc func showNotifications(_ sender: UITapGestureRecognizer? = nil) {
        self.present(self.notiFrame, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.getComOrders()
    }
    
    @IBAction func back(_ sender: Any) {
        gCAdminViewController = nil
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
            self.getComOrders()
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

    
    func getComOrders(){
        self.orderItems.removeAll()
        self.searchOrderItems.removeAll()
        
        APIs.getComOrderItems(handleCallback: {
            orderItems, result_code in
            print(result_code)
            if result_code == "0"{
                for item in orderItems!{
                    self.orderItems.append(item)
                    self.searchOrderItems.append(item)
                }
                
                if self.orderItems.count == 0{
                    self.orderItemList.isHidden = true
                    self.showToast(msg: Language().noresult)
                }else{
                    self.orderItemList.isHidden = false
                }
                
                self.orderItemList.reloadData()
                self.orderItemList.setContentOffset(CGPoint.zero, animated:true)
                
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:CAdminOrderItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CAdminOrderItemTableViewCell", for: indexPath) as! CAdminOrderItemTableViewCell
        
        let index:Int = indexPath.row
        
        if lang == "ar" {
            cell.lbl_price.text = "QR " + String(self.orderItems[index].price)
        }else{
            cell.lbl_price.text = String(self.orderItems[index].price) + " QR"
        }
        cell.lbl_datetime.text = self.getDateFromTimeStamp(timeStamp: Double(self.orderItems[index].dateTime)!/1000)
        
        cell.lbl_storename.text = self.orderItems[index].storeName
        if lang == "ar"{
            cell.lbl_quantity.text = String(self.orderItems[index].quantity) + " X"
        }else{
            cell.lbl_quantity.text = "X " + String(self.orderItems[index].quantity)
        }
        
        cell.lbl_phone.text = self.orderItems[index].producerContact
        cell.lbl_phone2.text = self.orderItems[index].contact
        
        cell.lbl_comprice.text = self.orderItems[index].compriceStr
        
        
        if self.orderItems[index].pictureUrl != ""{
            self.loadPicture(imageView: cell.img_picture, url: URL(string: self.orderItems[index].pictureUrl)!)
        }
        
        cell.view_content.sizeToFit()
        
        cell.view_content.tag = index
        var tap = UITapGestureRecognizer(target: self, action: #selector(self.toDetail(_:)))
        cell.view_content.addGestureRecognizer(tap)
        
        cell.view_contact.tag = index
        tap = UITapGestureRecognizer(target: self, action: #selector(self.toContact(_:)))
        cell.view_contact.addGestureRecognizer(tap)
        
        cell.view_contact2.tag = index
        tap = UITapGestureRecognizer(target: self, action: #selector(self.toContact2(_:)))
        cell.view_contact2.addGestureRecognizer(tap)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
                let conVC = AppDelegate.currentStoryboard.instantiateViewController(withIdentifier: "CompanyOrderDetailViewController")
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
        self.dialNumber(number: item.producerContact)
    }
    
    @objc func toContact2(_ sender: UITapGestureRecognizer? = nil) {
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
    
    func getAdminNotification(){
        var ref:DatabaseReference!
        ref = Database.database().reference(fromURL: ReqConst.FIREBASE_URL + "company")
        
        ref.observe(.childAdded, with: {(snapshot) -> Void in
            let value = snapshot.value as! [String: Any]
            let timeStamp = value["date"] as! String
            print("TIME!!!\(timeStamp)")
//            let date = self.getDateFromTimeStamp(timeStamp: Double(timeStamp)!)
            var msg = value["msg"] as! String
            let fromid = value["id"] as! String
            let fromname = value["name"] as! String
            let fromphone = value["phone"] as! String
            let fromaddress = value["address"] as! String
            self.count += 1
            gBadgeCount = self.count
            self.view_notification.visibilityh = .visible
            self.view_noticount.isHidden = false
            self.lbl_noticount.text = String(gBadgeCount)
            UIApplication.shared.applicationIconBadgeNumber = self.count
            AudioServicesPlaySystemSound(SystemSoundID(1106))
            
            msg = msg + "\n" + "Customer ID: " + fromid + "\n" + "Customer Name: " + fromname + "\n" + "Phone: " + fromphone + "\n" + "Address: " + fromaddress
            
            let noti = Notification()
            noti.sender_id = Int64(fromid)!
            noti.sender_name = fromname
            noti.message = msg
            noti.date_time = timeStamp

            self.notiFrame.notis.insert(noti, at: 0)
            
            self.refs.insert(snapshot.ref, at: 0)
            
        })
    }

}















































