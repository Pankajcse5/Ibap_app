//
//  SettingsViewController.swift
//  IBAP
//
//  Created by CHARU GUPTA on 02/06/18.
//  Copyright © 2018 CritaxCorp. All rights reserved.
//

import UIKit
import EggRating
import FCAlertView


class SettingsViewController: UIViewController,FCAlertViewDelegate {

    @IBOutlet weak var news: UISwitch!
    @IBOutlet weak var article: UISwitch!
    @IBOutlet weak var other: UISwitch!
    
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var bgtoolbar: UIToolbar!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setToolbarHidden(true, animated: false)
        news.setOn(UserDefaults.standard.bool(forKey: "ActNotification"), animated: true)
        article.setOn(UserDefaults.standard.bool(forKey: "ArticleNotification"), animated: true)
        other.setOn(UserDefaults.standard.bool(forKey: "OtherNotification"), animated: true)
        
        self.toolbar.isHidden=true
        self.bgtoolbar.isHidden=true
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        news.setOn(UserDefaults.standard.bool(forKey: "ActNotification"), animated: true)
        article.setOn(UserDefaults.standard.bool(forKey: "ArticleNotification"), animated: true)
        other.setOn(UserDefaults.standard.bool(forKey: "OtherNotification"), animated: true)

    }
    @IBAction func fontChange(_ sender: Any) {
        print("font chngr")
        self.bgtoolbar.isHidden=true
        if toolbar.isHidden{
        self.toolbar.isHidden=false
        }
        else{
            toolbar.isHidden=true
        }
    }
    
    @IBAction func ColorChange(_ sender: Any) {
        self.toolbar.isHidden=true
        if bgtoolbar.isHidden{
            self.bgtoolbar.isHidden=false
        }
        else{
            bgtoolbar.isHidden=true
        }
    }
    @IBOutlet weak var whiteOnBlack: UIBarButtonItem!
    @IBAction func whiteOnBlack(_ sender: Any) {
        UserDefaults.standard.set(1, forKey: "BGColor")
    }
    @IBAction func BlackOnWhite(_ sender: Any) {
        UserDefaults.standard.set(0, forKey: "BGColor")
    }
    @IBAction func XSAction(_ sender: Any) {
        UserDefaults.standard.set("XS", forKey: "DefaultFontSize")
    }
    @IBOutlet weak var SAction: UIBarButtonItem!
    @IBAction func SAction_(_ sender: Any) {
        UserDefaults.standard.set("S", forKey: "DefaultFontSize")
    }
    @IBAction func MAction(_ sender: Any) {
        UserDefaults.standard.set("M", forKey: "DefaultFontSize")
    }
    @IBAction func LAction(_ sender: Any) {
        UserDefaults.standard.set("L", forKey: "DefaultFontSize")
    }
    @IBAction func XLAction_(_ sender: Any) {
        UserDefaults.standard.set("XL", forKey: "DefaultFontSize")
    }
    @IBOutlet weak var XLAction: UIBarButtonItem!
    @IBAction func ActNotification(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "ActNotification")
    }
    @IBAction func ArticleNotification(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "ArticleNotification")
    }
    @IBAction func OtherNotification(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "OtherNotification")
    }
    @IBAction func FAQ(_ sender: Any) {
    }
    @IBOutlet weak var RateUs: UIButton!
    
    @IBAction func RateUs(_ sender: Any) {
        EggRating.delegate=self
        EggRating.itunesId="kanishk.agrwl@gmail.com"
        EggRating.minRatingToAppStore=3.5
        
        EggRating.promptRateUs(in: self)
    }
    @IBAction func aboutus(_ sender: Any) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func ShowAlert(Title:String,Message:String){
        let alert=FCAlertView()
        alert.delegate=self
        alert.showAlert(inView: self, withTitle: Title, withSubtitle: Message, withCustomImage: nil, withDoneButtonTitle: "Ok", andButtons: nil)
        
    }

}
extension SettingsViewController:EggRatingDelegate{
    func didRate(rating rate: Double) {
    
        //self.ShowAlert(Title: "ThankYou", Message: "Thankyou to rate us as it will help us to serve you better.")
    }
    
    func didIgnoreToRate() {
        
    }
    
    func didRateOnAppStore() {
        
    }
    
    func didIgnoreToRateOnAppStore() {
        
    }
    
    
}
