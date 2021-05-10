//
//  NotificationItemCell.swift
//  Qhome
//
//  Created by LGH419 on 7/22/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit

class NotificationItemCell: UITableViewCell {
    
    @IBOutlet weak var lbl_sendername: UILabel!
    @IBOutlet weak var lbl_time: UILabel!
    @IBOutlet weak var btn_delete: UIButton!
    @IBOutlet weak var txt_message: UITextView!
    
    @IBOutlet weak var view_image: UIView!
    @IBOutlet weak var img_attach: UIImageView!
    @IBOutlet weak var btn_contact: UIButton!
    @IBOutlet weak var view_content: UIView!
    @IBOutlet weak var view_download: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
