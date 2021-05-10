//
//  NotificationsViewController.swift
//  Qhome
//
//  Created by LGH419 on 7/22/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit
import Kingfisher
import SCLAlertView
import GSImageViewerController

class NotificationsViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var view_nav: UIView!
    @IBOutlet weak var btn_search: UIButton!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var view_search: UIView!
    @IBOutlet weak var edt_search: UITextField!
    @IBOutlet weak var notificationList: UITableView!
    
    var notis = [Notification]()
    var searchNotis = [Notification]()
    
    var cells = [NotificationItemCell]()
    
    var selectedNoti:Notification!

    override func viewDidLoad() {
        super.viewDidLoad()

        addShadowToBar(view: view_nav)
        edt_search.attributedPlaceholder = NSAttributedString(string: Language().search,
            attributes: [NSAttributedString.Key.foregroundColor: primaryColor])
        
        notificationList.delegate = self
        notificationList.dataSource = self
        
        notificationList.estimatedRowHeight = 120
        notificationList.rowHeight = UITableView.automaticDimension
        
        edt_search.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                        for: UIControl.Event.editingChanged)
        
        
    }
    
    @IBAction func search(_ sender: Any) {
        if view_search.isHidden{
            view_search.isHidden = false
            btn_search.setImage(cancel, for: .normal)
            lbl_title.isHidden = true
            
        }else{
            view_search.isHidden = true
            btn_search.setImage(search, for: .normal)
            lbl_title.isHidden = false
            self.edt_search.text = ""
            self.notis = searchNotis
            self.notificationList.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getNotifications(receiver_id: thisUser.idx)
    }
    
    @IBAction func back(_ sender: Any) {
        dismissViewController()
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
        return notis.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:NotificationItemCell = tableView.dequeueReusableCell(withIdentifier: "NotificationItemCell", for: indexPath) as! NotificationItemCell
        
        let index:Int = indexPath.row
        
        cell.lbl_sendername.text = self.notis[index].sender_name
        cell.txt_message.text = self.notis[index].message
        cell.lbl_time.text = self.getDateFromTimeStamp(timeStamp: Double(self.notis[index].date_time)!/1000)
        
        if self.notis[index].image != ""{
            cell.view_image.visibility = .visible
            self.loadPicture(imageView: cell.img_attach, url: URL(string: self.notis[index].image)!)
        }else{
            cell.view_image.visibility = .gone
        }
        cell.btn_delete.tag = index
        cell.btn_delete.addTarget(self, action: #selector(deleted), for: .touchUpInside)
        
        cell.btn_contact.tag = index
        cell.btn_contact.addTarget(self, action: #selector(contactSender), for: .touchUpInside)
        
        setRoundShadowButton(button: cell.btn_contact, corner: cell.btn_contact.frame.height/2)
        
        cell.img_attach.tag = index
        var tap = UITapGestureRecognizer(target: self, action: #selector(self.tappedImage(_:)))
        cell.img_attach.addGestureRecognizer(tap)
        cell.img_attach.isUserInteractionEnabled = true
        
        cell.view_download.tag = index
        tap = UITapGestureRecognizer(target: self, action: #selector(self.downloadImage(_:)))
        cell.view_download.addGestureRecognizer(tap)
        
        cell.view_image.sizeToFit()
        cell.txt_message.sizeToFit()
        cell.view_content.sizeToFit()
        cell.view_content.layoutIfNeeded()
        
        self.cells.append(cell)
        
        return cell
    }
    
    @objc func tappedImage(_ sender: UITapGestureRecognizer? = nil) {
        if let tag = sender?.view?.tag {
            print("Tappped Image: \(tag)")
            let imageStr = self.notis[tag].image
            
            let url = URL(string: imageStr)
            let data = try? Data(contentsOf: url!)
            let image = UIImage(data: data!)
            
            // transition
            
            let imageInfo   = GSImageInfo(image: image! , imageMode: .aspectFit)
            let transitionInfo = GSTransitionInfo(fromView: self.cells[tag].img_attach)
            let imageViewer = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
            
            // normal
            
//            let imageInfo   = GSImageInfo(image: image!, imageMode: .aspectFit)
//            let imageViewer = GSImageViewerController(imageInfo: imageInfo)
            
            imageViewer.dismissCompletion = {
                print("dismissCompletion")
            }
            
            present(imageViewer, animated: true, completion: nil)
            
        }
    }
    
    @objc func downloadImage(_ sender: UITapGestureRecognizer? = nil) {
        if let tag = sender?.view?.tag {
            print("Tappped Download: \(tag)")
            let imageStr = self.notis[tag].image
            
            let url = URL(string: imageStr)
            let data = try? Data(contentsOf: url!)
            guard let image = UIImage(data: data!) else { return }
            
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: Language().save_error, message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: Language().ok, style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: Language().saved, message: Language().image_saved, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: Language().ok, style: .default))
            present(ac, animated: true)
        }
    }
    
    @objc func deleted(sender : UIButton){
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: true
        )
        let alert = SCLAlertView(appearance: appearance)
        alert.addButton(Language().yes) {
            self.selectedNoti = self.notis[sender.tag]
            self.delNotification(noti_id: self.selectedNoti.idx)
        }
        alert.showWarning(Language().warning, subTitle: Language().suredelete)
        
    }
    
    @objc func contactSender(sender : UIButton){
        let noti = self.notis[sender.tag]
        if noti.sender_name == "Administrator"{
            let conVC = (AppDelegate.currentStoryboard?.instantiateViewController(withIdentifier: "ContactUsViewController"))!
            conVC.modalPresentationStyle = .fullScreen
            transitionVc(vc: conVC, duration: 0.3, type: .fromRight)
        }else{
            self.dialNumber(number: noti.sender_phone)
        }
    }
    
    func dialNumber(number : String) {
        if let url = URL(string: "tel://\(number)"),
            UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            // add error message here
        }
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
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text == ""{
            self.getNotifications(receiver_id: thisUser.idx)
        }else{
            notis = filter(keyword: (textField.text?.lowercased())!)
            if notis.isEmpty{
                self.showToast(msg: Language().noresult)
            }
            self.notificationList.reloadData()
        }
    }
    
    func filter(keyword:String) -> [Notification]{
        if keyword == ""{
            return searchNotis
        }
        var filteredNotis = [Notification]()
        for noti in searchNotis{
            if noti.sender_name.lowercased().contains(keyword){
                filteredNotis.append(noti)
            }else{
                if noti.sender_email.lowercased().contains(keyword){
                    filteredNotis.append(noti)
                }else{
                    if noti.sender_phone.lowercased().contains(keyword){
                        filteredNotis.append(noti)
                    }else{
                        if noti.message.contains(keyword){
                            filteredNotis.append(noti)
                        }
                    }
                }
            }
        }
        return filteredNotis
    }

    func getNotifications(receiver_id:Int64){
        self.notis.removeAll()
        self.searchNotis.removeAll()
        self.showLoadingView()
        APIs.getNotifications(member_id: receiver_id, handleCallback: {
            notifications, result_code in
            self.dismissLoadingView()
            print(result_code)
            if result_code == "0"{
                for noti in notifications!{
                    self.notis.append(noti)
                    self.searchNotis.append(noti)
                }
                if self.notis.count == 0{
                    self.notificationList.isHidden = true
                    self.showToast(msg: Language().noresult)
                }else{
                    self.notificationList.isHidden = false
                }
                
                self.notificationList.reloadData()
            }
            else{
                
            }
        })
    }
    
    func delNotification(noti_id:Int64){
        APIs.delNotification(noti_id:noti_id, handleCallback: {
            result_code in
            print(result_code)
            if result_code == "0"{
                let index = self.notis.firstIndex{$0 === self.selectedNoti}
                self.notis.remove(at: index!)
                self.searchNotis.remove(at: index!)
                self.notificationList.reloadData()
            }
            else{
                self.showToast(msg: Language().serverissue)
            }
        })
    }
    
}
