//
//  ReceivedOrderDetailViewController.swift
//  Qhome
//
//  Created by LGH419 on 7/24/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit
import Kingfisher
import SCLAlertView

class ReceivedOrderDetailViewController: BaseViewController{
    
    @IBOutlet weak var view_nav: UIView!
    @IBOutlet weak var lbl_orderID: UILabel!
    @IBOutlet weak var lbl_orderdate: UILabel!
    @IBOutlet weak var lbl_phonenumber: UILabel!
    @IBOutlet weak var lbl_address: UILabel!
    @IBOutlet weak var lbl_addressline: UILabel!
    @IBOutlet weak var lbl_total: UILabel!
    @IBOutlet weak var lbl_shipping: UILabel!
    @IBOutlet weak var lbl_subtotal: UILabel!
    @IBOutlet weak var img_product: UIImageView!
    @IBOutlet weak var lbl_productname: UILabel!
    @IBOutlet weak var lbl_storename: UILabel!
    @IBOutlet weak var lbl_category: UILabel!
    @IBOutlet weak var lbl_quantity: UILabel!
    @IBOutlet weak var lbl_status: UILabel!
    @IBOutlet weak var view_items: UIView!
    @IBOutlet weak var view_contact: UIView!
    @IBOutlet weak var view_status_legend: UIView!
    @IBOutlet weak var view_track_frame: UIView!
    @IBOutlet weak var view_button_frame: UIView!
    
    
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img4: UIImageView!
    @IBOutlet weak var img5: UIImageView!
    @IBOutlet weak var line1: UIView!
    @IBOutlet weak var line2: UIView!
    @IBOutlet weak var line3: UIView!
    @IBOutlet weak var line4: UIView!
    
    @IBOutlet weak var btn_cancel: UIButton!
    @IBOutlet weak var btn_process: UIButton!

    var imgArray = [UIImageView]()
    var lineArray = [UIView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addShadowToBar(view: view_nav)
        
        img_product.layer.cornerRadius = 5
        btn_cancel.layer.cornerRadius = 3
        btn_cancel.layer.borderColor = UIColor.lightGray.cgColor
        btn_cancel.layer.borderWidth = 1
        setRoundShadowButton(button: btn_process, corner: 3)
        
        self.lbl_orderID.text = gOrder.orderID
        self.lbl_orderdate.text = self.getDateFromTimeStamp(timeStamp: Double(gOrder.dateTime)!/1000)
        self.lbl_phonenumber.text = gItem.contact
        self.loadPicture(imageView: img_product, url: URL(string: gItem.pictureUrl)!)
        if lang == "ar"{
            self.lbl_productname.text = gItem.productARName
            self.lbl_storename.text = gItem.storeARName
            self.lbl_category.text = gItem.arCategory
            self.lbl_quantity.text = String(gItem.quantity) + " X"
        }else{
            self.lbl_productname.text = gItem.productName
            self.lbl_storename.text = gItem.storeName
            self.lbl_category.text = gItem.category
            self.lbl_quantity.text = "X " + String(gItem.quantity)
        }
        
        self.lbl_status.text = gOrderStatus.statusStr[gItem.status]!
        self.btn_process.setTitle(gOrderStatus.nextStatusStr[gItem.status], for: .normal)
        
        if gSelectedOrderStatus == 4{
            self.btn_cancel.isHidden = true
            self.btn_process.backgroundColor = UIColor.white
            self.btn_process.layer.borderWidth = 1.5
            self.btn_process.layer.borderColor = primaryColor.cgColor
            self.btn_process.setTitleColor(primaryColor, for: .normal)
            self.btn_process.setTitle(Language().completed, for: .normal)
        }
        
        self.lbl_phonenumber.text = gOrder.phone_number
        self.lbl_address.text = gOrder.address
        self.lbl_addressline.text = gOrder.addressLine
        
        var bonus:Float = Float(gItem.price * Float(gItem.quantity)) * Float(gItem.discount/100)
        
        if lang == "ar"{
            self.lbl_subtotal.text = "QR" + " " + String(Double(gItem.price * Float(gItem.quantity) + bonus).roundToDecimal(2))
            self.lbl_shipping.text = "QR" + " " + String(Double(SHIPPING_PRICE).roundToDecimal(2))
            self.lbl_total.text = "QR" + " " + String(Double(gItem.price * Float(gItem.quantity) + gOrder.shipping * Float(gItem.quantity)/Float(gOrder.orderItems.count)).roundToDecimal(2))
        }else{
            self.lbl_subtotal.text = String(Double(gItem.price * Float(gItem.quantity) + bonus).roundToDecimal(2)) + " QR"
            self.lbl_shipping.text = String(Double(SHIPPING_PRICE).roundToDecimal(2)) + " QR"
            self.lbl_total.text = String(Double(gItem.price * Float(gItem.quantity) + gOrder.shipping * Float(gItem.quantity)/Float(gOrder.orderItems.count)).roundToDecimal(2)) + " QR"
        }
        
        var tap = UITapGestureRecognizer(target: self, action: #selector(self.toContact(_:)))
        self.view_contact.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.toProductDetail(_:)))
        self.view_items.addGestureRecognizer(tap)
        
