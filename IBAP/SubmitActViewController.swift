//
//  SubmitActViewController.swift
//  IBAP
//
//  Created by CHARU GUPTA on 02/06/18.
//  Copyright © 2018 CritaxCorp. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FCAlertView

class SubmitActViewController: UIViewController,FCAlertViewDelegate {

    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var nameEditText: UITextField!
    @IBOutlet weak var discription: UITextField!
    var collecRef:CollectionReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectState.isEnabled=false

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func C_or_S(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex==0{
            selectState.isEnabled=false
        }
        else{
            selectState.isEnabled=true
        }
    }
    @IBOutlet weak var submitBtn: UIButton!
    @IBAction func SubmitBtn(_ sender: Any) {
        let db=Firestore.firestore()
        if selectState.isEnabled,Auth.auth().currentUser != nil,discription.hasText,nameEditText.hasText,selectState.title(for: .normal) != "Select State"{
            let date = Date()
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: date)
            let minutes = calendar.component(.minute, from: date)
            let dateTime="\(date) \(hour) : \(minutes)"
            let state=selectState.title(for: .normal)
            collecRef=db.collection("List My Act Requests")
            collecRef.document((Auth.auth().currentUser?.email)!).collection("list").document(dateTime).setData(["Act_Rule_Name": nameEditText.text,"City":state,"Expected_price":self.discription.text,"State_Central":"State"]){(err) in
                
                if let error=err{
                    print("\(error.localizedDescription)")
                    self.ShowAlert(Title: "Alert", Message: error.localizedDescription)
                }
                else{
                    print("Submitted!")
                }
            }
        }else if !selectState.isEnabled,Auth.auth().currentUser != nil,discription.hasText,nameEditText.hasText {
            let date = Date()
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: date)
            let minutes = calendar.component(.minute, from: date)
            let dateTime="\(date) \(hour) : \(minutes)"
            //let state=selectState.title(for: .normal)
            collecRef=db.collection("List My Act Requests")
            collecRef.document((Auth.auth().currentUser?.email)!).collection("list").document(dateTime).setData(["Act_Rule_Name": nameEditText.text,"City":"None","Expected_price":self.discription.text,"State_Central":"Central"]){(err) in
                
                if let error=err{
                    print("\(error.localizedDescription)")
                    self.ShowAlert(Title: "Error", Message: error.localizedDescription)
                }
                else{
                    print("Submitted!")
                }
            }
        }
        else if selectState.isEnabled,selectState.title(for: .normal) == "Select State",discription.hasText,nameEditText.hasText{
            ShowAlert(Title: "Error", Message: "You are not selected any state.")
            
        }else{
            ShowAlert(Title: "Error", Message: "Either name or description field in empty!")
        }
    }
    
    @IBOutlet weak var selectState: UIButton!
    
    @IBAction func SelectState(_ sender: Any) {
        ActionSheetStringPicker.show(withTitle: "Select state", rows: ["Andhra Pradesh","Arunachal Pradesh","Assam","Bihar","Chhattisgarh","Goa","Gujarat","Haryana","Himachal Pradesh","Jammu & Kashmir","Jharkhand","Karnataka","Kerala","Madhya Pradesh","Maharashtra","Manipur","Meghalaya","Mizoram","Nagaland","Odisha","Punjab","Rajastan","Sikkim","Tamil Nadu","Telangna","Tripura","Uttrakhand","Uttar Pradesh","West Bengal"], initialSelection: 1, doneBlock: {
            picker, value, index in
            
            print("value = \(value)")
            print("index = \(String(describing: index))")
            print("picker = \(String(describing: picker))")
            self.selectState.setTitle(index as? String, for: .normal)
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)
        
    }
    func ShowAlert(Title:String,Message:String){
        let alert=FCAlertView()
        alert.delegate=self
        alert.showAlert(inView: self, withTitle: Title, withSubtitle: Message, withCustomImage: nil, withDoneButtonTitle: "Ok", andButtons: nil)
        
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
