//
//  ItemListViewController.swift
//  Qhome
//
//  Created by LGH419 on 7/23/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit
import Kingfisher
import GSImageViewerController

class ItemListViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var view_nav: UIView!    
    @IBOutlet weak var itemList: UITableView!
    
    var cells = [ItemCell]()

    override func viewDidLoad() {
        super.viewDidLoad()

        addShadowToBar(view: view_nav)
        
        itemList.delegate = self
        itemList.dataSource = self
        
        self.itemList.reloadData()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gOrderItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ItemCell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        let index:Int = indexPath.row
        
        if gOrderItems[index].pictureUrl != ""{
            loadPicture(imageView: cell.picture, url: URL(string: gOrderItems[index].pictureUrl)!)
        }
        
        cell.picture.tag = index
        var tap = UITapGestureRecognizer(target: self, action: #selector(self.tappedImage(_:)))
        cell.picture.addGestureRecognizer(tap)
        cell.picture.isUserInteractionEnabled = true
        
        if lang == "ar" {
            cell.lbl_productname.text = gOrderItems[index].productARName
            cell.lbl_storename.text = gOrderItems[index].storeARName
            cell.lbl_price.text = "QR " + String(gOrderItems[index].price)
            cell.lbl_quantity.text = String(gOrderItems[index].quantity) + " X"
        }else{
            cell.lbl_productname.text = gOrderItems[index].productName
            cell.lbl_storename.text = gOrderItems[index].storeName
            cell.lbl_price.text = String(gOrderItems[index].price) + " QR"
            cell.lbl_quantity.text = "X " + String(gOrderItems[index].quantity)
        }
        
        self.cells.append(cell)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    @objc func tappedImage(_ sender: UITapGestureRecognizer? = nil) {
        if let tag = sender?.view?.tag {
            print("Tappped Image: \(tag)")
            let imageStr = gOrderItems[tag].pictureUrl
            
            let url = URL(string: imageStr)
            let data = try? Data(contentsOf: url!)
            let image = UIImage(data: data!)
            
            // transition
            
            let imageInfo   = GSImageInfo(image: image! , imageMode: .aspectFit)
            let transitionInfo = GSTransitionInfo(fromView: self.cells[tag].picture)
            let imageViewer = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
            
            // normal
            
            //            let imageInfo   = GSImageInfo(image: image!, imageMode: .aspectFit)
            //            let imageViewer = GSImageViewerController(imageInfo: imageInfo)
            
            imageViewer.dismissCompletion = {
                print("dismissCompletion")
            }
            
            present(imageViewer, animated: true, completion: nil)
            
        }
    }
    
}
