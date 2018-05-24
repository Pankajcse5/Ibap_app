//
//  ActTableViewCell.swift
//  IBAP
//
//  Created by CHARU GUPTA on 04/05/18.
//  Copyright © 2018 CritaxCorp. All rights reserved.
//

import UIKit

class ActTableViewCell: UITableViewCell {
    @IBOutlet weak var actName: UITextView!
    
    @IBOutlet weak var price: UITextView!
    
    func setData(ActList:ActListModal){
        actName.text=ActList.ActName
        price.text=ActList.price
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
