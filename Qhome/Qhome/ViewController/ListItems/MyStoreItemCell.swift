//
//  MyStoreItemCell.swift
//  Qhome
//
//  Created by LGH419 on 7/21/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit
import Cosmos

class MyStoreItemCell: UITableViewCell {
    
    @IBOutlet weak var view_content: UIView!
    @IBOutlet weak var img_logo: UIImageView!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_category: UILabel!
    @IBOutlet weak var img_status: UIImageView!
    @IBOutlet weak var lbl_likes: UILabel!
    @IBOutlet weak var lbl_reviews: UILabel!
    @IBOutlet weak var ratingbar: CosmosView!
    
    @IBOutlet weak var txt_desc: UITextView!    
    @IBOutlet weak var view_more: UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
