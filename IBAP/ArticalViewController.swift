//
//  ArticalViewController.swift
//  IBAP
//
//  Created by CHARU GUPTA on 23/05/18.
//  Copyright © 2018 CritaxCorp. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
import FirebaseFirestore

class ArticalTableViewCell:UITableViewCell{
    
    @IBOutlet weak var articalImage: UIImageView!
    @IBOutlet weak var articalName: UILabel!
    @IBOutlet weak var articalDate: UILabel!
    @IBOutlet weak var articalCount: UILabel!
    
    func SetData(articalList:ArticalListModal) {
        articalImage.sd_setImage(with: URL(string:articalList.image), placeholderImage: UIImage(named: "more.png"))
        articalImage.contentMode=UIViewContentMode.scaleToFill
        articalImage.layer.cornerRadius=10
        //loadImage(URLImage: articalList.image)
        articalName.text=articalList.name
        articalDate.text=articalList.date
        articalCount.text=articalList.count
    }
    func getData(list:ArticalListModal) -> [Any]{
            var data:[Any]=[]
            data.append(list.image)
            data.append(list.name)
            data.append(list.date)
            data.append(list.count)
            
            return data
        }
    
   func loadImage(URLImage:String){
    let imageUrl:URL = URL(string: URLImage)!
    
    // Start background thread so that image loading does not make app unresponsive
    DispatchQueue.global(qos: .userInitiated).async {
    
    let imageData:NSData = NSData(contentsOf: imageUrl)!
    
    
    // When from background thread, UI needs to be updated on main_queue
    DispatchQueue.main.async {
    let image = UIImage(data: imageData as Data)
        self.articalImage.image = image
        self.articalImage.contentMode = UIViewContentMode.scaleAspectFit
    
    }
    }
    }
}

class ArticalViewController: UIViewController {
    
     var articals: [ArticalListModal] = []
    var collRef:CollectionReference!
    
    var Selected:String!


    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let db=Firestore.firestore()
        tableView.delegate=self
        tableView.dataSource=self
        collRef=db.collection("Articals")
        collRef.getDocuments(){(querySnapshot,err) in
            
            if let err=err{
                print("Error in getting documents"+err.localizedDescription)
                
            }
            else{
                for document in querySnapshot!.documents{
                    print("\(document.documentID) => \(document.data())")
                    let docData=document.data()
                    let data=ArticalListModal(Image: docData["Image"] as! String, Name: docData["Title"] as! String,Date: docData["Date"] as! String,Count: docData["Count"] as! String)
                    self.articals.append(data)
                    //print(docData["Title"] as Any)
                }
                self.tableView.reloadData()
            }
            
            
        

        // Do any additional setup after loading the view.
    }

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ArticalListViewController{
            
            destination.ArticalName=self.Selected
            
        }
    }
    

}
extension ArticalViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(acts.count)
        return articals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let artical = articals[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "articalList") as! ArticalTableViewCell
        cell.SetData(articalList: artical)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let art=articals[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "articalList") as! ArticalTableViewCell
        
        //print(cell.getData(ActList:act))
        let url=cell.getData(list: art)
        self.Selected=url[1] as! String
        performSegue(withIdentifier: "ArticalList", sender: self)
        
    }
    
    
    
    
    }
