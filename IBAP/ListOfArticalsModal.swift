//
//  ListOfArticalsModal.swift
//  IBAP
//
//  Created by CHARU GUPTA on 23/05/18.
//  Copyright © 2018 CritaxCorp. All rights reserved.
//

import Foundation

class ListOfArticalsModal{
    var Author_About:String
    var Author_image:String
    var Content:String
    var Title:String
    var Date:String
    var UploadedBy:String
    var Views:Any
    var Artical_pic:String
    init(about:String,image:String,content:String,title:String,date:String,uploadedby:String,views:Any,artical_pic:String) {
        self.Author_About=about
        self.Author_image=image
        self.Content=content
        self.Title=title
        self.Date=date
        self.UploadedBy=uploadedby
        self.Views=views
        self.Artical_pic=artical_pic
        
    }
}
