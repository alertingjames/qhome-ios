//
//  MyStoreRatingsViewController.swift
//  Qhome
//
//  Created by LGH419 on 7/18/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit
import Cosmos

class MyStoreRatingsViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var ratingsList: UITableView!
    @IBOutlet weak var lbl_reviews: UILabel!
    @IBOutlet weak var ratingbar: CosmosView!
    var ratings = [Rating]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if gMyStoreDetailViewController != nil{
            if lang == "ar"{
                gMyStoreDetailViewController!.lbl_title.text = gStore.arName
            }else{
                gMyStoreDetailViewController!.lbl_title.text = gStore.name
            }
        }

        ratingsList.delegate = self
        ratingsList.dataSource = self
        
        ratingsList.estimatedRowHeight = 120
        ratingsList.rowHeight = UITableView.automaticDimension
        
        self.ratingbar.rating = Double(gStore.ratings)
        self.ratingbar.text = String(gStore.ratings)
        self.lbl_reviews.text = String(gStore.reviews)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getRatings()
    }
    
    func getRatings(){
        
        ratings.removeAll()
        
        self.showLoadingView()
        APIs.getRatings(store_id: gStore.idx, handleCallback: {
            ratings, result_code in
            print(result_code)
            self.dismissLoadingView()
            if result_code == "0"{
                for rating in ratings!{
                    self.ratings.append(rating)
                }
                if self.ratings.count == 0{
                    self.ratingsList.isHidden = true
                    self.showToast(msg: Language().noresult)
                }else{
                    self.ratingsList.isHidden = false
                }
                
                self.lbl_reviews.text = String(self.ratings.count)
                
                self.ratingsList.reloadData()
            }
        })
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ratings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:RatingItemCell = tableView.dequeueReusableCell(withIdentifier: "RatingItemCell", for: indexPath) as! RatingItemCell
        
        let index:Int = indexPath.row
        
        setCircularShadowImage(image: cell.img_user, corner: cell.img_user.frame.height/2)
        cell.lbl_username.text = self.ratings[index].userName
        cell.txt_desc.text = self.ratings[index].subject + "\n" + self.ratings[index].description
        cell.lbl_date.text = self.getDateFromTimeStamp(timeStamp: Double(self.ratings[index].date)!/1000)
        cell.ratingbar.rating = self.ratings[index].rating
        cell.ratingbar.text = String(self.ratings[index].rating)
        cell.ratingbar.settings.updateOnTouch = false
        cell.ratingbar.settings.fillMode = .precise
        cell.view_content.sizeToFit()
        cell.txt_desc.sizeToFit()
        cell.view_content.layoutIfNeeded()
        
        return cell
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
    
    func setCircularShadowImage(image:UIImageView, corner:CGFloat){
        image.layer.cornerRadius = corner
        image.layer.shadowRadius = 2.0
        image.layer.shadowColor = UIColor.black.cgColor
        image.layer.shadowOffset = CGSize.init(width: 1.0, height: 1.0)
        image.layer.shadowOpacity = 0.2
    }

}
