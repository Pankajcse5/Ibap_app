
//
//  ChaptersListViewController.swift
//  IBAP
//
//  Created by CHARU GUPTA on 26/05/18.
//  Copyright © 2018 CritaxCorp. All rights reserved.
//

import UIKit
import SQLite3



class ChaptersListViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    var chapterName:String?
    var database:OpaquePointer?
    var data:[ChapterListModal]=[]
    var dataTosend:[Any] = []
    var tag:Int = 0

    //@IBOutlet weak var text: UILabel!
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
        if let detail = chapterName{
            print(detail)
          //  text.text=detail
            let count=loadChaptersList(name:detail)
            if count==0 {
                loadSectionsList(name:detail)
            }
            self.tableview.reloadData()
        }
        
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loadChaptersList(name:String)->Int{
        let queryString = "SELECT * FROM BARE_ACT_CHAPTERS where ACT_NAME='\(name)'"
        
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
            let actname = String(cString: sqlite3_column_text(stmt, 2))
            
            //adding values to list
            print("id: \(id)")
            print("name: \(name)")
           // print("version: \(actname)")
            let d=ChapterListModal(Chaptername: name,actname:actname)
            self.data.append(d)
        }
        self.tableview.reloadData()
        return data.count
    }
    func loadSectionsList(name:String)->Int{
        let queryString = "SELECT * FROM BARE_ACT_SECTIONS where ACT_NAME='\(name)'"
        
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
            let actname = String(cString: sqlite3_column_text(stmt, 5))
            
            //adding values to list
            print("id: \(id)")
            print("name: \(name)")
            print("version: \(actname)")
            let d=ChapterListModal(Chaptername: name,actname:actname)
            self.data.append(d)
        }
        self.tableview.reloadData()
        return data.count
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if tag==0{
        if let destination = segue.destination as? SubChapterViewController{
            destination.data=dataTosend
        }
        }
        else if tag==1{
            if let destination = segue.destination as? ReaderViewController{
                destination.data=dataTosend
            }
        }
    }
    

}
extension ChaptersListViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chapters = data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChaptersList") as! ChapterTableViewCell
        cell.setData(list: chapters)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let d=data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChaptersList") as! ChapterTableViewCell
        
        //print(cell.getData(ActList:act))
        let url=cell.getData(list: d)
        dataTosend=url
        if (dataTosend[0] as! String).contains(".html"){
            print("section")
            tag=1
            performSegue(withIdentifier: "ReaderUI", sender: self)
        }
        else{
            print(1)
            dataTosend=url
            tag=0
            performSegue(withIdentifier: "Subchapterlist", sender: self)
        }
        //print(url)
    }
    
    
}
