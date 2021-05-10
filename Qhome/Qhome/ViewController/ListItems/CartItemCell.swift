//
//  CartItemCell.swift
//  Qhome
//
//  Created by LGH419 on 7/19/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit

class CartItemCell: UITableViewCell {
    
    @IBOutlet weak var picture: UIImageView!
    
    @IBOutlet weak var lbl_productname: UILabel!
    @IBOutlet weak var lbl_storename: UILabel!
    @IBOutlet weak var lbl_quantity: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var btn_delete: UIButton!
    @IBOutlet weak var btn_addwishlist: UIButton!
    @IBOutlet weak var btn_decrease: UIButton!
    @IBOutlet weak var btn_increase: UIButton!
    @IBOutlet weak var btn_quantityok: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
