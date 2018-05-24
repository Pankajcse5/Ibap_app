
//
//  SampleView.swift
//  IBAP
//
//  Created by CHARU GUPTA on 24/05/18.
//  Copyright © 2018 CritaxCorp. All rights reserved.
//

import UIKit
import SDWebImage

@objc protocol SampleViewDelegate{
    func dismiss()
    func setContents(imageurl:String,content:String,name:String)
}

class SampleView: UIView {
    
    weak var delegate: SampleViewDelegate?
    
    @IBOutlet weak var imageUser: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var webview: UIWebView!
    func setValue(data:[Any]?)->Bool{
        print(data as Any)
        if let details = data{
            imageUser.sd_setImage(with: URL(string: details[2] as! String), placeholderImage: UIImage(named: "ctc.png"))
            name.text = details[5] as? String
            webview.loadHTMLString(details[2] as! String, baseURL: nil)
        }
        return true
    }
    
 

}

