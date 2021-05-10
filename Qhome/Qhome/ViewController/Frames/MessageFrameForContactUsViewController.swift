//
//  MessageFrameForContactUsViewController.swift
//  Qhome
//
//  Created by LGH419 on 7/16/19.
//  Copyright © 2019 LGH419. All rights reserved.
//

import UIKit

class MessageFrameForContactUsViewController: BaseViewController {
    
    @IBOutlet weak var view_frame: UIView!
    @IBOutlet weak var lbl_caption: UILabel!
    @IBOutlet weak var btn_send: UIButton!
    @IBOutlet weak var btn_cancel: UIButton!
    @IBOutlet weak var edt_message: UITextView!
    
    let sendicon = UIImage(named: "ic_send0_marron")
    let cancelicon = UIImage(named: "cancelicon_marron")
    

    override func viewDidLoad() {
        super.viewDidLoad()

        view_frame.layer.cornerRadius = 10
        view_frame.layer.borderColor = UIColor(rgb: 0xd9d9d9, alpha: 0.8).cgColor
        view_frame.layer.borderWidth = 1.5
        btn_cancel.visibilityh = .gone
        lbl_caption.visibilityh = .visible
        btn_send.setImage(cancelicon, for: .normal)
        edt_message.text = ""
        edt_message.setPlaceholder(string: Language().write_something)
        
        edt_message.delegate = self
        
    }
    
    func textViewDidChange(_ textView: UITextView) { //Handle the text changes here
        if textView.text?.trimmingCharacters(in: .whitespacesAndNewlines) != ""{
            btn_cancel.visibilityh = .visible
            lbl_caption.visibilityh = .gone
            btn_send.setImage(sendicon, for: .normal)
        }else{
            btn_cancel.visibilityh = .gone
            lbl_caption.visibilityh = .visible
            btn_send.setImage(cancelicon, for: .normal)
        }
        textView.checkPlaceholder()
    }
    
    @IBAction func send(_ sender: Any) {
        if edt_message.text?.trimmingCharacters(in: .whitespacesAndNewlines) != ""{
            if gCompanyViewController != nil{
                self.touchCompany()
            }else{
                self.submitMessage()
            }
        }else{
            if gContactUsViewController != nil{
                gContactUsViewController!.closeMessageFrame()
            }else if gHelpViewController != nil{
                gHelpViewController!.closeMessageFrame()
            }else if gCompanyViewController != nil{
                gCompanyViewController!.closeMessageFrame()
            }
        }
    }
    
    func adjustUITextViewHeight(arg : UITextView)
    {
        arg.translatesAutoresizingMaskIntoConstraints = true
        arg.sizeToFit()
        arg.isScrollEnabled = false
        arg.isEditable = true
    }
    
    func submitMessage(){
        self.showLoadingView()
        APIs.submitMessage(member_id:thisUser.idx, message:(edt_message.text?.trimmingCharacters(in: .whitespacesAndNewlines))!, type: "user", handleCallback: {
            result_code in
            print(result_code)
            self.dismissLoadingView()
            if result_code == "0"{
                if gContactUsViewController != nil{
                    gContactUsViewController?.showToast(msg: Language().messagesent)
                    gContactUsViewController?.closeMessageFrame()
                }else if gHelpViewController != nil{
                    gHelpViewController?.showToast(msg: Language().messagesent)
                    gHelpViewController?.closeMessageFrame()
                }else if gCompanyViewController != nil{
                    gCompanyViewController?.showToast(msg: Language().messagesent)
                    gCompanyViewController?.closeMessageFrame()
                }
            }
        })
    }
    
    func touchCompany(){
        self.showLoadingView()
        APIs.touchCompany(member_id:thisUser.idx, message:(edt_message.text?.trimmingCharacters(in: .whitespacesAndNewlines))!, handleCallback: {
            result_code in
            print(result_code)
            self.dismissLoadingView()
            if result_code == "0"{
                if gContactUsViewController != nil{
                    gContactUsViewController?.showToast(msg: Language().messagesent)
                    gContactUsViewController?.closeMessageFrame()
                }else if gHelpViewController != nil{
                    gHelpViewController?.showToast(msg: Language().messagesent)
                    gHelpViewController?.closeMessageFrame()
                }else if gCompanyViewController != nil{
                    gCompanyViewController?.showToast(msg: Language().messagesent)
                    gCompanyViewController?.closeMessageFrame()
                }
            }
        })
    }
    
    @IBAction func cancel(_ sender: Any) {
        if gContactUsViewController != nil{
            gContactUsViewController!.closeMessageFrame()
        }else if gHelpViewController != nil{
            gHelpViewController!.closeMessageFrame()
        }else if gCompanyViewController != nil{
            gCompanyViewController!.closeMessageFrame()
        }
    }
    

}
