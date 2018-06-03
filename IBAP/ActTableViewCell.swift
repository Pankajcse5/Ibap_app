//
//  ActTableViewCell.swift
//  IBAP
//
//  Created by CHARU GUPTA on 04/05/18.
//  Copyright © 2018 CritaxCorp. All rights reserved.
//

import UIKit
import SQLite3
import Firebase
import FirebaseAuth
import FirebaseFirestore

class ActTableViewCell: UITableViewCell {
    @IBOutlet weak var actName: UILabel!
    
    @IBOutlet weak var price: UILabel!
    var database:OpaquePointer?
    var collRef:CollectionReference!
    
    @IBOutlet weak var statusicon: UIImageView!
    func setData(ActList:ActListModal){
        actName.text=ActList.ActName
        
        if !ActList.free,checkInUserPurchase(code: ActList.accessCode),!checkIntoBareActs(name: ActList.ActName){
            price.text="Purchased"
            statusicon.image=UIImage(named: "padlock-unlock.png")
        }
        else if !ActList.free,checkInUserPurchase(code: ActList.accessCode),checkIntoBareActs(name: ActList.ActName){
            price.text="Donloaded"
            statusicon.image=UIImage(named: "tick.png")
        }
        else if !ActList.free,!checkInUserPurchase(code: ActList.accessCode){
            price.text="Rs. \(ActList.price)"
            statusicon.image=UIImage(named: "padlock-unlock.png")
        }
        else if ActList.free, checkIntoBareActs(name: ActList.ActName){
            statusicon.image=UIImage(named: "tick.png")
        price.text="Downloaded"
        }
        else if ActList.free,!checkIntoBareActs(name: ActList.ActName){
            statusicon.image=UIImage(named: "download.png")
            price.text="Download"
        }
    }
    func getData(ActList:ActListModal) -> [Any]{
        var data:[Any]=[]
        data.append(ActList.ActName)
        data.append(ActList.price)
        data.append(ActList.downloadUrl)
        data.append(ActList.free)
        data.append(ActList.accessCode)
        data.append(ActList.version)
        return data
    }
    func checkIntoBareActs(name:String)->Bool{
        let dbURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("IBAP.sqlite")
        if sqlite3_open(dbURL.path, &database) != SQLITE_OK{
            print("error opening database")
        }
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
    func checkInUserPurchase(code:String)->Bool{
        let db=Firestore.firestore()
        let user=Auth.auth().currentUser
        collRef=db.collection("User Purchases")
        var status:Bool=false
        if user != nil{
            collRef.document((user?.email)!).getDocument(){(querySnapshot,err) in
            
            if let error = err{
                print("error : \(error.localizedDescription)")
            }
            else{
                let data=querySnapshot?.data()
                for item in data!{
                    if ((item.value) as! String).elementsEqual(code){
                        status = true
                    }
                }
            }
            
            }}
        else{
            print("user not logged in")
        }
        return status
        
    }
   
    
}
