//
//  ViewController.swift
//  IBAP
//
//  Created by CHARU GUPTA on 27/04/18.
//  Copyright © 2018 CritaxCorp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //performSegue(withIdentifier: "LoginScreen", sender: self)
        
        
            
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.tintColor=UIColor.white
        self.button.setTitle("go", for: .normal)
        self.button.isHidden=true
        
        Timer.scheduledTimer(timeInterval:3.0, target: self, selector:#selector(self.timerCode), userInfo:nil, repeats: false)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
       // sleep(4)
        
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    @IBAction func GoToNext(_ sender: Any) {
        //performSegue(withIdentifier: "LoginVC", sender: self)
        
    }
    
    @objc func timerCode(){
        self.button.isHidden=false
        
        
    }


}

