//
//  PhoneListViewController.swift
//  Qhome
//
//  Created by LGH419 on 7/19/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit
import SCLAlertView

class PhoneListViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var phoneList: UITableView!
    
    var phones = [Phone]()
    var gCell:PhoneItemCell!
    var cells = [PhoneItemCell]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.phoneList.delegate = self
        self.phoneList.dataSource = self
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.getPhones()
    }
    
    func getPhones(){
        APIs.getPhones(member_id: thisUser.idx, imei_id: gIMEI, handleCallback: {
            phones, result_code in
            print(result_code)
            if result_code == "0"{
                gPhones.removeAll()
                self.phones.removeAll()
                for phone in phones!{
                    gPhones.append(phone)
                    self.phones.append(phone)
                }
                
                if self.phones.count == 0{
                    self.phoneList.isHidden = true
                    self.showToast(msg: Language().noresult)
                }else{
                    self.phoneList.isHidden = false
                }
                
                self.phoneList.reloadData()
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return phones.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:PhoneItemCell = tableView.dequeueReusableCell(withIdentifier: "PhoneItemCell", for: indexPath) as! PhoneItemCell
        
        let index:Int = indexPath.row
        
        cell.lbl_phone.text = phones[index].phoneNumber
        
        cell.btn_delete.tag = indexPath.row
        cell.btn_delete.addTarget(self, action: #selector(deleted), for: .touchUpInside)
        
        self.cells.append(cell)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        gPhoneId = Int64(indexPath.row)
        gAddressViewController.dismissViewController()
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
            let cell:PhoneItemCell = self.cells[sender.tag]
            let phone = self.phones[sender.tag]
            
            APIs.delPhone(phone_id: phone.idx, handleCallback: {
                result_code in
                print(result_code)
                if result_code == "0"{
                    let index = self.phones.firstIndex{$0 === phone}
                    self.phones.remove(at: index!)
                    self.phoneList.reloadData()
                }
                else{
                    self.showToast(msg: Language().serverissue)
                }
            })
        }
        alert.showWarning(Language().warning, subTitle: Language().suredelete)
        
    }

}
