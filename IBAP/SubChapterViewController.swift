//
//  SubChapterViewController.swift
//  IBAP
//
//  Created by CHARU GUPTA on 27/05/18.
//  Copyright © 2018 CritaxCorp. All rights reserved.
//

import UIKit
import SQLite3

class SubChapterViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var data:[Any]?
    var database:OpaquePointer?
    var SubData:[SubChapterModal]=[]
    var dataTosent:[Any]=[]
    var bg_tag:Int=0
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate=self
        tableView.dataSource=self
        let dbURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("IBAP.sqlite")
        if sqlite3_open(dbURL.path, &database) != SQLITE_OK{
            print("error opening database")
        }
        else{
            print("database open")
        }
        print(data!)
        
        
        if let details = data{
            let count:Int=loadSubchapters(data:details)
            tableView.reloadData()
            if count==0{
                loadSectionsList(data:details)
                tableView.reloadData()
            }
       
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loadSubchapters(data:[Any])->Int{
        let queryString = "SELECT * FROM BARE_ACT_SUBCHAPTERS where CHAPTER_NAME='\(data[0] as! String)' AND ACT_NAME='\(data[1] as! String)'"
        
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
            _ = String(cString: sqlite3_column_text(stmt, 2))
            
            //adding values to list
            print("id: \(id)")
            print("name: \(name)")
            // print("version: \(actname)")
            
            let d=SubChapterModal(subChapter: name, Content: "subchapter",Chapter:data[0] as! String, Actname:data[1] as! String)
                self.SubData.append(d)
            
            
        }
        self.tableView.reloadData()
        return SubData.count
    }
    func loadSectionsList(data:[Any])->Int{
        print("call sec")
        let queryString = "SELECT * FROM BARE_ACT_SECTIONS where ACT_NAME='\(data[1] as! String)' AND CHAPTER_NAME='\(data[0] as! String)'"
        print(queryString)
        
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
            _ = sqlite3_column_int(stmt, 0)
            let name = String(cString: sqlite3_column_text(stmt, 1))
            let content = String(cString: sqlite3_column_text(stmt, 2))
            print("id: \(name)")
            print("name: \(content)")
            
            let d=SubChapterModal(subChapter: name, Content: content, Chapter: data[0] as! String, Actname: data[1] as! String)
            self.SubData.append(d)
        }
        self.tableView.reloadData()
        print(SubData.count)
       // print(SubData[1])
        return SubData.count
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if bg_tag==0{
        if let destination = segue.destination as? SectionViewController{
            destination.data=dataTosent
            
            }}
        else if bg_tag==1{
            if let destination = segue.destination as? ReaderViewController{
                destination.data=nil
                destination.dataFromsub=dataTosent
            }
        }
    }
    

}
extension SubChapterViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SubData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let subchapters = SubData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubChaptersList") as! SubChapterTableViewCell
        cell.setData(list: subchapters)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data=SubData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubChaptersList") as! SubChapterTableViewCell
        let url=cell.getData(list: data)
        print(url)
        dataTosent=url
        if (dataTosent[0] as! String).contains(".html"){
            bg_tag=1
            performSegue(withIdentifier: "ReaderUII", sender: self)
        }else{
            bg_tag=0
        performSegue(withIdentifier: "SectionsList", sender: self)
        }
    }
}

