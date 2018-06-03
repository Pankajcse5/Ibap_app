//
//  NewsViewController.swift
//  IBAP
//
//  Created by CHARU GUPTA on 30/05/18.
//  Copyright © 2018 CritaxCorp. All rights reserved.
//

import UIKit
import FeedKit
import SwiftOverlays
import SDWebImage

class NewsTableviewCell: UITableViewCell{
    //var title:String
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var imageview: UIImageView!
    func setData(item:NewsModal){
        title.text=item.Title
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let myString = formatter.string(from: Date()) // string purpose I add here
        // convert your string to date
       // let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "dd-MMM-yyyy"
        // again convert your date to string
        let myStringafd = formatter.string(from: item.date)
        date.text=myStringafd
        let str0=item.description.components(separatedBy: "src=")
        var str1=str0[1].components(separatedBy: ".jpg")
        let str2=str1[0].dropFirst()
        
        
        print("splitted \(str2).jpg")
        imageview?.sd_setImage(with: URL(string: "\(str2).jpg"), placeholderImage: nil)
        imageview?.sd_addActivityIndicator()
        imageview.sd_removeActivityIndicator()
        imageview?.frame.size.height=89.5
        imageview?.frame.size.width=79.0
        
        
    }
    func getData(item:NewsModal)->[Any]{
        var data:[Any]=[]
        
        data.append(item.Title)
        data.append(item.description)
        data.append(item.link)
        data.append(item.date)
        return data
    }
}

class NewsViewController: UIViewController {
    
    var data:[NewsModal]=[]
    var dataToSend:[Any]=[]

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate=self
        tableView.dataSource=self
self.showWaitOverlay()
        
            Timer.scheduledTimer(timeInterval:2.0, target: self, selector:#selector(self.timerCode), userInfo:nil, repeats: false)
        
        
    }
    @objc func timerCode(){
        self.loadData()
    }
    @IBAction func ReloadNews(_ sender: Any) {
        self.showTextOverlay("Loading latest news")
        self.data.removeAll()
        self.loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loadData(){
        
        let feedURL = URL(string: "http://www.livelaw.in/top-stories/feed/")!
        let parser = FeedParser(URL: feedURL)
        parser?.parseAsync(queue: DispatchQueue.global(qos: .userInteractive)) { (result) in
            // Do your thing, then back to the Main thread
           
            switch result {
            //case let .atom(feed): break       // Atom Syndication Format Feed Model
            case let .rss(feed):
                
                let items=feed.items
                for item in items!{
                    let data = NewsModal(title: item.title!, Desc: item.description!, Date: item.pubDate!, Link: item.link!)
                    self.data.append(data)
                }
                break        // Really Simple Syndication Feed Model
            //  case let .json(feed): break       // JSON Feed Model
            case let .failure(error):
                print(error.description)
                
                break
            case .atom(_): break
                
            case .json(_): break
                
            }
            DispatchQueue.main.async {
                // ..and update the UI
                print(self.data)
                self.removeAllOverlays()
                self.tableView.reloadData()
            }
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let destination = segue.destination as? NewsDetailsViewController{
            destination.data=dataToSend
        }
    }
    

}
extension NewsViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let d=data[indexPath.row]
        let cell=tableView.dequeueReusableCell(withIdentifier: "NewsCell") as! NewsTableviewCell
        cell.setData(item: d)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let d=data[indexPath.row]
        let cell=tableView.dequeueReusableCell(withIdentifier: "NewsCell") as! NewsTableviewCell
        dataToSend = cell.getData(item: d)
        
        performSegue(withIdentifier: "NewsDetail", sender: self)
    }
    
    
}
