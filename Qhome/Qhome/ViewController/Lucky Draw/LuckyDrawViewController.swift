//
//  LuckyDrawViewController.swift
//  Qhome
//
//  Created by LGH419 on 7/24/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit
import SwiftGifOrigin

class LuckyDrawViewController: BaseViewController {
    
    @IBOutlet weak var view_draw: UIView!
    @IBOutlet weak var view_gif: UIImageView!
    @IBOutlet weak var lbl_cap: UILabel!
    var status:String = ""
    var winner:String = ""
    var rotationAnimation:CABasicAnimation!
    @IBOutlet weak var lbl_info: UILabel!
    @IBOutlet weak var lbl_won: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setRoundOrangeShadowView(view: view_draw, corner: self.view_draw.frame.size.height/2)
        self.view_gif.isHidden = true
        self.lbl_info.isHidden = true
        self.lbl_cap.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width/25)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.drawing(_:)))
        self.view_draw.addGestureRecognizer(tap)
        
    }
    
    @objc func drawing(_ sender: UITapGestureRecognizer? = nil) {
        if self.status == "info_exists"{
            self.showToast(msg: Language().info_exists)
            return
        }
        if self.status == "winner_exists"{
            self.showToast(msg: Language().sorry + self.winner + " " + Language().winner_exists)
            return
        }
        if self.status == "you_won"{
            return
        }
        
        self.rotate(uiview: view_draw, aCircleTime: 1.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            APIs.postLuckyInfo(member_id:thisUser.idx, handleCallback:{
                result, result_code in
                print(result_code)
                self.stopRotating(uiView: self.view_draw)
                if result_code == "0"{
                    self.showToast(msg: Language().info_submited)
                    self.view_gif.isHidden = false
                    self.view_gif.image = UIImage.gif(name: "comingsoon")
                    self.status = "info_exists"
                }else if result_code == "1" {
                    self.winner = result
                    self.status = "winner_exists"
                    self.lbl_info.isHidden = false
                    self.lbl_info.text = Language().sorry + " " + self.winner + " " + Language().winner_exists
                }

            })
        }
        
    }
    @IBAction func back(_ sender: Any) {
        dismissViewController()
    }
    
    func setRoundOrangeShadowView(view:UIView, corner:CGFloat){
        view.layer.cornerRadius = corner
        view.layer.shadowRadius = 2.0
        view.layer.shadowColor = UIColor.orange.cgColor
        view.layer.shadowOffset = CGSize.init(width: 1.0, height: 1.0)
        view.layer.shadowOpacity = 0.2
    }
    
    func rotate(uiview: UIView, aCircleTime: Double) { //CABasicAnimation
        rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = Double.pi * 2 //Minus can be Direction
        rotationAnimation.duration = aCircleTime
        rotationAnimation.repeatCount = .infinity
        uiview.layer.add(rotationAnimation, forKey: nil)
    }
    
    func stopRotating(uiView:UIView) {
        if self.rotationAnimation != nil{
            uiView.layer.removeAllAnimations()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getInfo(member_id: thisUser.idx)
    }
    
    func getInfo(member_id:Int64)
    {
        APIs.getMyLuckyInfo(member_id:member_id, handleCallback:{
            result, result_code in
            print(result_code)
            if result_code == "0"{
                self.lbl_info.isHidden = true
            }else if result_code == "1" {
                if result == "won"{
                    self.status = "you_won"
                    self.view_gif.isHidden = false
                    self.view_gif.image = UIImage.gif(name: "congratulations")
                    self.lbl_won.isHidden = false
                }else{
                    self.status = "info_exists"
                    self.view_gif.isHidden = false
                    self.view_gif.image = UIImage.gif(name: "comingsoon")
                }
            }else if result_code == "2" {
                self.winner = result
                self.status = "winner_exists"
                self.lbl_info.isHidden = false
                self.lbl_info.text = Language().sorry + " " + self.winner + " " + Language().winner_exists
            }
            
        })
    }

}
