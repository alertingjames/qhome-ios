//
//  NotisViewController.swift
//  Qhome
//
//  Created by LGH419 on 7/28/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit
import Kingfisher
import SCLAlertView
import GSImageViewerController

class NotisViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var notiList: UITableView!
    var notis = [Notification]()
    var cells = [NotificationItemCell]()
    var selectedNoti:Notification!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        notiList.delegate = self
        notiList.dataSource = self
        
        notiList.estimatedRowHeight = 120
        notiList.rowHeight = UITableView.automaticDimension
    
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
        cell.btn_contact.addTarget(self, action: #selector(ok), for: .touchUpInside)
        
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
    
    @objc func ok(sender : UIButton){
        let noti = self.notis[sender.tag]
        self.notis.remove(at: sender.tag)
        self.notiList.reloadData()
        gHomeViewController.refs[sender.tag].removeValue()
        gHomeViewController.refs.remove(at: sender.tag)
        gHomeViewController.count -= 1
        gBadgeCount = gHomeViewController.count
        gHomeViewController.lbl_noticount.text = String(gBadgeCount)
        UIApplication.shared.applicationIconBadgeNumber = gBadgeCount
        if gBadgeCount == 0{
            gHomeViewController.view_notification.visibilityh = .gone
            self.dismiss(animated: true, completion: nil)
        }
        if noti.sender_name == Language().admin{
            print("Tapped on Admin Noti")
            print("LocalizedLowercase: \(noti.message.localizedLowercase)")
            if noti.message.localizedLowercase.contains("store"){
                gHomeViewController.getStores(member_id: thisUser.idx)
            }else if noti.message.localizedLowercase.contains("lucky") && !noti.message.localizedLowercase.contains("order"){
                let vc = AppDelegate.currentStoryboard.instantiateViewController(withIdentifier: "LuckyDrawViewController")
                self.transitionVc(vc: vc, duration: 0.3, type: .fromRight)
            }
        }else{
            if noti.message.localizedLowercase.contains("upgraded") && noti.message.localizedLowercase.contains("order"){
                let vc = AppDelegate.currentStoryboard.instantiateViewController(withIdentifier: "MyOrdersViewController")
                self.transitionVc(vc: vc, duration: 0.3, type: .fromRight)
            }else if noti.message.localizedLowercase.contains("customer's new order:"){
                let vc = AppDelegate.currentStoryboard.instantiateViewController(withIdentifier: "ManageAccountViewController")
                self.transitionVc(vc: vc, duration: 0.3, type: .fromRight)
            }
        }
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
            self.notis.remove(at: sender.tag)
            self.notiList.reloadData()
            gHomeViewController.refs[sender.tag].removeValue()
            gHomeViewController.refs.remove(at: sender.tag)
            gHomeViewController.count -= 1
            gBadgeCount = gHomeViewController.count
            gHomeViewController.lbl_noticount.text = String(gBadgeCount)
            UIApplication.shared.applicationIconBadgeNumber = gBadgeCount
            if gBadgeCount == 0{
                gHomeViewController.view_notification.visibilityh = .gone
                self.dismiss(animated: true, completion: nil)
            }
        }
        alert.showWarning(Language().warning, subTitle: Language().suredelete)
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.notiList.reloadData()
    }
    
    func getNotifications(){
        
    }
    
    func delNotification(noti_id:Int64){
        
    }

}
