//
//  SubChapterModal.swift
//  IBAP
//
//  Created by CHARU GUPTA on 27/05/18.
//  Copyright © 2018 CritaxCorp. All rights reserved.
//

import Foundation

class SubChapterModal{
    var subChapterName:String
    var content:String
    var chapter:String
    var act_name:String
    
    init(subChapter:String,Content:String,Chapter:String,Actname:String) {
        self.subChapterName=subChapter
        self.content=Content
        self.chapter=Chapter
        self.act_name=Actname
    }
}
