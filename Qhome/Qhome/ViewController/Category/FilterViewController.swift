//
//  FilterViewController.swift
//  Qhome
//
//  Created by LGH419 on 7/17/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit
import MultiSlider

class FilterViewController: BaseViewController {
    
    @IBOutlet weak var view_nav: UIView!
    @IBOutlet weak var btn_noapply: UIButton!
    @IBOutlet weak var btn_apply: UIButton!
    @IBOutlet weak var view_slider: UIView!
    @IBOutlet weak var btn_favorites: UIButton!
    @IBOutlet weak var btn_wishlist: UIButton!
    @IBOutlet weak var view_priceup: UIView!
    @IBOutlet weak var view_pricedown: UIView!
    @IBOutlet weak var view_nameasc: UIView!
    @IBOutlet weak var view_namedesc: UIView!
    @IBOutlet weak var lbl_priceup: UILabel!
    @IBOutlet weak var lbl_pricedown: UILabel!
    @IBOutlet weak var lbl_nameasc: UILabel!
    @IBOutlet weak var lbl_namedesc: UILabel!
    @IBOutlet weak var lbl_min: UILabel!
    @IBOutlet weak var lbl_max: UILabel!
    @IBOutlet weak var img_priceup: UIImageView!
    @IBOutlet weak var img_pricedown: UIImageView!
    @IBOutlet weak var img_nameasc: UIImageView!
    @IBOutlet weak var img_namedesc: UIImageView!
    
    var minPrice:Int64 = 0
    var maxPrice:Int64 = 0
    var priceSort:Int = 0
    var nameSort:Int = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()

        addShadowToBar(view: view_nav)

        setRoundShadowButton(button: btn_noapply, corner: 25)
        setRoundShadowButton(button: btn_apply, corner: 25)
        
        btn_favorites.layer.cornerRadius = 25
        btn_favorites.layer.borderWidth = 1.5
        btn_favorites.layer.borderColor = primaryColor.cgColor
        
        btn_wishlist.layer.cornerRadius = 25
        btn_wishlist.layer.borderWidth = 1.5
        btn_wishlist.layer.borderColor = primaryColor.cgColor
        
        let slider   = MultiSlider()
        
        slider.frame = CGRect(x: 0, y: 0, width: screenWidth - 60, height: slider.frame.height)
        view_slider.addSubview(slider)
        
        slider.orientation = .horizontal
//        slider.valueLabelPosition = .left // .notAnAttribute = don't show labels
//        slider.isValueLabelRelative = true // show differences between thumbs instead of absolute values
//        slider.valueLabelFormatter.positiveSuffix = " QR"
        
        slider.snapStepSize = 1.0 // default is 0.0, i.e. don't snap
        slider.outerTrackColor = .green
        slider.tintColor = primaryColor
        slider.trackWidth = 2
        slider.hasRoundTrackEnds = true
        slider.showsThumbImageShadow = false // wide tracks look better without thumb shadow
        
        slider.thumbImage   = UIImage(named: "green_circle")
        slider.minimumImage = UIImage(named: "green_circle")
        slider.maximumImage = UIImage(named: "green_circle")
        
        slider.minimumValue = 0    // default is 0.0
        slider.maximumValue = 1000    // default is 1.0
        
        minPrice = gMinPrice
        if gMaxPrice > 1000{
            maxPrice = 1000
        }else{
            maxPrice = gMaxPrice
        }
        
        lbl_min.text = String(minPrice)
        lbl_max.text = String(maxPrice)
        if maxPrice == 1000{
            lbl_max.text = "1k QR"
        }
        
        slider.value = [CGFloat(minPrice), CGFloat(maxPrice)]
        
