//
//  HomeViewController.swift
//  Qhome
//
//  Created by LGH419 on 7/10/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit
import Kingfisher
import SCLAlertView
import Firebase
import FirebaseDatabase
import AVFoundation
import AudioToolbox

class HomeViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    private var lastContentOffset: CGFloat = 0
    @IBOutlet weak var view_nav:UIView!
    @IBOutlet weak var view_cartcount: UIView!
    @IBOutlet weak var lbl_cartcount: UILabel!
    @IBOutlet weak var view_noticount: UIView!
    @IBOutlet weak var lbl_noticount: UILabel!
    @IBOutlet weak var view_notification: UIView!
    @IBOutlet weak var view_cart: UIView!
    @IBOutlet weak var btn_search: UIButton!
    @IBOutlet weak var view_searchbar: UIView!
    @IBOutlet weak var edt_search: UITextField!
    @IBOutlet weak var btn_nav: UIButton!
    @IBOutlet weak var logo: UIImageView!
    
    let leftarrow = UIImage(named: "leftarrow_marron")
    let navigation = UIImage(named: "navigationicon_marron")
    
    var menu_vc:MainMenuViewController!
    var dark_background:DarkBackgroundViewController!
    
    @IBOutlet weak var img_ad1: UIImageView!
    @IBOutlet weak var view_ad1: UIView!
    @IBOutlet weak var view_adcap1: UIView!
    @IBOutlet weak var view_ad2: UIView!
    @IBOutlet weak var img_ad2: UIImageView!
    @IBOutlet weak var view_ad3: UIView!
    @IBOutlet weak var img_ad3: UIImageView!
    @IBOutlet weak var lbl_ad2: UILabel!
    @IBOutlet weak var lbl_ad3: UILabel!
    @IBOutlet weak var view_company: UIView!
    
    @IBOutlet weak var view_category: UIView!
    var stores = [Store]()
    var searchStores = [Store]()
    @IBOutlet weak var storeList: UITableView!
    @IBOutlet weak var view_content: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var isNotified:Bool = false
    var likeButton:UIButton!
    var storeId:Int64!
    
    var notiFrame:NotisViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gHomeViewController = self

        addShadowToBar(view: view_nav)
        
        view_notification.visibilityh = .gone
        
        notiFrame = self.storyboard!.instantiateViewController(withIdentifier: "NotisViewController") as! NotisViewController
        
        view_noticount.isHidden = true
        view_cartcount.isHidden = true
        view_searchbar.isHidden = true
        edt_search.attributedPlaceholder = NSAttributedString(string: Language().search,
            attributes: [NSAttributedString.Key.foregroundColor: primaryColor])
        
        homeButton = btn_nav
        menu_vc = self.storyboard!.instantiateViewController(withIdentifier: "MainMenuViewController") as? MainMenuViewController
        dark_background = self.storyboard!.instantiateViewController(withIdentifier: "DarkBackgroundViewController") as? DarkBackgroundViewController
        
        if lang == "ar"{
            self.menu_vc.view.frame = CGRect(x: UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }else{
            self.menu_vc.view.frame = CGRect(x: -UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
        self.dark_background.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        gMainMenu = menu_vc
        
        if thisUser.idx > 0 && thisUser.auth_status == "verified" && thisUser.status != "removed"{
            menu_vc.view_signuplogin.visibility = .gone
            menu_vc.view_logout.visibility = .visible
        }else{
            if thisUser.idx > 0 && thisUser.status == "removed"{
                UserDefaults.standard.set("", forKey: "email")
                UserDefaults.standard.set("", forKey: "role")
                thisUser.idx = 0
                menu_vc.view_signuplogin.visibility = .visible
                menu_vc.view_logout.visibility = .gone
                let appearance = SCLAlertView.SCLAppearance(
                    kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
                    kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
                    kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
                    showCloseButton: true
                )
                let alert = SCLAlertView(appearance: appearance)
                alert.addButton(Language().ok) {
                    
                }
                alert.showWarning(Language().warning, subTitle: Language().account_deleted)
            }
            menu_vc.view_signuplogin.visibility = .visible
            menu_vc.view_logout.visibility = .gone
        }
        
        let imei = UserDefaults.standard.string(forKey: "imei")
        if imei?.count ?? 0 == 0 {
            let deviceIMEI = UIDevice.current.identifierForVendor?.uuidString
            UserDefaults.standard.set(deviceIMEI, forKey: "imei")
        }
        
        gIMEI = UserDefaults.standard.string(forKey: "imei")
        print("IMEI: \(gIMEI ?? "")")
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToGesture(gesture:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToGesture(gesture:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        
        self.view.addGestureRecognizer(swipeRight)
        self.view.addGestureRecognizer(swipeLeft)
        
        isMenuOpen = true
        
        let tap_menupanel = UITapGestureRecognizer(target: self, action: #selector(self.tapPanel(_:)))
        menu_vc.view.addGestureRecognizer(tap_menupanel)
        
        
        img_ad1.layer.cornerRadius = 15
        view_ad1.layer.cornerRadius = 15
        view_adcap1.layer.cornerRadius = 10

        img_ad2.layer.cornerRadius = 10
        view_ad2.layer.cornerRadius = 10

        img_ad3.layer.cornerRadius = 10
        view_ad3.layer.cornerRadius = 10
        
        setRoundShadowView(view: view_category, corner: 22)
        
        let tap_category = UITapGestureRecognizer(target: self, action: #selector(self.tapCategory(_:)))
        view_category.addGestureRecognizer(tap_category)
        
        self.storeList.delegate = self
        self.storeList.dataSource = self
        
        storeList.estimatedRowHeight = 190.0
        storeList.rowHeight = UITableView.automaticDimension
        
        scrollView.delegate = self
        
        var tap = UITapGestureRecognizer(target: self, action: #selector(self.toCart(_:)))
        view_cart.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.showNotifications(_:)))
        view_notification.addGestureRecognizer(tap)
        
        edt_search.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                            for: UIControl.Event.editingChanged)
        
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.getNoitificaitons()
                self.registerGuest(imei: gIMEI)
                print("FCMToken!!!", gFCMToken)
            }
        }
        
        let tap_company = UITapGestureRecognizer(target: self, action: #selector(self.tapCompany(_:)))
        view_company.addGestureRecognizer(tap_company)
        
    }
    
    func registerFCMToken(member_id: Int64, token:String){
        APIs.registerFCMToken(member_id: member_id, token: token, handleCallback: {
            fcm_token, result_code in
            if result_code == "0"{
                print("token!!!", fcm_token)
            }
        })
    }
    
    @objc func showNotifications(_ sender: UITapGestureRecognizer? = nil) {
        self.present(self.notiFrame, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        gMinPrice = 0
        gMaxPrice = Int64(MAX_PRODUCT_PRICE)
        gPriceSort = 0
        gNameSort = 0
        
        gNotificationEnabled = UserDefaults.standard.bool(forKey: "notification")
        gOrderStatus.initOrderStatus()
        self.loadAds()
        self.getStores(member_id: thisUser.idx)
        self.getCart(imei: gIMEI)
        
        if thisUser.idx > 0{
            self.registerFCMToken(member_id: thisUser.idx, token: gFCMToken)
        }
        
        setRoundShadowView(view: view_company, corner: 20)
        
    }
    
    @objc func tapCompany(_ sender: UITapGestureRecognizer? = nil) {
        let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "CompanyViewController"))!
        conVC.modalPresentationStyle = .fullScreen
        transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
    }
    
    
    @objc func tapPanel(_ sender: UITapGestureRecognizer? = nil) {
        close_menu()
    }
    
    @objc func toCart(_ sender: UITapGestureRecognizer? = nil) {
        let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "CartViewController"))!
        conVC.modalPresentationStyle = .fullScreen
        transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
    }
    
    @objc func tapCategory(_ sender: UITapGestureRecognizer? = nil) {
        let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "CategoryViewController"))!
        conVC.modalPresentationStyle = .fullScreen
        transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
