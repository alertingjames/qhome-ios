//
//  ReceivedOrderItemCell.swift
//  Qhome
//
//  Created by LGH419 on 7/24/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit

class ReceivedOrderItemCell: UITableViewCell {
    
    @IBOutlet weak var lbl_productname: UILabel!
    @IBOutlet weak var lbl_storename: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var lbl_orderID: UILabel!
    @IBOutlet weak var lbl_datetime: UILabel!
    @IBOutlet weak var lbl_quantity: UILabel!
    @IBOutlet weak var lbl_status: UILabel!
    @IBOutlet weak var lbl_phone: UILabel!
    @IBOutlet weak var view_contact: UIView!
    @IBOutlet weak var img_picture: UIImageView!
    @IBOutlet weak var view_content: UIView!
    @IBOutlet weak var view_panel: UIView!
    @IBOutlet weak var btn_cancel: UIButton!
    @IBOutlet weak var btn_process: UIButton!
    @IBOutlet weak var lbl_comprice: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
