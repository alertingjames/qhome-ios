//
//  OrderDetailViewController.swift
//  Qhome
//
//  Created by LGH419 on 7/23/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit
import Kingfisher

class OrderDetailViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var view_nav: UIView!
    @IBOutlet weak var lbl_orderID: UILabel!
    @IBOutlet weak var lbl_orderdate: UILabel!
    @IBOutlet weak var lbl_phonenumber: UILabel!
    @IBOutlet weak var lbl_address: UILabel!
    @IBOutlet weak var lbl_addressline: UILabel!
    @IBOutlet weak var itemList: UICollectionView!
    @IBOutlet weak var lbl_total: UILabel!
    @IBOutlet weak var lbl_shipping: UILabel!
    @IBOutlet weak var lbl_subtotal: UILabel!
    
    var orderItems = [OrderItem]()

    override func viewDidLoad() {
        super.viewDidLoad()

        addShadowToBar(view: view_nav)
        
        self.itemList.delegate = self
        self.itemList.dataSource = self
        
        self.lbl_orderID.text = gOrder.orderID
        self.lbl_orderdate.text = String(self.getDateFromTimeStamp(timeStamp: Double(gOrder.dateTime)!/1000))
        self.lbl_phonenumber.text = gOrder.phone_number
        self.lbl_address.text = gOrder.address
        self.lbl_addressline.text = gOrder.addressLine

        var bonus:Float = Float(((gOrder.price - Float(SHIPPING_PRICE)*100/Float(100 - gOrder.discount)))*Float(gOrder.discount)/100)
        
        if lang == "ar"{
            self.lbl_subtotal.text = "QR" + " " + String(Double(gOrder.price - Float(SHIPPING_PRICE) + bonus).roundToDecimal(2))
            self.lbl_shipping.text = "QR" + " " + String(Double(SHIPPING_PRICE).roundToDecimal(2))
            self.lbl_total.text = "QR" + " " + String(Double(gOrder.price).roundToDecimal(2))
        }else{
            self.lbl_subtotal.text = String(Double(gOrder.price - Float(SHIPPING_PRICE) + bonus).roundToDecimal(2)) + " QR"
            self.lbl_shipping.text = String(Double(SHIPPING_PRICE).roundToDecimal(2)) + " QR"
            self.lbl_total.text = String(Double(gOrder.price).roundToDecimal(2)) + " QR"
        }
        
        self.getOrderItems()
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
    
    @IBAction func back(_ sender: Any) {
        dismissViewController()
    }
    
    func getOrderItems(){
        self.orderItems.removeAll()
        for item in gOrder.orderItems{
            self.orderItems.append(item)
        }
        
        if orderItems.count == 0{
            self.itemList.visibility = .gone
        }
        
        self.itemList.reloadData()
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:OrderItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderItemCell", for: indexPath) as! OrderItemCell
        let index:Int = indexPath.row
        cell.img_picture.layer.cornerRadius = 5
        self.loadPicture(imageView: cell.img_picture, url: URL(string: self.orderItems[index].pictureUrl)!)
        if lang == "ar"{
            cell.lbl_quantity.text = String(self.orderItems[index].quantity) + " X"
        }else{
            cell.lbl_quantity.text = "X " + String(self.orderItems[index].quantity)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        gOrderItems = self.orderItems
        let conVC = AppDelegate.currentStoryboard.instantiateViewController(withIdentifier: "ItemListViewController")
        conVC.modalPresentationStyle = .fullScreen
        transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
    }
    
}
