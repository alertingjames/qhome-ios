//
//  FavoritesViewController.swift
//  Qhome
//
//  Created by LGH419 on 7/21/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit
import Kingfisher
import SCLAlertView

class FavoritesViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var view_nav: UIView!
    @IBOutlet weak var storeList: UITableView!
    @IBOutlet weak var btn_search: UIButton!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var edt_search: UITextField!
    @IBOutlet weak var view_searchbar: UIView!
    
    var stores = [Store]()
    var searchStores = [Store]()
    var selectedStore:Store!

    override func viewDidLoad() {
        super.viewDidLoad()

        addShadowToBar(view: view_nav)
        edt_search.attributedPlaceholder = NSAttributedString(string: Language().search,
                                                              attributes: [NSAttributedString.Key.foregroundColor: primaryColor])
        
        storeList.delegate = self
        storeList.dataSource = self
        
        edt_search.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                             for: UIControl.Event.editingChanged)
        
        storeList.estimatedRowHeight = 240.0
        storeList.rowHeight = UITableView.automaticDimension
    }
    
    @IBAction func back(_ sender: Any) {
        dismissViewController()
    }
    
    @IBAction func search(_ sender: Any) {
        if view_searchbar.isHidden{
            view_searchbar.isHidden = false
            btn_search.setImage(cancel, for: .normal)
            lbl_title.isHidden = true
            
        }else{
            view_searchbar.isHidden = true
            btn_search.setImage(search, for: .normal)
            lbl_title.isHidden = false
            self.edt_search.text = ""
            self.stores = searchStores
            self.storeList.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getFavoriteStores(member_id: thisUser.idx)
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
        
        let cell:FavoriteItemCell = tableView.dequeueReusableCell(withIdentifier: "FavoriteItemCell", for: indexPath) as! FavoriteItemCell
        
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
            
            print("Store Name:\(stores[index].name)")
            
            cell.view_item1.isHidden = false
            cell.view_item1.tag = index
            let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.tappedItem1(_:)))
            cell.view_item1.addGestureRecognizer(tap1)
            
            cell.btn_delete1.tag = index
            cell.btn_delete1.addTarget(self, action: #selector(deleted), for: .touchUpInside)
            
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
            
            cell.view_item2.isHidden = false
            cell.view_item2.tag = index2
            let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.tappedItem2(_:)))
            cell.view_item2.addGestureRecognizer(tap2)
            
            cell.btn_delete2.tag = index2
            cell.btn_delete2.addTarget(self, action: #selector(deleted), for: .touchUpInside)
            
        }else{
            cell.view_item2.isHidden = true
        }
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 240.0
//    }
    
    @objc func deleted(sender : UIButton){
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: true
        )
        let alert = SCLAlertView(appearance: appearance)
        alert.addButton(Language().yes) {
            self.selectedStore = self.stores[sender.tag]
            self.unLikeStore(store_id: self.selectedStore.idx)
        }
        alert.showWarning(Language().warning, subTitle: Language().suredelete)
        
    }
    
    @objc func tappedItem1(_ sender: UITapGestureRecognizer? = nil) {
        if let tag = sender?.view?.tag {
            print(tag)
            gStore = self.stores[tag]
            if thisUser.idx > 0{
                if gStore.userId != thisUser.idx{
                    let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "StoreDetailViewController"))!
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
        if let tag = sender?.view?.tag {
            print(tag)
            gStore = self.stores[tag]
            if thisUser.idx > 0{
                if gStore.userId != thisUser.idx{
                    let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "StoreDetailViewController"))!
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
    
    func unLikeStore(store_id:Int64){
        APIs.unLikeStore(store_id:store_id, member_id: thisUser.idx, handleCallback: {
            result_code in
            print(result_code)
            if result_code == "0"{
                let index = self.stores.firstIndex{$0 === self.selectedStore}
                self.stores.remove(at: index!)
                self.searchStores.remove(at: index!)
                self.storeList.reloadData()
            }
            else{
                self.showToast(msg: Language().serverissue)
            }
        })
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text == ""{
            self.getFavoriteStores(member_id: thisUser.idx)
        }else{
            stores = filter(keyword: (textField.text?.lowercased())!)
            if stores.isEmpty{
                self.showToast(msg: Language().noresult)
            }
            self.storeList.reloadData()
        }
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
    
    func getFavoriteStores(member_id: Int64){
        self.stores.removeAll()
        self.searchStores.removeAll()
        self.showLoadingView()
        APIs.getFavoriteStores(member_id: member_id, handleCallback: {
            stores, result_code in
            self.dismissLoadingView()
            print(result_code)
            if result_code == "0"{
                for store in stores!{
                    self.stores.append(store)
                    self.searchStores.append(store)
                }
                
                if self.stores.count == 0{
                    self.storeList.isHidden = true
                    self.showToast(msg: Language().noresult)
                }else{
                    self.storeList.isHidden = false
                }
                
                self.storeList.reloadData()
            }
            else{
                //             self.showToast(msg: "Server issue.")
            }
        })
        
    }

}
