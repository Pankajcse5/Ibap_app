//
//  HomeViewController.swift
//  IBAP
//
//  Created by CHARU GUPTA on 04/05/18.
//  Copyright © 2018 CritaxCorp. All rights reserved.
//

import UIKit
import Firebase
import Zip
import SQLite3
import Dropper
import FCAlertView
import SwiftOverlays
import JJFloatingActionButton
import EggRating

class HomeViewController: UIViewController {
    
    var collRef:CollectionReference!    
    var acts: [ActListModal] = []
    var database:OpaquePointer?
    let dropper = Dropper(width: 64, height: 200)
    var p:Int!
    var data:String!
    var tag:Int=0
    
    var fcdata:[Any]=[]
  
    @IBOutlet weak var dropdownbutton: UIButton!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var tableviewrules: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        EggRating.itunesId="kanishk.agrwl@gmail.com"
        EggRating.minRatingToAppStore=3.5
        EggRating.daysUntilPrompt=2
        EggRating.debugMode=false
        EggRating.minuteUntilPrompt=60
        EggRating.appVersion="1.0"
        
        EggRating.promptRateUsIfNeeded(in: self)
        let actionButton = JJFloatingActionButton()
        
        actionButton.addItem(title: "Request to submit", image: UIImage(named: "First")?.withRenderingMode(.alwaysTemplate)) { item in
            // do something
            /*let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ActSubmittion") as! SubmitActViewController
            self.present(nextViewController, animated:true, completion:nil)*/
            self.performSegue(withIdentifier: "SubmitAct", sender: self)
        }
        
        actionButton.addItem(title: "Help", image: UIImage(named: "Second")?.withRenderingMode(.alwaysTemplate)) { item in
            // do something
        }
        
        actionButton.addItem(title: "Contact", image: nil) { item in
            // do something
        }
        
        view.addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        actionButton.overlayView.backgroundColor=UIColor.brown
        actionButton.buttonColor=UIColor.init(rgba: 0xA2b6b6)

        
        self.showWaitOverlay()
        
