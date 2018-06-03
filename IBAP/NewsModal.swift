//
//  NewsModal.swift
//  IBAP
//
//  Created by CHARU GUPTA on 30/05/18.
//  Copyright © 2018 CritaxCorp. All rights reserved.
//

import Foundation

class NewsModal{
    var Title:String
    var description:String
    var date:Date
    var link:String
    
    init(title:String,Desc:String,Date:Date,Link:String) {
        self.Title=title
        self.description=Desc
        self.date=Date
        self.link=Link
    }
    
}
