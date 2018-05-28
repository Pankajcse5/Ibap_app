//
//  SectionsTableViewCell.swift
//  IBAP
//
//  Created by CHARU GUPTA on 28/05/18.
//  Copyright © 2018 CritaxCorp. All rights reserved.
//

import UIKit

class SectionsTableViewCell: UITableViewCell {
    @IBOutlet weak var sectionName: UILabel!
    
    @IBOutlet weak var sectionDiscription: UILabel!
    
    func setData(list:SectionsModal){
        sectionName.text=list.section_name.replacingOccurrences(of: ".html", with: "")
        let data=Data(list.content.utf8)
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            
            sectionDiscription.attributedText = attributedString
        }
        //sectionDiscription.text=list.content
    }
    func getData(list:SectionsModal)->[Any]{
        var data:[Any]=[]
        data.append(list.section_name)
        data.append(list.content)
        data.append(list.subchapter)
        data.append(list.chapter)
        data.append(list.actname)
        return data
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
