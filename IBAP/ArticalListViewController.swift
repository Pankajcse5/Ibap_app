//
//  ArticalListViewController.swift
//  IBAP
//
//  Created by CHARU GUPTA on 23/05/18.
//  Copyright © 2018 CritaxCorp. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import SDWebImage

class ArticalsListViewCell:UITableViewCell{
    
    @IBOutlet weak var listImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var views: UILabel!

    
    
    func SetData(list:ListOfArticalsModal) {
        listImage.sd_setImage(with: URL(string:list.Artical_pic), placeholderImage: UIImage(named: "ctc.png"))
        name.text=list.Title
        date.text=list.Date
        views.text="Views \(list.Views)"
        
    }
    func getData(list:ListOfArticalsModal) -> [Any]{
        var data:[Any]=[]
        data.append(list.Author_About)
        data.append(list.Author_image)
        data.append(list.Content)
        data.append(list.Title)
        data.append(list.Date)
        data.append(list.UploadedBy)
        data.append(list.Views)
        data.append(list.Artical_pic)
        
        return data
    }

}

class ArticalListViewController: UIViewController {
    
    var ArticalName:String?
    var articals: [ListOfArticalsModal] = []
    var collRef:CollectionReference!
    var Selected:[Any]!
    var imageView:UIImageView!

    @IBOutlet weak var titleBar: UINavigationItem!
    @IBOutlet weak var tablevw: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let db=Firestore.firestore()
        tablevw.delegate=self
        tablevw.dataSource=self
        print("hello")
        self.navigationController?.navigationBar.barTintColor=UIColor(red: 150/255, green: 31/255, blue: 53/255, alpha: 1.0 )
        self.navigationController?.navigationBar.tintColor=UIColor.white

        if let ArticalName = ArticalName{
            print(ArticalName)
            titleBar.title=ArticalName
        
        
            collRef=db.collection("Articals").document(ArticalName).collection("Lists")
        collRef.getDocuments(){(querySnapshot,err) in
            
            if let err=err{
                print("Error in getting documents"+err.localizedDescription)
                
            }
            else{
                for document in querySnapshot!.documents{
                    let docData=document.data()
                    //var a:Bool=true
                    let data=ListOfArticalsModal(about: docData["Author_about"] as! String, image: docData["Author_image"] as! String, content: docData["Content"] as! String, title: docData["Title"] as! String, date: docData["Date"] as! String, uploadedby: docData["UploadedBy"] as! String, views: docData["Views"] as! Int, artical_pic: docData["Pic"] as! String)
                    self.articals.append(data)
                   
                    
                    
                }
                
                self.tablevw.reloadData()
                
                
                
                
            }
            
            
        }
        }

        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let destination = segue.destination as? ArticalDetailsViewController{
            destination.Details=Selected
        }
    }
    

}
extension ArticalListViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let artical = articals[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "listOfArticals") as! ArticalsListViewCell
        cell.SetData(list: artical)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let art=articals[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "listOfArticals") as! ArticalsListViewCell
        
        //print(cell.getData(ActList:act))
        let url=cell.getData(list: art)
        self.Selected=url
        performSegue(withIdentifier: "ArticalDetails", sender: self)
    }
    
    
}