//        self.present(conVC, animated: false, completion: nil)
    }
    
    
    @objc func respondToGesture(gesture: UISwipeGestureRecognizer){
        switch gesture.direction{
        case UISwipeGestureRecognizer.Direction.right:
            if lang == "ar"{
                close_menu()
            }else{
                show_menu()
            }
        case UISwipeGestureRecognizer.Direction.left:
            if lang == "ar"{
                show_menu()
            }else{
                close_on_swipe()
            }
        default:
            break
        }
    }
    
    func close_on_swipe(){
        if isMenuOpen{
            // show_menu()
        }else{
            close_menu()
        }
    }
    
    func show_menu() {
        UIView.animate(withDuration: 0.3){() -> Void in
            self.addChild(self.dark_background)
            self.view.addSubview(self.dark_background.view)
            self.menu_vc.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            self.addChild(self.menu_vc)
            self.view.addSubview(self.menu_vc.view)
            isMenuOpen = false
            darkBackg = self.dark_background
        }
    }
    
    func close_menu() {
        if lang == "ar"{
            UIView.animate(withDuration: 0.3, animations: {() -> Void in
                self.menu_vc.view.frame = CGRect(x: UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                self.dark_background.view.removeFromSuperview()
            }){
                (finished) in
                self.menu_vc.view.removeFromSuperview()
            }
        }else{
            UIView.animate(withDuration: 0.3, animations: {() -> Void in
                self.menu_vc.view.frame = CGRect(x: -UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                self.dark_background.view.removeFromSuperview()
            }){
                (finished) in
                self.menu_vc.view.removeFromSuperview()
            }
        }
        isMenuOpen = true
    }
    
    
    @IBAction func tap_search(_ sender: Any) {
        if view_searchbar.isHidden{
            view_searchbar.isHidden = false
            btn_search.setImage(cancel, for: .normal)
            logo.isHidden = true
            
        }else{
            view_searchbar.isHidden = true
            btn_search.setImage(search, for: .normal)
            logo.isHidden = false
            self.edt_search.text = ""
            self.stores = searchStores
            self.storeList.reloadData()
        }
    }
    
    @IBAction func tap_menu(_ sender: Any) {
        if isMenuOpen{
            isMenuOpen = false
            btn_nav.setImage(navigation, for: .normal)
            show_menu()
        }else{
            isMenuOpen = true
            btn_nav.setImage(leftarrow, for: .normal)
            close_menu()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if stores.count % 2 == 0{
            return stores.count/2
        }else{
            return stores.count/2 + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:StoreItemCell = tableView.dequeueReusableCell(withIdentifier: "StoreItemCell", for: indexPath) as! StoreItemCell
        
        let index:Int = indexPath.row * 2
        
        if let _ = stores[exist: index]{
            
            if stores[index].logoUrl != ""{
                loadPicture(imageView: cell.img_logo1, url: URL(string: stores[index].logoUrl)!)
            }
            
            if lang == "ar" {
                cell.lbl_name1.text = stores[index].arName
            }else{
                cell.lbl_name1.text = stores[index].name
            }
            
            if stores[index].isLiked{
                cell.btn_like1.setImage(liked, for: .normal)
            }else{
                cell.btn_like1.setImage(like, for: .normal)
            }
            
            if thisUser.idx == 0{
                cell.btn_like1.isHidden = true
            }else{
                if thisUser.idx == stores[index].userId{
                    cell.btn_like1.isHidden = true
                }else{
                    cell.btn_like1.isHidden = false
                }
            }
            
            cell.btn_like1.tag = index
            cell.btn_like1.addTarget(self, action: #selector(likeUnlikeStore), for: .touchUpInside)
            
            cell.view_item1.isHidden = false
            cell.view_item1.tag = index
            let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.tappedItem1(_ :)))
            cell.view_item1.addGestureRecognizer(tap1)
            
            cell.view_item1.sizeToFit()
            
        }else{
            cell.view_item1.isHidden = true
        }
        
        let index2:Int = indexPath.row * 2 + 1
        
        if let _ = stores[exist: index2]{
            if stores[index2].logoUrl != ""{
                loadPicture(imageView: cell.img_logo2, url: URL(string: stores[index2].logoUrl)!)
            }
            
            if lang == "ar" {
                cell.lbl_name2.text = stores[index2].arName
            }else{
                cell.lbl_name2.text = stores[index2].name
            }
            
            if stores[index2].isLiked{
                cell.btn_like2.setImage(liked, for: .normal)
            }else{
                cell.btn_like2.setImage(like, for: .normal)
            }
            
            if thisUser.idx == 0{
                cell.btn_like2.isHidden = true
            }else{
                if thisUser.idx == stores[index2].userId{
                    cell.btn_like2.isHidden = true
                }else{
                    cell.btn_like2.isHidden = false
                }
            }
            
            cell.btn_like2.tag = index2
            cell.btn_like2.addTarget(self, action: #selector(likeUnlikeStore), for: .touchUpInside)
            
            cell.view_item2.isHidden = false
            cell.view_item2.tag = index2
            let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.tappedItem2(_:)))
            cell.view_item2.addGestureRecognizer(tap2)
            
            cell.view_item2.sizeToFit()
            
        }else{
            cell.view_item2.isHidden = true
        }
        
        cell.view_content.sizeToFit()
        cell.view_content.layoutIfNeeded()
        
        return cell
    }
    
    @objc func likeUnlikeStore(sender : UIButton){
        let store = self.stores[sender.tag]
        likeButton = sender
        storeId = store.idx
        if store.isLiked{
            self.unLikeStore(store_id: store.idx)
        }else{
            self.likeStore(store_id: store.idx)
        }
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 190.0
//    }

    
    @objc func tappedItem1(_ sender:UITapGestureRecognizer? = nil) {
        if self.loadingView.isAnimating{
            return
        }
        if let tag = sender?.view?.tag {
            print(tag)
            gStore = self.stores[tag]
            if thisUser.idx > 0{
                if gStore.userId != thisUser.idx{
                    let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "StoreDetailViewController"))!
                    conVC.modalPresentationStyle = .fullScreen
                    transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
                }else{
                    let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "MyStoreDetailViewController"))!
                    conVC.modalPresentationStyle = .fullScreen
                    transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
                }
            }else{
                let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "StoreDetailViewController"))!
                conVC.modalPresentationStyle = .fullScreen
                transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
            }
        }
    }
    
    @objc func tappedItem2(_ sender: UITapGestureRecognizer? = nil) {
        if self.loadingView.isAnimating{
            return
        }
        if let tag = sender?.view?.tag {
            print(tag)
            gStore = self.stores[tag]
            if thisUser.idx > 0{
                if gStore.userId != thisUser.idx{
                    let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "StoreDetailViewController"))!
                    transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
                }else{
                    let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "MyStoreDetailViewController"))!
                    transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
                }
            }else{
                let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "StoreDetailViewController"))!
                transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.lastContentOffset > scrollView.contentOffset.y) {
            // move down
//            print("Now scrolling down\(scrollView.contentOffset.y)")
//            if scrollView == self.storeList{
//
//            }
        }
        else if (self.lastContentOffset < scrollView.contentOffset.y) {
            // move up
//             print("Now scrolling up\(scrollView.contentOffset.y)")
//            if(scrollView == self.storeList){
//                if scrollView.contentOffset.y > self.storeList.contentSize.height{
//                    scrollView.isScrollEnabled = false
//                }
//            }
        }
        
        // update the new position acquired
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        stores = filter(keyword: (textField.text?.lowercased())!)
        if stores.isEmpty{
            
        }
        self.storeList.reloadData()
    }
    
    func filter(keyword:String) -> [Store]{
        if keyword == ""{
            return searchStores
        }
        var filteredStores = [Store]()
        for store in searchStores{
            if store.name.lowercased().contains(keyword){
                filteredStores.append(store)
            }else{
                if store.category.lowercased().contains(keyword){
                    filteredStores.append(store)
                }else{
                    if store.description.lowercased().contains(keyword){
                        filteredStores.append(store)
                    }else{
                        if store.arName.contains(keyword){
                            filteredStores.append(store)
                        }else{
                            if store.arCategory.contains(keyword){
                                filteredStores.append(store)
                            }else{
                                if store.arDescription.contains(keyword){
                                    filteredStores.append(store)
                                }
                            }
                        }
                    }
                }
            }
        }
        return filteredStores
    }
    
    func getNoitificaitons(){
        if thisUser.idx > 0 && thisUser.role == "producer"{
            self.getCustomerNotification()
        }
        if thisUser.idx > 0{
            self.getProducerNotification()
        }
        self.getAdminNotification()
    }
    
    var count:Int = 0
    var refs = [DatabaseReference]()
    
    func getCustomerNotification(){
        var ref:DatabaseReference!
        ref = Database.database().reference(fromURL: ReqConst.FIREBASE_URL + "order/" + String(thisUser.idx))
        
        ref.observe(.childAdded, with: {(snapshot) -> Void in
            let value = snapshot.value as! [String: Any]
            let timeStamp = value["date"] as! String
            let date = self.getDateFromTimeStamp(timeStamp: Double(timeStamp)!)
            let msg = value["msg"] as! String
            let fromid = value["fromid"] as! String
            let fromname = value["fromname"] as! String
            self.count += 1
            gBadgeCount = self.count
            self.view_notification.visibilityh = .visible
            self.view_noticount.isHidden = false
            self.lbl_noticount.text = String(gBadgeCount)
            UIApplication.shared.applicationIconBadgeNumber = self.count
            AudioServicesPlaySystemSound(SystemSoundID(1106))
            let noti = Notification()
            //            noti.sender_id = Int64(fromid!)!
            //            noti.sender_name = fromname
            noti.sender_name = fromname
            noti.message = "Customer's new order: " + fromname
            noti.date_time = timeStamp
            noti.image = ""
            //            self.notiFrame.notis.append(noti)
            self.notiFrame.notis.insert(noti, at: 0)
            
            self.refs.insert(snapshot.ref, at: 0)
            
        })
    }
    
    func getProducerNotification(){
        var ref:DatabaseReference!
        ref = Database.database().reference(fromURL: ReqConst.FIREBASE_URL + "order_upgrade/" + String(thisUser.idx))
        
        ref.observe(.childAdded, with: {(snapshot) -> Void in
            let value = snapshot.value as! [String: Any]
            let timeStamp = value["date"] as! String
            let date = self.getDateFromTimeStamp(timeStamp: Double(timeStamp)!)
            let msg = value["msg"] as! String
            let fromid = value["fromid"] as! String
            let fromname = value["fromname"] as! String
            self.count += 1
            gBadgeCount = self.count
            self.view_notification.visibilityh = .visible
            self.view_noticount.isHidden = false
            self.lbl_noticount.text = String(gBadgeCount)
            UIApplication.shared.applicationIconBadgeNumber = self.count
            AudioServicesPlaySystemSound(SystemSoundID(1106))
            let noti = Notification()
            //            noti.sender_id = Int64(fromid!)!
            //            noti.sender_name = fromname
            noti.sender_name = fromname
            noti.message = msg
            noti.date_time = timeStamp
            noti.image = ""
            //            self.notiFrame.notis.append(noti)
            self.notiFrame.notis.insert(noti, at: 0)
            
            self.refs.insert(snapshot.ref, at: 0)
            
        })
    }
    
    func getAdminNotification(){
        var ref:DatabaseReference!
        if thisUser.idx > 0{
            ref = Database.database().reference(fromURL: ReqConst.FIREBASE_URL + "admin/" + String(thisUser.idx))
        }else{
            ref = Database.database().reference(fromURL: ReqConst.FIREBASE_URL + "admin/" + gIMEI)
        }
        
        ref.observe(.childAdded, with: {(snapshot) -> Void in
            let value = snapshot.value as! [String: Any]
            let timeStamp = value["date"] as! String
            let date = self.getDateFromTimeStamp(timeStamp: Double(timeStamp)!)
            let msg = value["msg"] as! String
            let image = value["img"] as! String
            let fromid = value["fromid"] as! String
            let fromname = value["fromname"] as! String
            self.count += 1
            gBadgeCount = self.count
            self.view_notification.visibilityh = .visible
            self.view_noticount.isHidden = false
            self.lbl_noticount.text = String(gBadgeCount)
            UIApplication.shared.applicationIconBadgeNumber = self.count
            AudioServicesPlaySystemSound(SystemSoundID(1106))
            let noti = Notification()
//            noti.sender_id = Int64(fromid!)!
//            noti.sender_name = fromname
            noti.sender_name = Language().admin
            noti.message = msg
            noti.date_time = timeStamp
            noti.image = image
//            self.notiFrame.notis.append(noti)
            self.notiFrame.notis.insert(noti, at: 0)
            
            self.refs.insert(snapshot.ref, at: 0)
            
        })
    }
    
    func registerGuest(imei:String)
    {
        self.view.endEditing(true)
        APIs.registerGuest(imei_id:imei, handleCallback:{
            print("Registered as a guest")
        })
    }
    
    func getCart(imei:String){
        gCartItems.removeAll()
        gCartItemsCount = 0
        APIs.getCarts(imei_id: imei, handleCallback: {
            cartItems, result_code in
            print(result_code)
            if result_code == "0"{
                for item in cartItems!{
                    gCartItems.append(item)
                    gCartItemsCount = gCartItemsCount + Int(item.quantity)
                }
                if gCartItems.count > 0{
                    self.lbl_cartcount.text = String(gCartItemsCount)
                    self.view_cartcount.isHidden = false
                }else{
                    self.view_cartcount.isHidden = true
                }
            }
            else{
                
            }
        })
    }
    
    func getStores(member_id: Int64){
        self.stores.removeAll()
        gStores.removeAll()
        gMyStores.removeAll()
        self.searchStores.removeAll()
        var myApprovedStores = 0
        self.showLoadingView()
        APIs.getStores(member_id: member_id, handleCallback: {
            stores, result_code in
            self.dismissLoadingView()
            print(result_code)
            if result_code == "0"{
                for store in stores!{
                    if thisUser.idx > 0 && thisUser.role == "producer"{
                        if store.userId == thisUser.idx{
                            gMyStores.append(store)
                            if store.status == "approved"{
                                myApprovedStores = myApprovedStores + 1
                            }
                        }
                    }
                    
                    if store.status == "approved"{
                        gStores.append(store)
                        self.stores.append(store)
                        self.searchStores.append(store)
                    }
                }
                if thisUser.idx > 0 && thisUser.role == "producer"{
                    thisUser.stores = myApprovedStores
                }
                if gStores.count == 0{
                    self.storeList.visibility = .gone
                }else{
                    self.storeList.visibility = .visible
                }
                self.storeList.reloadData()
                if thisUser.idx > 0{
                    if thisUser.role == "producer" && thisUser.stores == 0 && gMyStores.count < 2{
                        if self.isNotified == false{
                            let appearance = SCLAlertView.SCLAppearance(
                                kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
                                kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
                                kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
                                showCloseButton: true
                            )
                            let alert = SCLAlertView(appearance: appearance)
                            alert.addButton(Language().ok) {
                                let conVC = AppDelegate.currentStoryboard.instantiateViewController(withIdentifier: "RegisterStoreViewController")
                                conVC.modalPresentationStyle = .fullScreen
                                self.transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
                            }
                            alert.showInfo(Language().hint, subTitle: Language().registerstoretext)
                            self.isNotified = true
                        }
                    }
                }
                
//                for constraint in self.storeList.constraints {
//                    if constraint.firstItem as? UITableView == self.storeList {
//                        if constraint.firstAttribute == .height {
//                            constraint.constant = self.storeList.contentSize.height
//                        }
//                    }
//                }
//
//                self.storeList.frame.size.height = storeList.contentSize.height
                
            }
            else{
                //             self.showToast(msg: "Server issue.")
            }
        })
        
    }
    
    func likeStore(store_id:Int64){
        APIs.likeStore(store_id:store_id, member_id: thisUser.idx, handleCallback: {
            result_code in
            print(result_code)
            if result_code == "0"{
                if self.likeButton != nil{
                    self.likeButton.setImage(UIImage(named: "ic_liked"), for: .normal)
                    for i in 0...gStores.count - 1{
                        let store = gStores[i]
                        if store.idx == self.storeId{
                            store.isLiked = true
                            store.likes = store.likes + 1
                            self.stores[i].isLiked = true  // these stores
                            self.stores[i].likes = self.stores[i].likes + 1
                        }
                    }
                }
            }
            else{
                self.showToast(msg: Language().serverissue)
            }
        })
    }
    
    func unLikeStore(store_id:Int64){
        APIs.unLikeStore(store_id:store_id, member_id: thisUser.idx, handleCallback: {
            result_code in
            print(result_code)
            if result_code == "0"{
                if self.likeButton != nil{
                    self.likeButton.setImage(UIImage(named: "ic_like"), for: .normal)
                    for i in 0...gStores.count - 1{
                        let store = gStores[i]
                        if store.idx == self.storeId{
                            store.isLiked = false
                            if store.likes > 0 { store.likes = store.likes - 1}
                            self.stores[i].isLiked = false  // these stores
                            if self.stores[i].likes > 0 { self.stores[i].likes = self.stores[i].likes - 1}
                        }
                    }
                }
            }
            else{
                self.showToast(msg: Language().serverissue)
            }
        })
    }
    
    func loadAds(){
        APIs.getAds(handleCallback: {
            adPic1, adPic2, adPic3, adStore1, adStore2, adStore3, result_code in
            print(result_code)
            if result_code == "0"{
                
                var pic1 = ""
                var pic2 = ""
                var pic3 = ""
                
                var adStoreId1:Int64 = 0
                var adStoreId2:Int64 = 0
                var adStoreId3:Int64 = 0
                if adStore1 != ""{
                    adStoreId1 = Int64(adStore1)!
                }
                if adStore2 != ""{
                    adStoreId2 = Int64(adStore2)!
                }
                if adStore3 != ""{
                    adStoreId3 = Int64(adStore3)!
                }
                
                /////////
                
                if adPic1 == ""{
                    pic1 = "https://qhome.pythonanywhere.com/static/qhome/images/adbg.jpg"
                }else{
                    pic1 = adPic1
                }
                
                if adPic2 == ""{
                    pic2 = "https://qhome.pythonanywhere.com/static/qhome/images/adbg.jpg"
                }else{
                    pic2 = adPic2
                }
                
                if adPic3 == ""{
                    pic3 = "https://qhome.pythonanywhere.com/static/qhome/images/adbg.jpg"
                }else{
                    pic3 = adPic3
                }
                
                
                var url = URL(string: pic1)
                var processor = DownsamplingImageProcessor(size: self.img_ad1.frame.size)
                    >> ResizingImageProcessor(referenceSize: self.img_ad1.frame.size, mode: .aspectFill)
                self.img_ad1.kf.indicatorType = .activity
                self.img_ad1.kf.setImage(
                    with: url,
                    placeholder: UIImage(named: "adbg3"),
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
                        
                        if pic1 != "https://qhome.pythonanywhere.com/static/qhome/images/adbg.jpg"{
                            self.view_adcap1.isHidden = true
                            let tap = UITapGestureRecognizer(target: self, action: #selector(self.toStoreDetail(_:)))
                            self.view_ad1.tag = Int(adStoreId1)
                            self.view_ad1.addGestureRecognizer(tap)
                        }else{
                            self.view_adcap1.isHidden = false
                            let tap = UITapGestureRecognizer(target: self, action: #selector(self.contactUs(_:)))
                            self.view_ad1.addGestureRecognizer(tap)
                        }
                        
                    case .failure(let error):
                        print("Job failed: \(error.localizedDescription)")
                        self.view_adcap1.isHidden = false
                    }
                }
                
                
                
                url = URL(string: pic2)
                processor = DownsamplingImageProcessor(size: CGSize(width: self.img_ad2.frame.width, height: self.img_ad2.frame.width))
                    >> ResizingImageProcessor(referenceSize: CGSize(width: self.img_ad2.frame.width, height: self.img_ad2.frame.width), mode: .aspectFill)
                self.img_ad2.kf.indicatorType = .activity
                self.img_ad2.kf.setImage(
                    with: url,
                    placeholder: UIImage(named: "adbg4"),
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
                        if pic2 != "https://qhome.pythonanywhere.com/static/qhome/images/adbg.jpg"{
                            self.lbl_ad2.isHidden = true
                            let tap = UITapGestureRecognizer(target: self, action: #selector(self.toStoreDetail(_:)))
                            self.view_ad2.tag = Int(adStoreId2)
                            self.view_ad2.addGestureRecognizer(tap)
                        }else{
                            self.lbl_ad2.isHidden = false
                            let tap = UITapGestureRecognizer(target: self, action: #selector(self.contactUs(_:)))
                            self.view_ad2.addGestureRecognizer(tap)
                        }
                        
                    case .failure(let error):
                        print("Job failed: \(error.localizedDescription)")
                        self.lbl_ad2.isHidden = false
                    }
                }
                
                print("PIC3: \(pic3)")
                
                url = URL(string: pic3)
                processor = DownsamplingImageProcessor(size: CGSize(width: self.img_ad3.frame.width, height: self.img_ad3.frame.width))
                    >> ResizingImageProcessor(referenceSize: CGSize(width: self.img_ad3.frame.width, height: self.img_ad3.frame.width), mode: .aspectFill)
                self.img_ad3.kf.indicatorType = .activity
                self.img_ad3.kf.setImage(
                    with: url,
                    placeholder: UIImage(named: "adbg5"),
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
                        if pic3 != "https://qhome.pythonanywhere.com/static/qhome/images/adbg.jpg"{
                            self.lbl_ad3.isHidden = true
                            let tap = UITapGestureRecognizer(target: self, action: #selector(self.toStoreDetail(_:)))
                            self.view_ad3.tag = Int(adStoreId3)
                            self.view_ad3.addGestureRecognizer(tap)
                        }else{
                            self.lbl_ad3.isHidden = false
                            let tap = UITapGestureRecognizer(target: self, action: #selector(self.contactUs(_:)))
                            self.view_ad3.addGestureRecognizer(tap)
                        }
                        
                    case .failure(let error):
                        print("Job failed: \(error.localizedDescription)")
                        self.lbl_ad3.isHidden = false
                    }
                }
                
                
                
                ////////////
                
                
            }
            else{
                self.showToast(msg: Language().serverissue)
            }
        })
    }
    
    @objc func toStoreDetail(_ sender: UITapGestureRecognizer? = nil) {
        let tag:Int = (sender?.view!.tag)!
        for store in stores{
            if store.idx == Int64(tag){
                gStore = store
                if thisUser.idx > 0{
                    if store.userId == thisUser.idx{
                        let conVC = AppDelegate.currentStoryboard.instantiateViewController(withIdentifier: "MyStoreDetailViewController")
                        conVC.modalPresentationStyle = .fullScreen
                        transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
                    }else{
                        let conVC = AppDelegate.currentStoryboard.instantiateViewController(withIdentifier: "StoreDetailViewController")
                        conVC.modalPresentationStyle = .fullScreen
                        transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
                    }
                }else{
                    let conVC = AppDelegate.currentStoryboard.instantiateViewController(withIdentifier: "StoreDetailViewController")
                    conVC.modalPresentationStyle = .fullScreen
                    transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
                }
            }
        }
    }
    
    @objc func contactUs(_ sender: UITapGestureRecognizer? = nil) {
//        if thisUser.idx == 0 {
//            let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "LoginViewController"))!
//            transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
//        }else{
            let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "ContactUsViewController"))!
        conVC.modalPresentationStyle = .fullScreen
            transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
//        }
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
    
    func cadminlogin(){
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: true
        )
        let alert = SCLAlertView(appearance: appearance)
        let password = alert.addTextField(Language().enter_password)
        password.isSecureTextEntry = true
        alert.addButton(Language().submit) {
            self.comlogin(password: password.text!)
        }
        alert.showSuccess(Language().admin_login, subTitle: Language().naql_company)
        
    }
    
    func comlogin(password:String){
        self.showLoadingView()
        APIs.comlogin(password: password, handleCallback: {
            result_code in
            print(result_code)
            self.dismissLoadingView()
            if result_code == "0"{
                let vc = AppDelegate.currentStoryboard.instantiateViewController(withIdentifier: "CAdminViewController")
                self.transitionVc(vc: vc, duration: 0.3, type: .fromRight)
            }
            else if result_code == "1"{
                self.showToast(msg: Language().incorrectpassword)
            }else{
                self.showToast(msg: Language().serverissue)
            }
        })
    }
    
}








































