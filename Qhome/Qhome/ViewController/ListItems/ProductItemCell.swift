//
//  ProductItemCell.swift
//  Qhome
//
//  Created by LGH419 on 7/17/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit

class ProductItemCell: UITableViewCell {
    
    @IBOutlet weak var view_item1: UIView!
    @IBOutlet weak var view_item2: UIView!
    @IBOutlet weak var img_picture1: UIImageView!
    
    @IBOutlet weak var lbl_price1: UILabel!
    @IBOutlet weak var btn_like1: UIButton!
    @IBOutlet weak var img_picture2: UIImageView!
    @IBOutlet weak var lbl_price2: UILabel!
    @IBOutlet weak var btn_like2: UIButton!
    @IBOutlet weak var btn_del1: UIButton!
    @IBOutlet weak var btn_del2: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
