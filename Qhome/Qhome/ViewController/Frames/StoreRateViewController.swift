//
//  StoreRateViewController.swift
//  Qhome
//
//  Created by LGH419 on 7/18/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit
import Cosmos
import Kingfisher

class StoreRateViewController: BaseViewController {
    
    @IBOutlet weak var img_logo: UIImageView!
    @IBOutlet weak var ratingbar1: CosmosView!
    @IBOutlet weak var lbl_reviews: UILabel!
    
    @IBOutlet weak var txt_subject: UITextView!
    @IBOutlet weak var ratingbar2: CosmosView!
    @IBOutlet weak var txt_desc: UITextView!
    @IBOutlet weak var btn_submit: UIButton!
    @IBOutlet weak var lbl_cap: UILabel!
    
    var language:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        img_logo.layer.cornerRadius = 10
        setRoundShadowButton(button: btn_submit, corner: 25)
        
        ratingbar1.rating = Double(gStore.ratings)
        ratingbar1.text = String(gStore.ratings)
        ratingbar1.settings.updateOnTouch = false
        lbl_reviews.text = String(gStore.reviews)
        
        ratingbar1.settings.fillMode = .precise
        self.loadPicture(imageView: img_logo, url: URL(string: gStore.logoUrl)!)
        
        txt_desc.delegate = self
        txt_desc.layer.cornerRadius = 3
        txt_desc.layer.borderWidth = 1
        txt_desc.layer.borderColor = UIColor(rgb: 0xd9d9d9, alpha: 0.8).cgColor
        txt_desc.setPlaceholder(string: Language().write_feedback)
        txt_desc.textContainerInset = UIEdgeInsets(top: 8, left: 4, bottom: 50, right: 4)
        
        txt_subject.layer.cornerRadius = 3
        txt_subject.layer.borderWidth = 1
        txt_subject.layer.borderColor = UIColor(rgb: 0xd9d9d9, alpha: 0.8).cgColor
        
        let fixedWidth = self.txt_desc.frame.size.width
        self.txt_desc.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = self.txt_desc.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = self.txt_desc.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        self.txt_desc.frame = newFrame
        
        ratingbar2.settings.updateOnTouch = true
        ratingbar2.settings.fillMode = .precise
        ratingbar2.didFinishTouchingCosmos = {
            rating in
            self.ratingbar2.rating = Double(rating).roundToDecimal(1)
            self.ratingbar2.text = String(Double(rating).roundToDecimal(1))
        }
        ratingbar2.didTouchCosmos = {
            rating in
            self.ratingbar2.rating = Double(rating).roundToDecimal(1)
            self.ratingbar2.text = String(Double(rating).roundToDecimal(1))
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getRatings()
    }
    
    func getRatings(){
        self.showLoadingView()
        APIs.getRatings(store_id: gStore.idx, handleCallback: {
            ratings, result_code in
            print(result_code)
            self.dismissLoadingView()
            if result_code == "0"{
                for rating in ratings!{
                    if rating.storeId == gStore.idx && rating.userId == thisUser.idx{
                        self.txt_subject.text = rating.subject
                        self.ratingbar2.rating = rating.rating
                        self.ratingbar2.text = String(rating.rating)
                        self.txt_desc.text = rating.description
                        if rating.description != ""{
                            self.txt_desc.checkPlaceholder()
                        }
                        self.lbl_cap.text = Language().updatefeedbackinstore
                        if rating.lang == "ar"{
                            self.txt_subject.textAlignment = .right
                            self.txt_desc.textAlignment = .right
                        }else{
                            self.txt_subject.textAlignment = .left
                            self.txt_desc.textAlignment = .left
                        }
                        
                        self.language = rating.lang
                        return
                    }
                    
                    let index = ratings!.firstIndex{$0 === rating}
                    
                    if index == ratings!.count - 1 {
                        self.lbl_cap.text = Language().placefeedbackinstore
                    }
                }
            }
        })
    }
    
    func textViewDidChange(_ textView: UITextView) { //Handle the text changes here
        textView.checkPlaceholder()
        if textView.text == ""{
            textView.textContainerInset = UIEdgeInsets(top: 8, left: 4, bottom: 50, right: 4)
        }else{
            if textView.contentSize.height > 100{
                textView.textContainerInset = UIEdgeInsets(top: 8, left: 4, bottom: 15, right: 4)
            }else{
                textView.textContainerInset = UIEdgeInsets(top: 8, left: 4, bottom: 50, right: 4)
            }
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
    

    @IBAction func submit(_ sender: Any) {
        if self.txt_subject.text == ""{
            showToast(msg: Language().writesubject)
            return
        }
        
        if self.ratingbar2.rating == 0{
            showToast(msg: Language().rateoutstars)
            return
        }
        
        if self.txt_desc.text == ""{
            showToast(msg: Language().write_feedback)
            return
        }
        
        var lan = ""
        if self.language == ""{
            lan = lang
        }else{
            lan = self.language
        }
        
        self.showLoadingView()
        APIs.submitRate(
            member_id:thisUser.idx,
            store_id: gStore.idx,
            subject: self.txt_subject.text,
            rating: self.ratingbar2.rating,
            description: self.txt_desc.text,
            lang:lan,
            handleCallback: {
            lratings, lreviews, llang, result_code in
            print(result_code)
            self.dismissLoadingView()
            if result_code == "0"{
                self.showToast(msg: Language().feedbacksubmited)
                self.ratingbar1.rating = Double(lratings)!
                self.ratingbar1.text = lratings
                self.lbl_reviews.text = lreviews
                self.lbl_cap.text = Language().updatefeedbackinstore
                gStore.ratings = Float(lratings)!
                gStore.reviews = Int64(lreviews)!
                self.language = llang
            }
        })
        
        
    }
    
    
    
}
