//
//  ResetPasswordViewController.swift
//  IBAP
//
//  Created by CHARU GUPTA on 01/06/18.
//  Copyright © 2018 CritaxCorp. All rights reserved.
//

import UIKit
import FirebaseAuth
import SwiftOverlays

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var passwordImage: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var status: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func reset(_ sender: Any) {
        self.showTextOverlay("Sending...")
        if emailTextField.text != nil{
            let email=emailTextField.text
            Auth.auth().sendPasswordReset(withEmail: email!){(error) in
                
                if let error=error{
                    self.status.text=error.localizedDescription
                    self.removeAllOverlays()
                }
                else{
                    self.emailTextField.text=""
                    self.status.text="OTP sent successfully"
                    self.removeAllOverlays()
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
