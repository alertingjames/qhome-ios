//
//  AddressItemCell.swift
//  Qhome
//
//  Created by LGH419 on 7/19/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit

class AddressItemCell: UITableViewCell {
    
    @IBOutlet weak var lbl_address: UILabel!
    @IBOutlet weak var lbl_addressline: UILabel!
    @IBOutlet weak var btn_delete: UIButton!
    @IBOutlet weak var view_content: UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
