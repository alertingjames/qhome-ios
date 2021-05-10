//
//  CompanyOrderDetailViewController.swift
//  Qhome
//
//  Created by LGH419 on 10/8/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit
import Kingfisher
import SCLAlertView

class CompanyOrderDetailViewController: BaseViewController{
    
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
    
    @IBOutlet weak var lbl_phonenumber2: UILabel!
    @IBOutlet weak var view_contact2: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addShadowToBar(view: view_nav)
        
        img_product.layer.cornerRadius = 5
        
        self.lbl_orderID.text = gOrder.orderID
        self.lbl_orderdate.text = self.getDateFromTimeStamp(timeStamp: Double(gOrder.dateTime)!/1000)
        self.lbl_phonenumber.text = gItem.contact
        self.lbl_phonenumber2.text = gItem.producerContact
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
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.toContact2(_:)))
        self.view_contact2.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.toProductDetail(_:)))
        self.view_items.addGestureRecognizer(tap)
        
    }

    
    @objc func toContact(_ sender: UITapGestureRecognizer? = nil) {
        self.dialNumber(number: gItem.contact)
    }
    
    @objc func toContact2(_ sender: UITapGestureRecognizer? = nil) {
        self.dialNumber(number: gItem.producerContact)
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
    
    
}
