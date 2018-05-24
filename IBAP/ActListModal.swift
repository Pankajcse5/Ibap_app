//
//  ActListModal.swift
//  IBAP
//
//  Created by CHARU GUPTA on 04/05/18.
//  Copyright © 2018 CritaxCorp. All rights reserved.
//

import Foundation
class ActListModal{
    var ActName:String
    var price:String
    var free:Bool
    var downloadUrl:String
    var accessCode:String
    var version:String
    
    init(actName:String,price:String,Free:Bool,DownloadUrl:String,AccessCode:String,Version:String) {
        self.ActName=actName
        self.price=price
        self.free=Free
        self.downloadUrl=DownloadUrl
        self.accessCode=AccessCode
        self.version=Version
    }
}
