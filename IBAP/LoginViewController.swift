//
//  LoginViewController.swift
//  IBAP
//
//  Created by CHARU GUPTA on 27/04/18.
//  Copyright © 2018 CritaxCorp. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit
import FBSDKCoreKit
import SwiftOverlays
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate {
    @IBOutlet weak var loginbtn: UIButton!
    @IBOutlet weak var googlebtn: GIDSignInButton!
    @IBOutlet weak var facebookbtn: UIButton!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    var docRef:CollectionReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginbtn.layer.cornerRadius=10;
        loginbtn.clipsToBounds=true;
        
        googlebtn.layer.cornerRadius=10;
        googlebtn.clipsToBounds=true;
        
        facebookbtn.layer.cornerRadius=10;
        facebookbtn.clipsToBounds=true;
        let db=Firestore.firestore()
        docRef=db.collection("Users")
       

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginWithEmail(_ sender: Any) {
        let email = username.text!
        let password = self.password.text!
        Auth.auth().signIn(withEmail: email, password: password){(user,error) in
            if let error=error{
                print(error.localizedDescription)
                self.showAlert(title: "info", msg: error.localizedDescription)
                
            }
            else{
                print("success")
                self.showAlert(title: "info", msg: "Success")
                
            }
            
        }
    }
   
    @IBAction func loginFb(_ sender: Any) {
    
    
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions:["email","public_profile"], from: self) { (  facebookResult,facebookError  ) in
            if let error=facebookError{
                self.showAlert(title: "error", msg: (error.localizedDescription))
                
            }
            else if (facebookResult?.isCancelled)!{
                self.showAlert(title: "info", msg: "Login cancelled by user!")
                
            }
            else{
                self.showWaitOverlay()
                
                print("fb success")
                
                let credentials=FacebookAuthProvider.credential(withAccessToken:FBSDKAccessToken.current().tokenString)
                Auth.auth().signIn(with: credentials){(user,error) in
                    if let err=error{
                        
                        self.showAlert(title: "Error", msg:err.localizedDescription)
                    }
                    else{
                        
                        print(user?.displayName ?? nil!)
                        print(user?.email ?? nil!)
                        print(user?.photoURL ?? nil!)
                        self.removeAllOverlays()
                        
                        self.docRef.document((user?.email)!).getDocument(){(docSnapshot,error) in
                            guard let docSnapshot=docSnapshot,!docSnapshot.exists else{return}
                            self.docRef.document((user?.email)!).setData([
                                "Email":user?.email ?? " ",
                                "Password":"  ",
                                "Name":user?.displayName ?? "  ",
                                "Profile_pic":user?.photoURL as? String? ?? "  ",
                                "Referral_code":"",
                                "Credits":0
                                
                            ]){(error) in
                                if  let error=error{
                                    self.showAlert(title: "Error", msg: error.localizedDescription)
                                }else{
                                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "morelogindetails") as! MoreLoginDetailsViewController
                                    self.present(nextViewController, animated:true, completion:nil)
                                    
                                }
                            }
                            
                            
                        }
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "morelogindetails") as! MoreLoginDetailsViewController
                        self.present(nextViewController, animated:true, completion:nil)
                        
                        
                        
                    }
                    
                    
                }
            
            }
        }
    }
    
    @IBAction func LoginWithGoogle(_ sender: Any) {
        self.showWaitOverlay()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        let userdefaults=UserDefaults.standard
        
        while(!userdefaults.bool(forKey: "loginStatus")){
        
        }
        if userdefaults.bool(forKey: "loginStatus"){
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "morelogindetails") as! MoreLoginDetailsViewController
            self.present(nextViewController, animated:true, completion:nil)
            self.removeAllOverlays()
            
        }
        else{
            self.removeAllOverlays()
            self.showAlert(title: "info", msg: "Something went wrong!")
        }
        print(userdefaults.bool(forKey: "loginStatus"))
        
        
    }
    

    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
