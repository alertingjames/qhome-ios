//
//  StoreListViewController.swift
//  Qhome
//
//  Created by LGH419 on 7/16/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit
import Kingfisher

class StoreListViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var view_nav: UIView!
    @IBOutlet weak var btn_search: UIButton!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var edt_search: UITextField!
    @IBOutlet weak var view_searchbar: UIView!
    @IBOutlet weak var storeList: UITableView!
    var stores = [Store]()
    var searchStores = [Store]()
    
    var likeButton:UIButton!
    var storeId:Int64!

    override func viewDidLoad() {
        super.viewDidLoad()

        lbl_title.text = gCategory.capitalizingFirstLetter()
        addShadowToBar(view: view_nav)
        edt_search.attributedPlaceholder = NSAttributedString(string: Language().search,
                attributes: [NSAttributedString.Key.foregroundColor: primaryColor])
        
        storeList.delegate = self
        storeList.dataSource = self
        
        edt_search.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                             for: UIControl.Event.editingChanged)
        
        storeList.estimatedRowHeight = 190.0
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
        self.getStores()
    }
    
    
    func getStores(){
        
        stores.removeAll()
        searchStores.removeAll()
        
        for store in gStores{
            if lang == "ar"{
                if store.arCategory == gCategory || store.arCategory2 == gCategory{
                    stores.append(store)
                    searchStores.append(store)
                }
            }else{
                print("Categor1: \(store.category)/// Category2: \(gCategory)")
                print("Categor1: \(store.category2)/// Category2: \(gCategory)")
                if store.category == gCategory || store.category2 == gCategory{
                    stores.append(store)
                    searchStores.append(store)
                }
            }
        }
        
        print("Filtered Stores: \(self.stores.count)")
        
        if stores.count == 0{
            self.storeList.isHidden = true
            self.showToast(msg: Language().noresult)
        }else{
            self.storeList.isHidden = false
        }
        
        storeList.reloadData()
        
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
            
            print("Store Name:\(stores[index].name)")
            
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
            let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.tappedItem1(_:)))
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
//        return 220.0
//    }
    
    
    @objc func tappedItem1(_ sender: UITapGestureRecognizer? = nil) {
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
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text == ""{
            self.getStores()
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

}