        slider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged) // continuous changes
        slider.addTarget(self, action: #selector(sliderDragEnded), for: . touchUpInside) // sent when drag ends
        
        resetPriceButtons()
        resetNameButtons()
        
        var tap = UITapGestureRecognizer(target: self, action: #selector(self.priceUp(_:)))
        view_priceup.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.priceDown(_:)))
        view_pricedown.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.nameAsc(_:)))
        view_nameasc.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.nameDesc(_:)))
        view_namedesc.addGestureRecognizer(tap)
        
        if gPriceSort == 0{
            self.resetPriceButtons()
        }else if gPriceSort == 1{
            self.priceUp()
        }else if gPriceSort == 2{
            self.priceDown()
        }
        
        if gNameSort == 0{
            self.resetNameButtons()
        }else if gNameSort == 1{
            self.nameAsc()
        }else if gNameSort == 2{
            self.nameDesc()
        }
        
    }
    
    @objc func priceUp(_ sender: UITapGestureRecognizer? = nil) {
        self.priceUp()
    }
    
    func priceUp(){
        resetPriceButtons()
        view_priceup.layer.cornerRadius = 23
        view_priceup.layer.borderWidth = 1.5
        view_priceup.layer.borderColor = primaryColor.cgColor
        view_priceup.layer.backgroundColor = primaryColor.cgColor
        lbl_priceup.textColor = UIColor.white
        img_priceup.image = img_priceup.image?.imageWithColor(color1: UIColor.white)
        priceSort = 1
    }
    
    @objc func priceDown(_ sender: UITapGestureRecognizer? = nil) {
        self.priceDown()
    }
    
    func priceDown(){
        resetPriceButtons()
        view_pricedown.layer.cornerRadius = 23
        view_pricedown.layer.borderWidth = 1.5
        view_pricedown.layer.borderColor = primaryColor.cgColor
        view_pricedown.layer.backgroundColor = primaryColor.cgColor
        lbl_pricedown.textColor = UIColor.white
        img_pricedown.image = img_pricedown.image?.imageWithColor(color1: UIColor.white)
        priceSort = 2
    }
    
    @objc func nameAsc(_ sender: UITapGestureRecognizer? = nil) {
        self.nameAsc()
    }
    
    func nameAsc(){
        resetNameButtons()
        view_nameasc.layer.cornerRadius = 23
        view_nameasc.layer.borderWidth = 1.5
        view_nameasc.layer.borderColor = primaryColor.cgColor
        view_nameasc.layer.backgroundColor = primaryColor.cgColor
        lbl_nameasc.textColor = UIColor.white
        img_nameasc.image = img_nameasc.image?.imageWithColor(color1: UIColor.white)
        nameSort = 1
    }
    
    @objc func nameDesc(_ sender: UITapGestureRecognizer? = nil) {
        self.nameDesc()
    }
    
    func nameDesc(){
        resetNameButtons()
        view_namedesc.layer.cornerRadius = 23
        view_namedesc.layer.borderWidth = 1.5
        view_namedesc.layer.borderColor = primaryColor.cgColor
        view_namedesc.layer.backgroundColor = primaryColor.cgColor
        lbl_namedesc.textColor = UIColor.white
        img_namedesc.image = img_namedesc.image?.imageWithColor(color1: UIColor.white)
        nameSort = 2
    }
    
    @objc func sliderChanged(slider: MultiSlider) {
        print("slided: \(slider.value)") // e.g., [1.0, 4.5, 5.0]
        lbl_min.text = String(Int64(slider.value[0])) + " QR"
        lbl_max.text = String(Int64(slider.value[1])) + " QR"
        if Int64(slider.value[1]) == 1000{
            lbl_max.text = "1k QR"
        }
    }
    
    @objc func sliderDragEnded(slider: MultiSlider) {
        print("dragged: \(slider.value)") // e.g., [1.0, 4.5, 5.0]
        minPrice = Int64(slider.value[0])
        maxPrice = Int64(slider.value[1])
    }
    
    func resetPriceButtons(){
        priceSort = 0
        view_priceup.layer.cornerRadius = 23
        view_priceup.layer.borderWidth = 1.5
        view_priceup.layer.borderColor = primaryColor.cgColor
        view_priceup.layer.backgroundColor = UIColor.white.cgColor
        lbl_priceup.textColor = primaryColor
        img_priceup.image = img_priceup.image?.imageWithColor(color1: primaryColor)
        
        view_pricedown.layer.cornerRadius = 23
        view_pricedown.layer.borderWidth = 1.5
        view_pricedown.layer.borderColor = primaryColor.cgColor
        view_pricedown.layer.backgroundColor = UIColor.white.cgColor
        lbl_pricedown.textColor = primaryColor
        img_pricedown.image = img_pricedown.image?.imageWithColor(color1: primaryColor)
    }
    
    func resetNameButtons(){
        nameSort = 0
        view_nameasc.layer.cornerRadius = 23
        view_nameasc.layer.borderWidth = 1.5
        view_nameasc.layer.borderColor = primaryColor.cgColor
        view_nameasc.layer.backgroundColor = UIColor.white.cgColor
        lbl_nameasc.textColor = primaryColor
        img_nameasc.image = img_nameasc.image?.imageWithColor(color1: primaryColor)
        
        view_namedesc.layer.cornerRadius = 23
        view_namedesc.layer.borderWidth = 1.5
        view_namedesc.layer.borderColor = primaryColor.cgColor
        view_namedesc.layer.backgroundColor = UIColor.white.cgColor
        lbl_namedesc.textColor = primaryColor
        img_namedesc.image = img_namedesc.image?.imageWithColor(color1: primaryColor)
    }
    
    @IBAction func back(_ sender: Any) {
        dismissViewController()
    }
    
    @IBAction func no_apply(_ sender: Any) {
        gMinPrice = 0
        gMaxPrice = Int64(MAX_PRODUCT_PRICE)
        gPriceSort = 0
        gNameSort = 0
        gCategoryViewController.showToast(msg: Language().filter_canceled)
        dismissViewController()
    }
    
    @IBAction func apply(_ sender: Any) {
        gMinPrice = minPrice
        gMaxPrice = maxPrice
        gPriceSort = priceSort
        gNameSort = nameSort
        gCategoryViewController.showToast(msg: Language().filter_applied)
        dismissViewController()
    }
    
    @IBAction func favorites(_ sender: Any) {
        if thisUser.idx > 0 {
            let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "FavoritesViewController"))!
            transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
        }else{
            let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "LoginViewController"))!
            transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
        }
    }
    
    @IBAction func btn_wishlist(_ sender: Any) {
        let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "WishlistViewController"))!
        transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
    }
    
    
}