        self.appearTrackFrame(selStatus: gSelectedOrderStatus)
        
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
    
    @objc func toContact(_ sender: UITapGestureRecognizer? = nil) {
        self.dialNumber(number: gItem.contact)
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
    
    @objc func toProductDetail(_ sender: UITapGestureRecognizer? = nil) {
        
        APIs.getProduct(product_id: gItem.productId, imei_id: gIMEI, handleCallback:{
            product, result_code in
            print(result_code)
            if result_code == "0"{
                gProduct = product!
                gProductOption = "order"
                let conVC = AppDelegate.currentStoryboard.instantiateViewController(withIdentifier: "PDetailViewController")
                conVC.modalPresentationStyle = .fullScreen
                self.transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
            }
        })
    }
    
    @IBAction func back(_ sender: Any) {
        dismissViewController()
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
    
    func getDateFromTimeStamp(timeStamp : Double) -> String {
        
        let date = NSDate(timeIntervalSince1970: timeStamp)
        
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "dd MMM YY, hh:mm a"
        // UnComment below to get only time
        //  dayTimePeriodFormatter.dateFormat = "hh:mm a"
        
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        return dateString
    }
    
    @IBAction func cancelOrder(_ sender: Any) {
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: true
        )
        let alert = SCLAlertView(appearance: appearance)
        alert.addButton(Language().yes) {
            APIs.cancelOrderItem(item_id:gItem.idx, handleCallback: {
                result_code in
                print(result_code)
                if result_code == "0"{
                    self.showToast(msg: Language().canceled)
                    self.dismissViewController()
                }
            })
        }
        alert.showWarning(Language().warning, subTitle: Language().surecancel)
    }
    
    @IBAction func processOrder(_ sender: Any) {
        if gSelectedOrderStatus != 4{
            let nextStatus = gOrderStatus.nextStatus[gItem.status]
            APIs.progressOrderItems(member_id: thisUser.idx, item_id: gItem.idx, next_status: nextStatus!, handleCallback: {
                orderItems, result_code in
                print(result_code)
                if result_code == "0"{
                    for item in orderItems!{
                        if item.idx == gItem.idx{
                            gItem = item
                            self.appearTrackFrame(selStatus: gOrderStatus.statusIndex[item.status]!)
                            self.lbl_status.text = gOrderStatus.statusStr[item.status]!
                            self.btn_process.setTitle(gOrderStatus.nextStatusStr[item.status], for: .normal)
                            if item.status == "delivered"{
                                self.btn_cancel.isHidden = true
                                self.btn_process.backgroundColor = UIColor.white
                                self.btn_process.layer.borderWidth = 1.5
                                self.btn_process.layer.borderColor = primaryColor.cgColor
                                self.btn_process.setTitleColor(primaryColor, for: .normal)
                                self.btn_process.setTitle(Language().completed, for: .normal)
                            }
                            return
                        }
                    }
                }else{
                    self.showToast(msg: Language().customerordercanceled)
                    self.dismissViewController()
                }
            })
        }
    }
    
    
}
