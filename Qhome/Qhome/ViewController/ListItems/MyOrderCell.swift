//
//  MyOrderCell.swift
//  Qhome
//
//  Created by LGH419 on 7/23/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit
import Kingfisher

class MyOrderCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var view_content: UIView!
    @IBOutlet weak var lbl_orderID: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var itemList: UICollectionView!
    @IBOutlet weak var btn_cancel: UIButton!
    @IBOutlet weak var btn_reorder: UIButton!
    
    var orderItems = [OrderItem]()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.itemList.delegate = self
        self.itemList.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:MyOrderItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyOrderItemCell", for: indexPath) as! MyOrderItemCell
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }

}
