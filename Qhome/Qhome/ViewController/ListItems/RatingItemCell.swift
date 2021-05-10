//
//  RatingItemCell.swift
//  Qhome
//
//  Created by LGH419 on 7/18/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit
import Cosmos

class RatingItemCell: UITableViewCell {
    
    @IBOutlet weak var img_user: UIImageView!
    @IBOutlet weak var view_content: UIView!
    @IBOutlet weak var lbl_username: UILabel!
    @IBOutlet weak var ratingbar: CosmosView!
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var txt_desc: UITextView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
