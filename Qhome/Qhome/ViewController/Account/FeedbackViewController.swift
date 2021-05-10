//
//  FeedbackViewController.swift
//  Qhome
//
//  Created by LGH419 on 7/21/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit
import Cosmos
import Kingfisher

class FeedbackViewController: BaseViewController {
    
    @IBOutlet weak var view_nav: UIView!
    @IBOutlet weak var img_logo: UIImageView!
    @IBOutlet weak var ratingbar: CosmosView!
    @IBOutlet weak var lbl_reviews: UILabel!    
    @IBOutlet weak var txt_subject: UITextView!
    @IBOutlet weak var txt_desc: UITextView!
    @IBOutlet weak var btn_submit: UIButton!
    @IBOutlet weak var view_logo: UIView!
    @IBOutlet weak var lbl_cap: UILabel!
    
    var ratings = [Rating]()
    var language:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addShadowToBar(view: view_nav)
        setRoundShadowButton(button: btn_submit, corner: 25)
        img_logo.layer.cornerRadius = img_logo.frame.height/2
        setRoundShadowView(view: view_logo, corner: img_logo.frame.height/2)
        
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
        
        ratingbar.settings.updateOnTouch = true
        ratingbar.settings.fillMode = .precise
        ratingbar.didFinishTouchingCosmos = {
            rating in
            self.ratingbar.rating = Double(rating).roundToDecimal(1)
            self.ratingbar.text = String(Double(rating).roundToDecimal(1))
        }
        ratingbar.didTouchCosmos = {
            rating in
            self.ratingbar.rating = Double(rating).roundToDecimal(1)
            self.ratingbar.text = String(Double(rating).roundToDecimal(1))
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getRatings()
    }
    
    func getRatings(){
        
        ratings.removeAll()
        
        self.showLoadingView()
        APIs.getRatings(store_id: 0, handleCallback: {
            ratings, result_code in
            print(result_code)
            self.dismissLoadingView()
            if result_code == "0"{
                var rts:Double = 0.0
                for rating in ratings!{
                    self.ratings.append(rating)
                    rts = rts + rating.rating
                }
                var reviews = 0
                var ratingVal:Double = 0.0
                if self.ratings.count > 0{
                    reviews = self.ratings.count
                    ratingVal = rts/Double(reviews)
                }
                
                self.lbl_reviews.text = String(reviews)
                
                for rating in self.ratings{
                    if rating.storeId == 0 && rating.userId == thisUser.idx{
                        self.txt_subject.text = rating.subject
                        self.ratingbar.rating = rating.rating
                        self.ratingbar.text = String(rating.rating)
                        self.txt_desc.text = rating.description
                        self.lbl_cap.text = Language().updatefeedbackinapp
                        
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
                        self.lbl_cap.text = Language().placefeedbackinapp
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
    
    @IBAction func back(_ sender: Any) {
        dismissViewController()
    }
    
    @IBAction func submit(_ sender: Any) {
        
        if self.txt_subject.text == ""{
            showToast(msg: Language().writesubject)
            return
        }
        
        if self.ratingbar.rating == 0{
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
        APIs.submitAppRate(
            member_id:thisUser.idx,
            store_id: 0,
            subject: self.txt_subject.text,
            rating: self.ratingbar.rating,
            description: self.txt_desc.text,
            lang:lan,
            handleCallback: {
                result_code in
                print(result_code)
                self.dismissLoadingView()
                if result_code == "0"{
                    self.showToast(msg: Language().feedbacksubmited)
                    self.getRatings()
                }
        })
        
    }
    
}
