//
//  CouponItemCell.swift
//  Qhome
//
//  Created by LGH419 on 7/22/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit

class CouponItemCell: UITableViewCell {    
    
    @IBOutlet weak var lbl_discount: UILabel!
    @IBOutlet weak var lbl_expiretime: UILabel!
    @IBOutlet weak var view_content: UIView!
    @IBOutlet weak var view_separator: UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
