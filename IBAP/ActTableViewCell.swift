//
//  ActTableViewCell.swift
//  IBAP
//
//  Created by CHARU GUPTA on 04/05/18.
//  Copyright © 2018 CritaxCorp. All rights reserved.
//

import UIKit

class ActTableViewCell: UITableViewCell {
    @IBOutlet weak var actName: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var statusicon: UIImageView!
    func setData(ActList:ActListModal){
        actName.text=ActList.ActName
        if !ActList.free{
            price.text="Rs. \(ActList.price)"
            statusicon.image=UIImage(named: "padlock-unlock.png")
        }
        else{
            statusicon.image=UIImage(named: "download.png")
        price.text="Free"
        }
    }
    func getData(ActList:ActListModal) -> [Any]{
        var data:[Any]=[]
        data.append(ActList.ActName)
        data.append(ActList.price)
        data.append(ActList.downloadUrl)
        data.append(ActList.free)
        data.append(ActList.accessCode)
        data.append(ActList.version)
        return data
    }
   
    
}
