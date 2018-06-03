//
//  FAQViewController.swift
//  IBAP
//
//  Created by CHARU GUPTA on 03/06/18.
//  Copyright © 2018 CritaxCorp. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

struct cellData {
    var isOpen=Bool()
    var Title=String()
    var SectionData=[String]()
}

class FAQTableViewController: UITableViewController {
   
   var TableViewData = [cellData]()
    var collcRef:CollectionReference!
    

    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let db=Firestore.firestore()
        collcRef=db.collection("FAQ")
        collcRef.getDocuments(){(querySnapshot,err) in
            if err != nil{
                
            }
            else{
                for document in (querySnapshot?.documents)!{
                    let data=document.data()
                    let tabledata=cellData(isOpen: false, Title: data["Question"] as! String, SectionData: [data["Answer"] as! String])
                    self.TableViewData.append(tabledata)
                   // print(tabledata)
                    
                }
                
                self.tableView.reloadData()


            }
            
            
        }
        
    
       
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return TableViewData.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if TableViewData[section].isOpen == true{
            return TableViewData[section].SectionData.count+1
        }else{
            return 1
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataIndex=indexPath.row-1
        if indexPath.row == 0{
            guard let cell=tableView.dequeueReusableCell(withIdentifier: "FaqCell") else {return UITableViewCell()}
            cell.textLabel?.text=TableViewData[indexPath.section].Title
            return cell
        }else{
            guard let cell=tableView.dequeueReusableCell(withIdentifier: "FaqCell") else {return UITableViewCell()}
             cell.textLabel?.text=TableViewData[indexPath.section].SectionData[dataIndex]
            cell.textLabel?.backgroundColor=UIColor.green
            cell.textLabel?.textColor=UIColor.white
            return cell
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if TableViewData[indexPath.section].isOpen == true{
            TableViewData[indexPath.section].isOpen = false
            let sections=IndexSet.init(integer:indexPath.section)
            tableView.reloadSections(sections, with: .automatic)
        }else{
            TableViewData[indexPath.section].isOpen = true
            let sections=IndexSet.init(integer:indexPath.section)
            tableView.reloadSections(sections, with: .automatic)
            
        }
    }
   

}
