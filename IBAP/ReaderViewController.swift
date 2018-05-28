//
//  ReaderViewController.swift
//  IBAP
//
//  Created by CHARU GUPTA on 27/05/18.
//  Copyright © 2018 CritaxCorp. All rights reserved.
//

import UIKit
import SQLite3

class ReaderViewController: UIViewController {

    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var textView: UITextView!
    var data:[Any]?
    var dataFromsub:[Any]?
    var dataFromSubSub:[Any]?
    var bg_tag:Bool=true
    var database:OpaquePointer?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dbURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("IBAP.sqlite")
        if sqlite3_open(dbURL.path, &database) != SQLITE_OK{
            print("error opening database")
        }
        else{
            print("database open")
        }
        textView.toolbarPlaceholder="loading data..."
        if let detail = data,data != nil{
            print(detail)
            loadData(name: detail)
            
            //let data=Data(detail[].utf8)
           // if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                
                //lable2.attributedText = attributedString
            
        }
        else{
            if let details = dataFromsub, dataFromsub != nil{
            //data?.append(details[0])
                
            loadData_2(name: details)
            }
            if let details = self.dataFromSubSub, data==nil,dataFromsub==nil{
                self.loadData_3(name:details)
            }
        }
        
        

        // Do any additional setup after loading the view.
    }
    func loadData(name:[Any])->Int{
        let queryString = "SELECT * FROM BARE_ACT_SECTIONS where ACT_NAME='\(name[1] as! String)' AND SECTION_NAME='\(name[0] as! String)'"
        
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
            _ = String(cString: sqlite3_column_text(stmt, 1))
            let content = String(cString: sqlite3_column_text(stmt, 2))
            let data=Data(content.utf8)
             if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            
            textView.attributedText = attributedString
            
            
        }
            
        }
        
        return 0
    }
    func loadData_2(name:[Any])->Int{
        let queryString = "SELECT * FROM BARE_ACT_SECTIONS where ACT_NAME='\(name[3] as! String)' AND SECTION_NAME='\(name[0] as! String)' AND CHAPTER_NAME='\(name[2] as! String)'"
        
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
            _ = String(cString: sqlite3_column_text(stmt, 1))
            let content = String(cString: sqlite3_column_text(stmt, 2))
            let data=Data(content.utf8)
            if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                
                textView.attributedText = attributedString
                
                
            }
            
        }
        
        return 0
    }
    func loadData_3(name:[Any])->Int{
        
            let data=Data((name[1] as! String).utf8)
            if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                
                textView.attributedText = attributedString
                
                
            }
            
        
        
        return 0
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func highlight(_ sender: Any) {
        let Selected=textView.selectedRange
        let attributes=[NSAttributedStringKey.backgroundColor:UIColor.yellow]
        let att=[NSAttributedStringKey.foregroundColor:UIColor.green]
        textView.textStorage.addAttributes(att, range: Selected)
        textView.textStorage.addAttributes(attributes, range: Selected)
    }
    @IBOutlet weak var BackgroundChanger: UIBarButtonItem!
    
    @IBAction func Reverter(_ sender: Any) {
        if bg_tag{
            textView.backgroundColor=UIColor.black
            textView.textColor=UIColor.white
            bg_tag=false
        }
        else{
            textView.backgroundColor=UIColor.white
            textView.textColor=UIColor.black
            bg_tag=true
        }
    }
    @IBAction func addNote(_ sender: Any) {
    }
    @IBAction func bookmark(_ sender: Any) {
    }
    @IBOutlet weak var fontChange: UIBarButtonItem!
    
     @IBAction func fontChange(_ sender: Any) {
        print(textView.font?.pointSize)
        let myAttribute = [ NSAttributedStringKey.font: UIFont(name:(textView.font?.fontName)!, size: (textView.font?.pointSize)! + 18.0)! ]
        
textView.textStorage.addAttributes(myAttribute, range: NSMakeRange(0, textView.attributedText.length))
        //textView.increaseFontSize()
     }
    /*
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension UITextView {
    func increaseFontSize () {
        self.font =  UIFont(name: (self.font?.fontName)!, size: (self.font?.pointSize)!+1)!
    }
    func decreasefontSize () {
        self.font =  UIFont(name: (self.font?.fontName)!, size: (self.font?.pointSize)!-1)!
    }
    
}
