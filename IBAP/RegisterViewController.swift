//
//  RegisterViewController.swift
//  IBAP
//
//  Created by CHARU GUPTA on 29/04/18.
//  Copyright © 2018 CritaxCorp. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import ImagePicker

class RegisterViewController: UIViewController,ImagePickerDelegate {

    @IBOutlet weak var add_image: UIImageView!
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var chooserbtn: UIButton!
    @IBOutlet weak var confirn: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var registerbtn: UIButton!
    var imagePicker = ImagePickerController()
    var docRef:CollectionReference!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerbtn.layer.cornerRadius=10
        registerbtn.clipsToBounds=true
        
        let db=Firestore.firestore()
        docRef=db.collection("Users")
        //checkPermission()
    }
    @IBAction func selectImage(_ sender: Any) {
        var config = Configuration()
        config.doneButtonTitle = "Finish"
        config.noImagesTitle = "Sorry! There are no images here!"
        config.recordLocation = false
        config.allowVideoSelection = true
        
        let imagePicker = ImagePickerController(configuration: config)
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]){
    print("called imgages")
        guard images.count > 0 else { return }
        let image=images.map {_ in
            return images
        }
        print(image)
        
    }
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]){
        imagePicker.dismiss(animated: true, completion: nil)

        
    }
    func cancelButtonDidPress(_ imagePicker: ImagePickerController){
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func register(_ sender: Any) {
        let email=self.email.text
        let name=self.name.text
        let password=self.password.text
        let confirm=self.confirn.text
        let result:Bool = checkFields(email: email!, name: name!, password: password!, confirm: confirm!)
        if result,password!.elementsEqual(confirm!){
            self.showWaitOverlay()
            
            Auth.auth().createUser(withEmail: email!, password: password!) { (user, error) in
                if let error=error{
                    self.showAlert(title: "Error", msg: error.localizedDescription)
                    
                }
                else{
                    self.docRef.document((user?.email)!).setData([
                        "Email":user?.email as Any,
                        "Name":name as Any,
                        "Credits":0,
                        "Referral_code":" ",
                        "Password":password as Any,
                        "Profile_pic":" ",
                        "Gender":" ",
                        "Referal_used":false,
                        "Profession":" ",
                        "Age":" "
                    ]){(error) in
                        
                        if let error=error{
                        self.showAlert(title: "Error", msg: error.localizedDescription)
                            self.removeAllOverlays()
                        }
                        else{
                            self.removeAllOverlays()
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "morelogindetails") as! MoreLoginDetailsViewController
                            self.present(nextViewController, animated:true, completion:nil)
                        }
                        
                    }
                    
                    
                }
            }
            
        }
        
    }
    func checkFields(email:String,name:String,password:String,confirm:String) -> Bool{
        if !email.isEmpty,!name.isEmpty,!password.isEmpty,!confirm.isEmpty{
            
            return true
        }
        else{
            showAlert(title: "Error", msg: "Please fill all blank feilds.")
            return false
        }
        
       // return false
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
