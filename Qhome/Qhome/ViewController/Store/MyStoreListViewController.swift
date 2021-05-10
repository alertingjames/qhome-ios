//
//  MyStoreListViewController.swift
//  Qhome
//
//  Created by LGH419 on 7/21/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit
import Cosmos
import Kingfisher

class MyStoreListViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var view_nav: UIView!
    @IBOutlet weak var btn_search: UIButton!
    @IBOutlet weak var btn_add: UIButton!
    @IBOutlet weak var view_searchbar: UIView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var edt_search: UITextField!
    @IBOutlet weak var storeList: UITableView!
    
    var stores = [Store]()
    var searchStores = [Store]()

    override func viewDidLoad() {
        super.viewDidLoad()

        addShadowToBar(view: view_nav)
        edt_search.attributedPlaceholder = NSAttributedString(string: Language().search,
            attributes: [NSAttributedString.Key.foregroundColor: primaryColor])
        
        storeList.delegate = self
        storeList.dataSource = self
        
        storeList.estimatedRowHeight = 120
        storeList.rowHeight = UITableView.automaticDimension
        
        edt_search.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                             for: UIControl.Event.editingChanged)
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
        
        self.stores.removeAll()
        gStores.removeAll()
        gMyStores.removeAll()
        self.searchStores.removeAll()
        var myApprovedStores = 0
        
        self.showLoadingView()
        APIs.getStores(member_id: thisUser.idx, handleCallback: {
            stores, result_code in
            self.dismissLoadingView()
            print(result_code)
            if result_code == "0"{
                for store in stores!{
                    if thisUser.idx > 0{
                        if store.userId == thisUser.idx{
                            gMyStores.append(store)
                            self.stores.append(store)
                            self.searchStores.append(store)
                            if store.status == "approved"{
                                myApprovedStores = myApprovedStores + 1
                            }
                        }
                    }
                    
                    if store.status == "approved"{
                        gStores.append(store)
                    }
                }
                
                thisUser.stores = myApprovedStores
                
                if gStores.count == 0{
                    self.storeList.isHidden = true
                }else{
                    self.storeList.isHidden = false
                }
                self.storeList.reloadData()
                if thisUser.idx > 0{
                    if thisUser.role == "producer" && gMyStores.count < 2{
                        self.btn_add.visibilityh = .visible
                    }else{
                        self.btn_add.visibilityh = .gone
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
        return stores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:MyStoreItemCell = tableView.dequeueReusableCell(withIdentifier: "MyStoreItemCell", for: indexPath) as! MyStoreItemCell
        
        let index:Int = indexPath.row
        
        if stores[index].logoUrl != ""{
            loadPicture(imageView: cell.img_logo, url: URL(string: stores[index].logoUrl)!)
        }
        
        if lang == "ar" {
            cell.lbl_name.text = stores[index].arName
            if stores[index].category2 != ""{
                cell.lbl_category.text = stores[index].arCategory + ", " + stores[index].arCategory2
            }else{
                cell.lbl_category.text = stores[index].arCategory
            }
            cell.txt_desc.text = stores[index].arDescription
        }else{
            cell.lbl_name.text = stores[index].name
            if stores[index].category2 != ""{
                cell.lbl_category.text = stores[index].category + ", " + stores[index].category2
            }else{
                cell.lbl_category.text = stores[index].category
            }
            cell.txt_desc.text = stores[index].description
        }
        
        cell.lbl_likes.text = String(stores[index].likes)
        cell.lbl_reviews.text = String(stores[index].reviews)
        cell.ratingbar.rating = Double(stores[index].ratings)
        cell.ratingbar.text = String(stores[index].ratings)
        cell.ratingbar.settings.updateOnTouch = false
        cell.ratingbar.settings.fillMode = .precise
        
        if stores[index].status == "approved"{
            if lang == "ar"{
                cell.img_status.image = UIImage(named: "ic_checked_flip")
            }else{
                cell.img_status.image = UIImage(named: "ic_checked")
            }
        }else if stores[index].status == "declined"{
            cell.img_status.image = UIImage(named: "cancelicon_marron")
        }else{
            cell.img_status.isHidden = true
        }
        
        print("Store Name:\(stores[index].name)")
        
        cell.view_more.tag = index
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tappedViewMore(_:)))
        cell.view_more.addGestureRecognizer(tap)
        
        cell.txt_desc.sizeToFit()
        cell.view_content.sizeToFit()
        cell.view_content.layoutIfNeeded()
        
        return cell
    }
    
    @objc func tappedViewMore(_ sender: UITapGestureRecognizer? = nil) {
        if let tag = sender?.view?.tag {
            print(tag)
            gStore = self.stores[tag]
            let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "MyStoreDetailViewController"))!
            conVC.modalPresentationStyle = .fullScreen
            transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text == ""{
            self.getStores()
        }else{
            stores = filter(keyword: (textField.text?.lowercased())!)
            if stores.isEmpty{
                
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

    @IBAction func toNewStore(_ sender: Any) {
        let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "RegisterStoreViewController"))!
        conVC.modalPresentationStyle = .fullScreen
        transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
    }
    
}
