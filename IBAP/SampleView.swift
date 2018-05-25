
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
    var Data:[Any]?
    
    let view = SampleView()
    
    
    
    @IBOutlet weak var userImage: UIImageView!
    var Image:String = ""
    
    @IBOutlet weak var name: UILabel!
    @IBAction func test(_ sender: Any) {
        userImage.image=UIImage(named:"background.png")
        name.text="Pawan Tanwan"
        
    }
    init() {
        super.init(frame: CGRect.init())
        NSObject.initialize()
        print("start")
        setData()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("start")
        setData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
        print("start")
        setData()
    }
    
    
    
    
    func setValue(data:[Any]?)->Bool{
        Data=data
        return true
    }
    func setData(){
       self.name.text="unwrapped"
    }
    
    
    
    
    
 

}

