//
//  SectionViewController.swift
//  IBAP
//
//  Created by CHARU GUPTA on 28/05/18.
//  Copyright © 2018 CritaxCorp. All rights reserved.
//

import UIKit
import SQLite3

class SectionViewController: UIViewController {
    @IBOutlet weak var tableview: UITableView!
    
    var data:[Any]?
    var database:OpaquePointer?
    var sectionData:[SectionsModal]=[]
    var dataTosent:[Any]=[]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate=self
        tableview.dataSource=self
        let dbURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("IBAP.sqlite")
        if sqlite3_open(dbURL.path, &database) != SQLITE_OK{
            print("error opening database")
        }
        else{
            print("database open")
        }
       if let details = data{
            loadSections(from : details)
        tableview.reloadData()
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loadSections(from:[Any])->Int{
        let queryString = "SELECT * FROM BARE_ACT_SECTIONS where SUBCHAPTER_NAME='\(from[0] as! String)' AND CHAPTER_NAME='\(from[2] as! String)' AND ACT_NAME='\(from[3] as! String)'"
        
        //statement pointer
        var stmt:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing insert: \(errmsg)")
            return 0
        }
        
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let id = sqlite3_column_int(stmt, 0)
            let name = String(cString: sqlite3_column_text(stmt, 1))
            let content = String(cString: sqlite3_column_text(stmt, 2))
            let chapter=String(cString: sqlite3_column_text(stmt, 3))
            let subchapter=String(cString: sqlite3_column_text(stmt, 4))
            let actname=String(cString: sqlite3_column_text(stmt, 5))
            
            let data = SectionsModal(Section_name: name, Content: content, Subchapter: subchapter, Chapter: chapter, ActName: actname)
            sectionData.append(data)
            
            
        }
        self.tableview.reloadData()
        return 1
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let destination = segue.destination as? ReaderViewController{
            destination.dataFromSubSub=dataTosent
            destination.dataFromsub=nil
            destination.data=nil
        }
    }
    

}
extension SectionViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data=sectionData[indexPath.row]
        let cell=tableView.dequeueReusableCell(withIdentifier: "SectionsList") as! SectionsTableViewCell
        cell.setData(list: data)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data=sectionData[indexPath.row]
        let cell=tableView.dequeueReusableCell(withIdentifier: "SectionsList") as! SectionsTableViewCell
        let url=cell.getData(list: data)
        if (url[0] as! String).contains(".html"){
            dataTosent=url
            performSegue(withIdentifier: "ReaderUIII", sender: self)
        }
    }
    
    
}
