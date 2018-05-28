//
//  SectionsModal.swift
//  IBAP
//
//  Created by CHARU GUPTA on 28/05/18.
//  Copyright © 2018 CritaxCorp. All rights reserved.
//

import Foundation
class SectionsModal{
    var section_name:String
    var content:String
    var subchapter:String
    var chapter:String
    var actname:String
    
    init(Section_name:String,Content:String,Subchapter:String,Chapter:String,ActName:String) {
        self.section_name=Section_name
        self.content=Content
        self.subchapter=Subchapter
        self.chapter=Chapter
        self.actname=ActName
    }
}
