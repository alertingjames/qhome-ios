//
//  FavoriteItemCell.swift
//  Qhome
//
//  Created by LGH419 on 7/21/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit

class FavoriteItemCell: UITableViewCell {
    
    @IBOutlet weak var img_logo1: UIImageView!
    @IBOutlet weak var lbl_name1: UILabel!
    @IBOutlet weak var btn_delete1: UIButton!
    @IBOutlet weak var view_item1: UIView!
    @IBOutlet weak var view_item2: UIView!
    @IBOutlet weak var img_logo2: UIImageView!
    @IBOutlet weak var lbl_name2: UILabel!
    @IBOutlet weak var btn_delete2: UIButton!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