        let db=Firestore.firestore()
        //let settings = db.settings
        //settings.areTimestampsInSnapshotsEnabled = true
        // db.settings = settings
        self.navigationController?.navigationBar.backgroundColor=UIColor.red
        dropper.delegate=self
        table.dataSource=self
        table.delegate=self
        //alert.delegate=self
        p=0
        collRef=db.collection("BareActs")
        collRef.getDocuments(){(querySnapshot,err) in
            
            if let err=err{
                print("Error in getting documents"+err.localizedDescription)
                
            }
            else{
                for document in querySnapshot!.documents{
                    //print("\(document.documentID) => \(document.data())")
                    let docData=document.data()
                    let data=ActListModal(actName: docData["Title"] as! String, price: docData["Price"] as! String,Free: docData["Free"] as! Bool,DownloadUrl: docData["Url"] as! String, AccessCode: docData["Access code"] as! String,Version: docData["Version"] as! String)
                    self.acts.append(data)
                    //print(docData["Title"] as Any)
                }
                self.removeAllOverlays()
                self.table.reloadData()
            }
            
            
        }
        let dbURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        .appendingPathComponent("IBAP.sqlite")
        if sqlite3_open(dbURL.path, &database) != SQLITE_OK{
            print("error opening database")
        }
        else{
            if sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS BARE_ACT_LIST (ACT_ID INTEGER PRIMARY KEY AUTOINCREMENT, ACT_NAME TEXT, VERSION TEXT)", nil, nil, nil) != SQLITE_OK{
                let errormsg=String(cString: sqlite3_errmsg(database)!)
                print("Bare act table error :\(errormsg)")
            }
            if sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS BARE_ACT_CHAPTERS (CHAPTER_ID INTEGER PRIMARY KEY AUTOINCREMENT, CHAPTER_NAME TEXT, ACT_NAME TEXT)", nil, nil, nil) != SQLITE_OK{
                let errormsg=String(cString: sqlite3_errmsg(database)!)
                print("Bare act table error :\(errormsg)")
            
            }
            if sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS BARE_ACT_SUBCHAPTERS (SUBCHAPTER_ID INTEGER PRIMARY KEY AUTOINCREMENT, SUBCHAPTER_NAME TEXT,CHAPTER_NAME TEXT, ACT_NAME TEXT)", nil, nil, nil) != SQLITE_OK{
                let errormsg=String(cString: sqlite3_errmsg(database)!)
                print("Bare act table error :\(errormsg)")
            }
            if sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS BARE_ACT_SECTIONS (SECTION_ID INTEGER PRIMARY KEY AUTOINCREMENT,SECTION_NAME TEXT,SECTION_CONTENT TEXT,CHAPTER_NAME TEXT,SUBCHAPTER_NAME TEXT, ACT_NAME TEXT)", nil, nil, nil) != SQLITE_OK{
                let errormsg=String(cString: sqlite3_errmsg(database)!)
                print("Bare act table error :\(errormsg)")
            }
            
        }

    
    }

    @IBAction func switchList(_ sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
        p = sender.selectedSegmentIndex
        let db=Firestore.firestore()
        acts.removeAll()
        switch p {
        case 0:
            collRef=db.collection("BareActs")
            collRef.getDocuments(){(querySnapshot,err) in
                
                if let err=err{
                    print("Error in getting documents"+err.localizedDescription)
                    
                }
                else{
                    for document in querySnapshot!.documents{
                        //print("\(document.documentID) => \(document.data())")
                        let docData=document.data()
                        let data=ActListModal(actName: docData["Title"] as! String, price: docData["Price"] as! String,Free: docData["Free"] as! Bool,DownloadUrl: docData["Url"] as! String, AccessCode: docData["Access code"] as! String,Version: docData["Version"] as! String)
                        self.acts.append(data)
                        //print(docData["Title"] as Any)
                    }
                    self.table.reloadData()
                }
                
                
            }
        case 1:
            collRef=db.collection("Ruless")
            collRef.getDocuments(){(querySnapshot,err) in
                
                if let err=err{
                    print("Error in getting documents"+err.localizedDescription)
                    
                }
                else{
                    for document in querySnapshot!.documents{
                        //print("\(document.documentID) => \(document.data())")
                        let docData=document.data()
                        let data=ActListModal(actName: docData["Title"] as! String, price: docData["Price"] as! String,Free: docData["Free"] as! Bool,DownloadUrl: docData["Url"] as! String, AccessCode: docData["Access code"] as! String,Version: docData["Version"] as! String)
                        self.acts.append(data)
                        //print(docData["Title"] as Any)
                    }
                    self.table.reloadData()
                }
                
                
            }
        default:
            print("loading default")
        }
        table.reloadData()
    }
    @IBOutlet weak var switchList: UISegmentedControl!
    @IBAction func ShowMenu(_ sender: Any) {
        print("Showmenu")
        if dropper.status == .hidden{
        dropper.items = ["note.png","agenda.png","highlighter-3.png"]
            dropper.cornerRadius=10
            dropper.border=(width: 1.0,color: UIColor.white)
            dropper.theme = Dropper.Themes.white
            dropper.delegate = self
            dropper.cornerRadius = 3
            dropper.showWithAnimation(0.15, options: Dropper.Alignment.center, button: dropdownbutton)
        }else{
            dropper.hideWithAnimation(0.2)
        }
    }
    
    @IBAction func files(_ sender: Any) {
        
        let file:URL=(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL?)!
        //print(file.absoluteString)
        
        
        
        
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: file, includingPropertiesForKeys: nil)
            for item in fileURLs{
                print(item)
               /* if item.hasDirectoryPath, !item.lastPathComponent.hasSuffix("zip"){
                    //print(item.lastPathComponent)
                    
                    let list = try FileManager.default.contentsOfDirectory(at: item, includingPropertiesForKeys: nil)
                    for items in list{
                        print(items.lastPathComponent)
                        let list1 = try FileManager.default.contentsOfDirectory(at: items, includingPropertiesForKeys: nil)
                        for items in list1{
                            print(items.lastPathComponent)
                        }
                    }
                }
                else{
                    //print(item.lastPathComponent)
                }*/
            }
            //print(fileURLs[0].absoluteURL.absoluteString)
            //try Folder.init(path: fileURLs[0].absoluteURL.absoluteString).makeSubfolderSequence(recursive: true).forEach { folder in
              //  print("Name : \(folder.name), parent: \(folder.parent)")
            //}
            /*
            let fileManager = FileManager.default

            let enumerator:FileManager.DirectoryEnumerator = fileManager.enumerator(atPath: fileURLs[0].absoluteString)!
            while let element = enumerator.nextObject() as?  String {
                if element.hasSuffix("html") {
                    // checks the extension
                    print(element)
                }
                else{
                    print("print else:\(element)")
                }
 
            }
             
*/
            
        } catch {
            print("Error while enumerating files \(file.path): \(error.localizedDescription)")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if tag==0 {
        
        if let destination = segue.destination as? ChaptersListViewController{
            destination.chapterName=data
        }
        }
        else if tag==1{
            if let destination = segue.destination as? CartViewController{
                destination.data=fcdata
            }
        }
    }
    
    
    

}
extension HomeViewController:DropperDelegate{
    func DropperSelectedRow(_ path: IndexPath, contents: String) {
        print(contents)
    }
}
extension HomeViewController: UITableViewDelegate,UITableViewDataSource,FCAlertViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(acts.count)
        return acts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Act = acts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "actsList") as! ActTableViewCell
        cell.setData(ActList: Act)
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else{ return }
        acts.remove(at: indexPath.row)
        
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
    }
    func checkIntoBareAct(name:String)->Bool{
        let queryString = "SELECT * FROM BARE_ACT_LIST WHERE ACT_NAME='\(name)'"
        
        //statement pointer
        var stmt:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing insert: \(errmsg)")
            
        }
        
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            return true
        }
        
        return false
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let act=acts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "actsList") as! ActTableViewCell

        //print(cell.getData(ActList:act))
        let url=cell.getData(ActList: act)
        print(url[2]  as! String)
        let check:Bool=checkIntoBareAct(name: url[0] as! String)
        var code=url[4] as! String
        let isfree=url[3] as! Bool
        if isfree,check{
            tag=0
            data=url[0] as! String
            performSegue(withIdentifier: "ChapterList", sender: self)
        }
        else if isfree,!check{
            let alert=FCAlertView()
            alert.delegate=self
            print("fcalert")
            fcdata=url
            alert.blurBackground=true
            alert.animateAlertInFromTop=true
            alert.autoHideSeconds=5
            alert.dismissOnOutsideTouch=true
            alert.hideDoneButton=true
            alert.showAlert(inView: self, withTitle: "Download item : \(url[0] as! String)", withSubtitle: "Downloding this item will make the item as offline available", withCustomImage:UIImage(named: "download.png"), withDoneButtonTitle: nil, andButtons: ["Cancel","Download"])
           // downloadItem(url: url)
        
        }else if !isfree,check{
            data=url[0] as! String
            performSegue(withIdentifier: "ChapterList", sender: self)
        }
        else if !isfree,!check{
            showPurshase(url:url)
        }
        
       
       
        
    }
    func showPurshase(url:[Any]){
        tag=1
        let alert=FCAlertView()
        alert.delegate=self
        print("fcalert")
        fcdata=url
        alert.blurBackground=true
        alert.animateAlertInFromTop=true
        alert.autoHideSeconds=15
        alert.dismissOnOutsideTouch=true
        alert.hideDoneButton=true
        alert.showAlert(inView: self, withTitle: "item : \(url[0] as! String)", withSubtitle:"Price : \(url[1] as! String)", withCustomImage:UIImage(named: "download.png"), withDoneButtonTitle: nil, andButtons: ["Cancel","Buy now"])
    }
    func fcAlertView(_ alertView: FCAlertView, clickedButtonIndex index: Int, buttonTitle title: String) {
        
        if title == "Cancel" {
            print("cancel")
            alertView.dismiss()
            
        }else if title == "Download"{
            print("dnld")
           
            downloadItem(url: fcdata)
        }
        else if title == "Buy now"{
            performSegue(withIdentifier: "CartView", sender: self)
        }
    }
    func downloadItem(url:[Any]){
        let file:URL=(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL?)!
        let destinationPath=file.appendingPathComponent("temp.zip")
        print(destinationPath)
        let storage=Storage.storage()
        let storageRef=storage.reference(forURL: url[2] as! String)
        print(storageRef.name)
        let downloadTask=storageRef.write(toFile: destinationPath){url,error in
            if let error=error{
                print(error.localizedDescription)
            }
            else{
                
            }
        }
        _=downloadTask.observe(.progress){
            snapshot in
            print(snapshot.progress as Any)
        }
        downloadTask.observe(.success){(snapshot) in
            //print(snapshot.progress?.completedUnitCount as Any)
            print(snapshot.reference.name)
            do{
                let documentsDirectory = FileManager.default.urls(for:.documentDirectory, in: .userDomainMask)[0]
                //let path=documentsDirectory.appendingPathComponent(snapshot.reference.name)
                try Zip.unzipFile(destinationPath, destination: documentsDirectory, overwrite: true, password: nil,progress: {(progress) -> () in
                    print(progress.rounded())
                })
                print(url[5] as! String)
                //readValues()
                
                self.storeInDatabase(path: file.appendingPathComponent(snapshot.reference.name.replacingOccurrences(of: ".zip", with:  "")).deletingLastPathComponent(),name : url[0] as! String,version : url[5] as! String)
            }
            catch{
                print("something went wrong!")
            }
            /*
             
             do {
             let fileURLs = try FileManager.default.contentsOfDirectory(at: file, includingPropertiesForKeys: nil)
             //    print(fileURLs[1])
             // process files
             
             for item in fileURLs{
             let name=snapshot.reference.name
             if item.hasDirectoryPath, !item.lastPathComponent.elementsEqual(name.replacingOccurrences(of: ".zip", with: "")){
             //print(item.lastPathComponent)
             
             print(name.replacingOccurrences(of: ".zip", with: ""))
             let fileenum : FileManager.DirectoryEnumerator? = FileManager.default.enumerator(atPath:item.absoluteString)
             
             while let item = fileenum?.nextObject() as? String{
             print(item)
             }
             
             
             
             }
             else{
             //print(item.lastPathComponent)
             }
             }
             } catch {
             print("Error while enumerating files \(file.path): \(error.localizedDescription)")
             }*/
            
            
        }
        downloadTask.observe(.failure) { snapshot in
            guard let errorCode = (snapshot.error as NSError?)?.code else {
                return
            }
            guard let error = StorageErrorCode(rawValue: errorCode) else {
                return
            }
            switch (error) {
            case .objectNotFound:
                // File doesn't exist
                break
            case .unauthorized:
                // User doesn't have permission to access file
                break
            case .cancelled:
                // User cancelled the download
                break
                
                /* ... */
                
            case .unknown:
                // Unknown error occurred, inspect the server response
                break
            default:
                // Another error occurred. This is a good place to retry the download.
                break
            }
        }
        
    }
        func storeInDatabase(path:URL,name:String,version:String)->Bool{
            //print("intial : \(path.absoluteString) ")
            if !checkIntoBareActs(name: name){
                InsertIntoBareActs(Actname:name,Version:version)
                print("values inserted")
            }
            else{
                print("item found")
            }
            do{
            let files = try FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil)
                //if FileManager.default.fileExists(atPath: path.absoluteString){
                for file in files{
                    
                    //print(file.absoluteString.hasSuffix("html"))
                    //print(file.lastPathComponent.hasSuffix("html"))
                    if file.lastPathComponent.hasSuffix("html"){
                        //print("file: \(file.lastPathComponent)")
                        
            
                        do{
                            let content=try String(contentsOf: file)
                            
                        
//print(file.lastPathComponent)
                            InsertIntoSections(Name:file.lastPathComponent,Content:content,parent:file.deletingLastPathComponent().lastPathComponent,parent_parent:file.deletingLastPathComponent().deletingLastPathComponent().lastPathComponent,actName:name)
                        }
                        catch{
                            
                        }
                    }else{
                        if file.lastPathComponent.contains("Chapter") || file.lastPathComponent.contains("CHAPTER") || file.lastPathComponent.contains("chapter") || file.lastPathComponent.contains("Part") || file.lastPathComponent.contains("PART") || file.lastPathComponent.contains("part") ||
                            file.lastPathComponent.contains("SCHEDULE") || file.lastPathComponent.contains("Order") ||
                            file.lastPathComponent.contains("ORDER") || file.lastPathComponent.contains("order") ||
                            file.lastPathComponent.contains("Schedule")
                            {
                                let parent = file.deletingLastPathComponent()
                                if parent.lastPathComponent.contains("Chapter") || parent.lastPathComponent.contains("CHAPTER") || parent.lastPathComponent.contains("chapter") || parent.lastPathComponent.contains("Part") || parent.lastPathComponent.contains("PART") || parent.lastPathComponent.contains("part"){
                                    InsertIntoSubChapters(Name:file.lastPathComponent,Parent:parent.lastPathComponent,actName:name)
                                   // print("subchapter called \(file.lastPathComponent)")
                                    
                                }
                                else{
                                   InsertIntoChapters(Name:file.lastPathComponent,Parent:file.deletingLastPathComponent().lastPathComponent)
                                   // print("chapter called \(file.lastPathComponent)")
                                }
                                
                            
                        }
                        
                            if !checkIntoBareActs(name: name) && !path.lastPathComponent.elementsEqual(name){
                            InsertIntoBareActs(Actname:name,Version:version)
                                print("values inserted")
                            }
                            else{
                                print("item found")
                            }
                            
                        
                        //print(file.lastPathComponent)
                        
                        storeInDatabase(path: file, name: name, version: version)
                    }
                }
                //}
            }catch{
                
            }
            return true
        }
        func InsertIntoBareActs(Actname:String,Version:String){
            print(Version)
            var stmt:OpaquePointer?
            let query = "INSERT INTO BARE_ACT_LIST (ACT_NAME,VERSION) VALUES(?,?)"
            if sqlite3_prepare(database, query, -1, &stmt, nil) != SQLITE_OK{
                
            }
            if sqlite3_bind_text(stmt, 1,(Actname as NSString).utf8String, -1, nil) != SQLITE_OK {
                
            }
            if sqlite3_bind_text(stmt, 2,(Version as NSString).utf8String, -1, nil) != SQLITE_OK {
                
            }
            if sqlite3_step(stmt) != SQLITE_DONE{
                
            }
            else{
                print("values inserted!")
                //readValues()
            }
        }
        
        func checkIntoBareActs(name:String)->Bool{
            let queryString = "SELECT * FROM BARE_ACT_LIST WHERE ACT_NAME='\(name)'"
            
            //statement pointer
            var stmt:OpaquePointer?
            
            //preparing the query
            if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(database)!)
                print("error preparing insert: \(errmsg)")
                
            }
            
            //traversing through all the records
            while(sqlite3_step(stmt) == SQLITE_ROW){
                return true
            }
            
            return false
        }
        func InsertIntoChapters(Name:String,Parent:String){
            var stmt:OpaquePointer?
            let query = "INSERT INTO BARE_ACT_CHAPTERS (CHAPTER_NAME,ACT_NAME) VALUES(?,?)"
            if sqlite3_prepare(database, query, -1, &stmt, nil) != SQLITE_OK{
                
            }
            if sqlite3_bind_text(stmt, 1,(Name as NSString).utf8String, -1, nil) != SQLITE_OK {
                
            }
            if sqlite3_bind_text(stmt, 2,(Parent as NSString).utf8String, -1, nil) != SQLITE_OK {
                
            }
            if sqlite3_step(stmt) != SQLITE_DONE{
                
            }
            else{
                print(" chapter values inserted!")
                //readValues()
            }
            
        }
        func InsertIntoSubChapters(Name:String,Parent:String,actName:String){
            var stmt:OpaquePointer?
            print(Name)
            let query = "INSERT INTO BARE_ACT_SUBCHAPTERS (SUBCHAPTER_NAME,CHAPTER_NAME,ACT_NAME) VALUES(?,?,?)"
            if sqlite3_prepare(database, query, -1, &stmt, nil) != SQLITE_OK{
                
            }
            
            if sqlite3_bind_text(stmt, 1,(Name as NSString).utf8String, -1, nil) != SQLITE_OK {
                
            }
            if sqlite3_bind_text(stmt, 2,(Parent as NSString).utf8String, -1, nil) != SQLITE_OK {
                
            }
            if sqlite3_bind_text(stmt, 3, (actName as NSString).utf8String, -1, nil) != SQLITE_OK{
                
            }
            if sqlite3_step(stmt) != SQLITE_DONE{
                
            }
            else{
                print(" sub chapter values inserted!")
                //readValues()
            }
            
        }
        func InsertIntoSections(Name:String,Content:String,parent:String,parent_parent:String,actName:String){
            var stmt:OpaquePointer?
            let query = "INSERT INTO BARE_ACT_SECTIONS (SECTION_NAME,SECTION_CONTENT,CHAPTER_NAME,SUBCHAPTER_NAME,ACT_NAME) VALUES(?,?,?,?,?)"
            if sqlite3_prepare(database, query, -1, &stmt, nil) != SQLITE_OK{
                
            }
            print("parent:  :  \(parent)")
            print("subsparent:  :  \(parent_parent)")
            
           // print(Name)
            if sqlite3_bind_text(stmt, 1,(Name as NSString).utf8String, -1, nil) != SQLITE_OK {
                
            }
            if sqlite3_bind_text(stmt, 2, (Content as NSString).utf8String, -1, nil) != SQLITE_OK{
                
            }
            if parent_parent.elementsEqual(actName){
            if sqlite3_bind_text(stmt, 3, (parent as NSString).utf8String, -1, nil) != SQLITE_OK{
                
            }
            
            
            if sqlite3_bind_text(stmt, 4, (parent as NSString).utf8String, -1, nil) != SQLITE_OK{
                
            }
            }
            else if parent_parent.elementsEqual("Documents"){
                if sqlite3_bind_text(stmt, 3, (parent as NSString).utf8String, -1, nil) != SQLITE_OK{
                    
                }
                
                
                if sqlite3_bind_text(stmt, 4, (parent as NSString).utf8String, -1, nil) != SQLITE_OK{
                    
                }
            }
            else{
                if sqlite3_bind_text(stmt, 3, (parent_parent as NSString).utf8String, -1, nil) != SQLITE_OK{
                    
                }
                
                
                if sqlite3_bind_text(stmt, 4, (parent as NSString).utf8String, -1, nil) != SQLITE_OK{
                    
                }
            }
            
            if sqlite3_bind_text(stmt,5, (actName as NSString).utf8String, -1, nil) != SQLITE_OK{
                
            }
            if sqlite3_step(stmt) != SQLITE_DONE{
                
            }
            else{
                //print(" section values inserted!")
                //readValues()
            }
        }
        func readValues(){
            
            //first empty the list of heroes
            
            
            //this is our select query
            let queryString = "SELECT * FROM BARE_ACT_LIST"
            
            //statement pointer
            var stmt:OpaquePointer?
            
            //preparing the query
            if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(database)!)
                print("error preparing insert: \(errmsg)")
                return
            }
            
            //traversing through all the records
            while(sqlite3_step(stmt) == SQLITE_ROW){
                let id = sqlite3_column_int(stmt, 0)
                let name = String(cString: sqlite3_column_text(stmt, 1))
                let version = String(cString: sqlite3_column_text(stmt, 2))
            
                //adding values to list
                print("id: \(id)")
                print("name: \(name)")
                print("version: \(version)")
            }
            
        }
    }
extension HomeViewController:EggRatingDelegate{
    func didRate(rating rate: Double) {
        
    }
    
    func didIgnoreToRate() {
        
    }
    
    func didRateOnAppStore() {
        
    }
    
    func didIgnoreToRateOnAppStore() {
        
    }
    
    
}
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, alpha: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        assert(alpha >= 0 && alpha <= 255, "Invalid alpha component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alpha) / 255.0)
    }
    
    convenience init(rgba: Int) {
        self.init(
            red: (rgba >> 16) & 0xFF,
            green: (rgba >> 8) & 0xFF,
            blue: rgba & 0xFF,
            alpha: rgba & 0xFF
        )
    }
}
    
    

