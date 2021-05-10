//
//  AddressListViewController.swift
//  Qhome
//
//  Created by LGH419 on 7/19/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit
import SCLAlertView

class AddressListViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var addressList: UITableView!
    var addresses = [Address]()
    var gCell:AddressItemCell!
    var cells = [AddressItemCell]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addressList.delegate = self
        self.addressList.dataSource = self

        addressList.estimatedRowHeight = 120
        addressList.rowHeight = UITableView.automaticDimension
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getAddresses()
    }
    
    func getAddresses(){
        APIs.getAddresses(member_id: thisUser.idx, imei_id: gIMEI, handleCallback: {
            addresses, result_code in
            print(result_code)
            if result_code == "0"{
                self.addresses.removeAll()
                gAddresses.removeAll()
                for address in addresses!{
                    gAddresses.append(address)
                    self.addresses.append(address)
                }
                
                print("Addr Count: \(self.addresses.count)")
                
                if self.addresses.count == 0{
                    self.addressList.isHidden = true
                    self.showToast(msg: Language().noresult)
                }else{
                    self.addressList.isHidden = false
                }
                
                self.addressList.reloadData()
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:AddressItemCell = tableView.dequeueReusableCell(withIdentifier: "AddressItemCell", for: indexPath) as! AddressItemCell
        
        let index:Int = indexPath.row
        
        cell.lbl_address.text = addresses[index].address
        cell.lbl_addressline.text = addresses[index].area + ", " + addresses[index].street + ", " + addresses[index].house
        
        cell.btn_delete.tag = indexPath.row
        cell.btn_delete.addTarget(self, action: #selector(deleted), for: .touchUpInside)
        
        cell.lbl_addressline.sizeToFit()
        cell.view_content.sizeToFit()
        cell.view_content.layoutIfNeeded()
        
        self.cells.append(cell)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        gAddressId = Int64(indexPath.row)
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
            let cell:AddressItemCell = self.cells[sender.tag]
            let address = self.addresses[sender.tag]
            
            APIs.delAddress(addr_id: address.idx, handleCallback: {
                result_code in
                print(result_code)
                if result_code == "0"{
                    let index = self.addresses.firstIndex{$0 === address}
                    self.addresses.remove(at: index!)
                    self.addressList.reloadData()
                }
                else{
                    self.showToast(msg: Language().serverissue)
                }
            })
        }
        alert.showWarning(Language().warning, subTitle: Language().suredelete)
        
    }

}
