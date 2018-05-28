//
//  SubChapterTableViewCell.swift
//  IBAP
//
//  Created by CHARU GUPTA on 27/05/18.
//  Copyright © 2018 CritaxCorp. All rights reserved.
//

import UIKit
import SwiftSoup

class SubChapterTableViewCell: UITableViewCell {
    @IBOutlet weak var subchapter: UILabel!
    
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var lable2: UILabel!
    
    func setData(list:SubChapterModal){
        if list.subChapterName.contains(".html") {
            subchapter.text=list.subChapterName.replacingOccurrences(of: ".html", with: "")
            let data=Data(list.content.utf8)
            if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {

                lable2.attributedText = attributedString
            }
            //lable2.text=parseHTML(Content: list.content)
            
            label3.isHidden=true
        }
        else{
            if(list.subChapterName.contains("#")){
                let text=list.subChapterName.components(separatedBy: "#")
                if text.count>=3{
                    subchapter.text=text[0]
                    lable2.text=text[1]
                    label3.text=text[2]
                }
                else if text.count==2{
                    subchapter.text=text[0]
                    lable2.text=text[1]
                    label3.isHidden=true
                    
                }
            }
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func getData(list:SubChapterModal)->[Any]{
        var data:[Any]=[]
        data.append(list.subChapterName)
        data.append(list.content)
        data.append(list.chapter)
        data.append(list.act_name)
        return data
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func parseHTML(Content:String) -> String {
        do {
            let html = Content
            let doc: Document = try SwiftSoup.parse(html)
            print(try doc.text())
            return try doc.text()
        } catch Exception.Error(let type, let message) {
            print(message)
        } catch {
            print("error")
        }
         return "parsing error"
    }
   

}
