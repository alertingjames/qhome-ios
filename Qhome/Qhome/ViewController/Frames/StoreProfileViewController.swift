//
//  StoreProfileViewController.swift
//  Qhome
//
//  Created by LGH419 on 7/17/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit
import Cosmos
import Kingfisher

class StoreProfileViewController: BaseViewController {
    
    @IBOutlet weak var img_logo: UIImageView!
    @IBOutlet weak var lbl_store_name: UILabel!
    @IBOutlet weak var lbl_category: UILabel!
    @IBOutlet weak var txt_description: UITextView!
    @IBOutlet weak var ratingbar: CosmosView!
    @IBOutlet weak var lbl_likes: UILabel!
    @IBOutlet weak var btn_instagram: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var img_naql: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        img_logo.layer.cornerRadius = 10
        ratingbar.rating = Double(gStore.ratings)
        ratingbar.text = String(gStore.ratings)
        ratingbar.settings.updateOnTouch = false
        lbl_likes.text = String(gStore.likes)
    
        ratingbar.settings.fillMode = .precise
        
        loadPicture(imageView: img_logo, url: URL(string: gStore.logoUrl)!)
        if lang == "ar"{
            lbl_store_name.text = gStore.arName
            txt_description.text = gStore.arDescription
            if gStore.arCategory2 == ""{
                lbl_category.text = gStore.arCategory
            }else{
                lbl_category.text = gStore.arCategory + ", " + gStore.arCategory2
            }
        }else{
            lbl_store_name.text = gStore.name
            txt_description.text = gStore.description
            if gStore.category2 == ""{
                lbl_category.text = gStore.category
            }else{
                lbl_category.text = gStore.category + ", " + gStore.category2
            }
        }
        
        let fixedWidth = self.txt_description.frame.size.width
        self.txt_description.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = self.txt_description.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = self.txt_description.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        self.txt_description.frame = newFrame
        
        // Called when user finishes changing the rating by lifting the finger from the view.
        // This may be a good place to save the rating in the database or send to the server.
        ratingbar.didFinishTouchingCosmos = { rating in }
        
        // A closure that is called when user changes the rating by touching the view.
        // This can be used to update UI as the rating is being changed by moving a finger.
        ratingbar.didTouchCosmos = { rating in }
        
        if gStore.priceId > 0{
            img_naql.visibility = .visible
        }else{
            img_naql.visibility = .gone
        }
        
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
    
    @IBAction func toInstagram(_ sender: Any) {
        self.getProducerInstagram(member_id: gStore.userId)
    }
    
    func getProducerInstagram(member_id: Int64){
        self.showLoadingView()
        APIs.getProducerInstagram(member_id: member_id, handleCallback: {
            instagram_username, result_code in
            self.dismissLoadingView()
            if result_code == "0"{
                let Username =  instagram_username // Instagram Username here
                let appURL = URL(string: "instagram://user?username=\(Username)")!
                let application = UIApplication.shared
                
                if application.canOpenURL(appURL) {
                    application.open(appURL)
                } else {
                    // if Instagram app is not installed, open URL inside Safari
                    let webURL = URL(string: "https://instagram.com/\(Username)")!
                    application.open(webURL)
                }
            }
        })
    }
    
}
