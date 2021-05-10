//
//  NoResultViewController.swift
//  Qhome
//
//  Created by LGH419 on 7/30/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit

class NoResultViewController: BaseViewController {
    
    @IBOutlet weak var img_icon: UIImageView!
    @IBOutlet weak var lbl_cap: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func back(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
        self.transitionVc(vc: vc!, duration: 0.3, type: .fromLeft)
    }
    

}
