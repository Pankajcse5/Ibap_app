//
//  ProfileViewController.swift
//  IBAP
//
//  Created by CHARU GUPTA on 01/06/18.
//  Copyright © 2018 CritaxCorp. All rights reserved.
//

import UIKit
import SwiftOverlays
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FCAlertView

class ProfileViewController: UIViewController,FCAlertViewDelegate {
    
    var collRef:CollectionReference!

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var credits: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var referral_code: UILabel!
    @IBOutlet weak var profession: UILabel!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var applyBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        

        // Do any additional setup after loading the view.
    }
    func initData(){
        let db = Firestore.firestore()
        collRef=db.collection("Users")
        self.navigationController?.title="Profile"
        self.navigationController?.hidesBarsOnSwipe=true
        
        
        if Auth.auth().currentUser != nil{
            collRef.document((Auth.auth().currentUser?.email)!).getDocument(){(querySnapshot,err) in
                
                if let error = err{
                    print(error.localizedDescription)
                }else{
                    let data=querySnapshot?.data()
                    
                    self.profilePic.sd_setImage(with: URL(string: data!["Profile_pic"] as! String), placeholderImage: UIImage(named: "ctc.jpg"))
                    self.credits.text="₹ \(data!["Credits"] as! Int)"
                    self.age.text=data!["Age"] as? String
                    self.profession.text=data!["Profession"] as? String
                    self.profilePic.layer.cornerRadius=self.profilePic.frame.size.width / 2
                    self.profilePic.clipsToBounds=true
                    self.referral_code.text=data!["Referral_code"] as? String
                    if (data!["Referal_used"] as? Bool)! {
                        self.codeTextField.isEnabled=false
                        self.applyBtn.isEnabled=false
                        self.applyBtn.setTitle("Applied!", for: .normal)
                        self.applyBtn.setTitleColor(UIColor.green, for: .normal)
                    }
                    else{
                        self.codeTextField.isEnabled=true
                        self.applyBtn.isEnabled=true
                        self.applyBtn.setTitle("Apply code", for: .normal)
                        self.applyBtn.setTitleColor(UIColor.blue, for: .normal)
                    }
                    
                    
                }
                
                
            }
        }
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        print(animated)
        initData()
    }
    @IBAction func applyCode(_ sender: Any) {
        self.showTextOverlay("Checking...")
        var status:Bool=false
        if codeTextField.hasText{
            let code=codeTextField.text!
            if code.count==13{
                self.showTextOverlay("Applying...")
                let db=Firestore.firestore()
                collRef=db.collection("Users")
                collRef.getDocuments(){(querySnapshot,err) in
                    if let error = err{
                        
                    } else {
                        for document in (querySnapshot?.documents)!{
                            let data=document.data()
                            
                            if (data["Referral_code"] as! String).elementsEqual(code), !(data["Email"] as! String).elementsEqual((Auth.auth().currentUser?.email)!){
                                
                                let refryEmail=data["Email"] as! String
                                self.collRef.document(refryEmail).getDocument(){(querySnapshot,err) in
                                    if let error=err{
                                        
                                    }
                                    else{
                                        let data=querySnapshot?.data()
                                        let credits=data!["Credits"] as! Int
                                        self.collRef.document(refryEmail).updateData(["Credits":credits+10]){(err) in
                                            
                                            if let error = err{
                                                
                                            }else{
                                                self.collRef.document((Auth.auth().currentUser?.email)!).updateData(["Credits":10,"Referal_used":true]){(err) in
                                                    if let error=err{
                                                        
                                                    }else{
                                                        self.codeTextField.isEnabled=false
                                                        self.applyBtn.isEnabled=false
                                                        self.applyBtn.setTitle("Applied!", for: .normal)
                                                        self.applyBtn.setTitleColor(UIColor.green, for: .normal)
                                                    }
                                                    
                                                }
                                            }
                                        }
                                        
                                    }
                                    
                                }
                                status=true
                                break
                                
                            }
                            else{
                                status=false
                            }
                        }
                        if status{
                            self.removeAllOverlays()
                           self.ShowAlert(Title: "Success", Message: "Promo code applied!")
                        }
                        else{
                            self.removeAllOverlays()
                            self.ShowAlert(Title: "Alert", Message: "Invalid promo code!")
                        }
                    }
                    
                    
                }
            }else{
                self.ShowAlert(Title: "Error", Message: "Invalid code!")
              self.removeAllOverlays()
            }
            
        }
        else{
            self.ShowAlert(Title: "Info", Message: "Please enter code in field!")
            self.codeTextField.enablesReturnKeyAutomatically=true
            self.removeAllOverlays()
            
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func changePassword(_ sender: Any) {
    }
    @IBOutlet weak var logOut: UIButton!
    @IBAction func LogOut(_ sender: Any) {
        let alert=FCAlertView()
        alert.delegate=self
        alert.hideDoneButton=true
        alert.showAlert(inView: self, withTitle: "Confirm!", withSubtitle: "Are you sure?", withCustomImage: nil, withDoneButtonTitle: "Ok", andButtons: ["cancel","Yes"])
        
    }
    @IBAction func DeleteAccount(_ sender: Any) {
        let alert=FCAlertView()
        alert.delegate=self
        alert.hideDoneButton=true
        alert.showAlert(inView: self, withTitle: "Warning!", withSubtitle: "Deleting account will delete your personal data, purchased history and backups.", withCustomImage: nil, withDoneButtonTitle: "Ok", andButtons: ["cancel","Delete"])
        
        
        
        
    }
    func ShowAlert(Title:String,Message:String){
        let alert=FCAlertView()
        alert.delegate=self
        alert.showAlert(inView: self, withTitle: Title, withSubtitle: Message, withCustomImage: nil, withDoneButtonTitle: "Ok", andButtons: nil)
        
    }
    func fcAlertDoneButtonClicked(_ alertView: FCAlertView!) {
        alertView.dismiss()
    }
    func fcAlertView(_ alertView: FCAlertView!, clickedButtonIndex index: Int, buttonTitle title: String!) {
        if title=="cancel"{
            alertView.dismiss()
        }
        else if title=="Delete"{
            self.showTextOverlay("deleting account...")
            let user = Auth.auth().currentUser
            let db=Firestore.firestore()
            collRef=db.collection("Users")
            collRef.document((user?.email)!).delete(){ err in
                if let err = err {
                    self.removeAllOverlays()
                    print("Error removing document: \(err)")
                    self.ShowAlert(Title: "Error", Message: err.localizedDescription)
                } else {
                    print("Document successfully removed!")
                    user?.delete { error in
                        if let error = error {
                            self.removeAllOverlays()
                            self.ShowAlert(Title: "Error", Message: error.localizedDescription)
                        } else {
                            self.removeAllOverlays()
                            // Account deleted.
                        }
                    }
                }
            }
        }
        else if title=="Yes"{
            if Auth.auth().currentUser != nil{
                do{
                    try! Auth.auth().signOut()
                }
                
            }
        }
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
