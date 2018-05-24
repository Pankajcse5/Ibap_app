//
//  MoreLoginDetailsViewController.swift
//  IBAP
//
//  Created by CHARU GUPTA on 01/05/18.
//  Copyright © 2018 CritaxCorp. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import Firebase
import FirebaseFirestore
import FirebaseAuth


class MoreLoginDetailsViewController: UIViewController{

    @IBOutlet weak var professionalbtn: UIButton!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var gender: UIButton!
    
    @IBOutlet weak var referral: UITextField!
    @IBOutlet weak var proceed: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        professionalbtn.layer.cornerRadius=6
        professionalbtn.clipsToBounds=true
        
        gender.layer.cornerRadius=6
        gender.clipsToBounds=true
        
        proceed.layer.cornerRadius=10
        proceed.clipsToBounds=true

        // Do any additional setup after loading the view.
    }
    @IBAction func showPickerGender(_ sender: Any) {
        ActionSheetStringPicker.show(withTitle: "Select Gender", rows: ["Male", "Female"], initialSelection: 1, doneBlock: {
            picker, value, index in
            
            print("value = \(value)")
            print("index = \(String(describing: index))")
            print("picker = \(String(describing: picker))")
            self.gender.setTitle(index as? String, for: .normal)
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func showPicker(_ sender: Any) {
        ActionSheetStringPicker.show(withTitle: "Select profession", rows: ["LAWYER", "CA", "ACCOUNTANT","IAS/IPS/POLICE","OTHER"], initialSelection: 1, doneBlock: {
            picker, value, index in
            
            print("value = \(value)")
            print("index = \(String(describing: index))")
            print("picker = \(String(describing: picker))")
            self.professionalbtn.setTitle(index as? String, for: .normal)
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)
    }
    @IBAction func proceedbtn(_ sender: Any) {
        let Age = self.age.text!
        let ReferalCode = self.referral.text!
        print(ReferalCode)
        if !Age.isEmpty,ReferalCode.isEmpty{
            UpdateData(Agee:Age)
            
        }
        else{
            UpdateDataWithReferal(Agee: Age, Referalcode: self.referral.text!)
        }
    }
    func UpdateData(Agee:String){
        self.showWaitOverlay()
        //var ref:DocumentReference.self
        let db=Firestore.firestore()
        let user=Auth.auth().currentUser
        if let user=user{
            let data:[String:Any]=[
                "Age":Agee,
                "Gender":gender.titleLabel?.text! as Any,
                "Profession":professionalbtn.titleLabel?.text! as Any,
                "Referal_used":false
                
                
            ]
            
            _ = db.collection("Users").document(user.email!).updateData(data){err in
                
                if err != nil{
                    self.removeAllOverlays()
                    self.showAlert(title: "Error",msg: (err?.localizedDescription)!)
                    
                }
                else{
                    self.removeAllOverlays()
                    self.showAlert(title: "info", msg: "Updated data")
                }
                
            }
        }
        
    }
    func UpdateDataWithReferal(Agee:String,Referalcode:String){
        self.showWaitOverlay()
        //var ref:DocumentReference.self
        let db=Firestore.firestore()
        let user=Auth.auth().currentUser
        if let user=user{
            db.collection("Users").getDocuments(){(querySnapshot, err) in
                if err != nil{
                    self.removeAllOverlays()
                }
                else {
                    for document in querySnapshot!.documents{
                        let values=document.data()
                        let d=values["Referral_code"] as? String ?? ""
                        let email=values["Email"] as? String ?? ""
                        if d.elementsEqual(Referalcode), !email.elementsEqual(user.email!){
                            db.collection("Users").document(email).getDocument(){(docSnapshot,error) in
                                guard  let docSnapshot = docSnapshot,docSnapshot.exists else {return}
                                let userData=docSnapshot.data()
                                let credits=userData!["Credits"] as? CLong ?? 0
                                db.collection("Users").document(email).updateData(["Credits":credits+10]){error in
                                    if let error=error{
                                        self.removeAllOverlays()
                                        self.showAlert(title: "error", msg: "Something went wrong! -error:"+error.localizedDescription)
                                    }
                                    else{
                                        let data:[String:Any]=[
                                            "Age":Agee,
                                            "Gender":self.gender.titleLabel?.text! as Any,
                                            "Profession":self.professionalbtn.titleLabel?.text! as Any,
                                            "Referal_used":true,
                                            "Credits":10
                                            
                                            
                                        ]
                                        
                                        _ = db.collection("Users").document(user.email!).updateData(data){err in
                                            
                                            if err != nil{
                                                self.removeAllOverlays()
                                                self.showAlert(title: "Error",msg: (err?.localizedDescription)!)
                                                
                                            }
                                            else{
                                                self.removeAllOverlays()
                                                self.showAlert(title: "info", msg: "Updated data")
                                            }
                                            
                                        }
                                    }
                                        
                                    }
                                }
                                
                
                            }
                        }
                        
                    }
                }
                
                
            }
            
        
    }
    func showAlert(title:String,msg:String){
        let alert = UIAlertController.init(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
            switch action.style{
            case .default:
                print("default")
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
                
                
            }
            
            
        }))
        self.present(alert, animated: true, completion: nil)
        
        
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
