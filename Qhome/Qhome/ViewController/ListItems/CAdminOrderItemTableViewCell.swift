//
//  CAdminOrderItemTableViewCell.swift
//  Qhome
//
//  Created by LGH419 on 10/8/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit

class CAdminOrderItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbl_storename: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var lbl_datetime: UILabel!
    @IBOutlet weak var lbl_quantity: UILabel!
    @IBOutlet weak var lbl_phone: UILabel!
    @IBOutlet weak var view_contact: UIView!
    @IBOutlet weak var img_picture: UIImageView!
    @IBOutlet weak var view_content: UIView!
    @IBOutlet weak var view_panel: UIView!
    @IBOutlet weak var lbl_comprice: UILabel!    
    @IBOutlet weak var view_contact2: UIView!
    @IBOutlet weak var lbl_phone2: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}
