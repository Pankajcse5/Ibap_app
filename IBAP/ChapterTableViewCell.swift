//
//  ChapterTableViewCell.swift
//  IBAP
//
//  Created by CHARU GUPTA on 26/05/18.
//  Copyright © 2018 CritaxCorp. All rights reserved.
//

import UIKit

class ChapterTableViewCell: UITableViewCell {

    @IBOutlet weak var sub_sub_heading: UILabel!
    
    @IBOutlet weak var chapter_name: UILabel!
    
    @IBOutlet weak var subheading: UILabel!
    func setData(list:ChapterListModal){
        print(list.chaptername.components(separatedBy: "#"))
        let components=list.chaptername.components(separatedBy: "#")
        if components.count>=3 {
            chapter_name.text=list.chaptername.components(separatedBy: "#")[0]
            
            subheading.text=list.chaptername.components(separatedBy: "#")[1]
            sub_sub_heading.text=list.chaptername.components(separatedBy: "#")[2]
        }
        else if components.count==2{
            chapter_name.text=list.chaptername.components(separatedBy: "#")[0]
        
        subheading.text=list.chaptername.components(separatedBy: "#")[1]
        //sub_sub_heading.text=list.chaptername.components(separatedBy: "#")[2
        }
        else{
            chapter_name.text=list.chaptername.replacingOccurrences(of: ".html", with: " ")
            sub_sub_heading.isHidden=true
            
        }
    }
    func getData(list:ChapterListModal)->[Any]{
        
        var data:[Any]=[]
        data.append(list.chaptername)
        data.append(list.actName)
        return data
        
    }

}
