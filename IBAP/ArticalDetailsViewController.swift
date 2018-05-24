//
//  ArticalDetailsViewController.swift
//  IBAP
//
//  Created by CHARU GUPTA on 24/05/18.
//  Copyright © 2018 CritaxCorp. All rights reserved.
//

import UIKit
import SDWebImage
import CustomizableActionSheet


class ArticalDetailsViewController: UIViewController {

    @IBOutlet weak var upperImage: UIImageView!
    @IBOutlet weak var lowerImage: UIImageView!
    @IBOutlet weak var noOfViews: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var webview: UIWebView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    var actionSheet: CustomizableActionSheet?

    @IBAction func showProfile(_ sender: Any) {
        print("profile")
        var items = [CustomizableActionSheetItem]()
        
        // First view
        if let sampleView = UINib(nibName: "SampleView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? SampleView {
            sampleView.delegate = self
            let sampleViewItem = CustomizableActionSheetItem(type: .view, height: 600)
            sampleViewItem.view = sampleView
            items.append(sampleViewItem)
        }
        let clearItem = CustomizableActionSheetItem(type: .button)
        clearItem.label = "Cancel"
        clearItem.backgroundColor = UIColor(red: 1, green: 0.41, blue: 0.38, alpha: 1)
        clearItem.textColor = UIColor.white
        clearItem.selectAction = { (actionSheet: CustomizableActionSheet) -> Void in
            self.view.backgroundColor = UIColor.white
            actionSheet.dismiss()
        }
        items.append(clearItem)
        let actionSheet = CustomizableActionSheet()
        self.actionSheet = actionSheet
        actionSheet.showInView(self.view, items: items)
        
        let value=SampleView()
        if let details = Details{
           // print(details)
            if  value.setValue(data:details){
                print("success")
            }
        }
    }
    
    @IBOutlet weak var TextOnBAr: UINavigationItem!
    var Details:[Any]?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let details = Details{
            upperImage.sd_setImage(with: URL(string: details[7] as! String), placeholderImage: UIImage(named: "background.png"))
            lowerImage.sd_setImage(with: URL(string: details[1] as! String), placeholderImage: UIImage(named: "background.png"))
            noOfViews.text=("\(details[6] as! Int)")
            date.text=details[4] as? String
            webview.loadHTMLString((details[2] as? String)!, baseURL: nil)
            lowerImage.layer.cornerRadius=lowerImage.frame.size.width / 2
            lowerImage.clipsToBounds=true
            lowerImage.layer.borderWidth=1
            lowerImage.layer.borderColor=UIColor.white.cgColor
        /*
            navigationBar.backgroundColor=UIColor.blue
            navigationBar.barTintColor=UIColor.white
            navigationBar.tintColor=UIColor.white
            
            self.TextOnBAr.title=(details[3] as! String)*/
            
        }

        // Do any additional setup after loading the view.
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

}
extension ArticalDetailsViewController:SampleViewDelegate{
    func dismiss() {
        
    }
    
    func setContents(imageurl: String, content: String, name: String) {
        
    }
    
    
    
}
