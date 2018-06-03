//
//  CartViewController.swift
//  IBAP
//
//  Created by CHARU GUPTA on 29/05/18.
//  Copyright © 2018 CritaxCorp. All rights reserved.
//

import UIKit
import MaterialCard
import Firebase
import FirebaseFirestore
import SwiftOverlays
import FCAlertView
import PushKit
import PassKit


class CartViewController: UIViewController,FCAlertViewDelegate,PKPaymentAuthorizationViewControllerDelegate{
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        print("payment success")
    }
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        
    }
    
    
    var data:[Any]?
    var data1:[Any]=[]
    
    
    var credits:Int=0
    var paymentRequest : PKPaymentRequest!
    

    @IBOutlet weak var topCard: MaterialCard!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemcode: UILabel!
    @IBOutlet weak var promocodeTextField: UITextField!
    @IBOutlet weak var applycouponBtn: UIButton!
    @IBOutlet weak var creditslabel: UILabel!
    @IBOutlet weak var finalItemName: UILabel!
    @IBOutlet weak var proceedToPayBtn: UIButton!
    @IBOutlet weak var finalItemPrice: UILabel!
    @IBOutlet weak var lowercard: MaterialCard!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showWaitOverlayWithText("loading cart")
        useCredits.setOn(false, animated: true)
        
        topCard.backgroundColor = UIColor.red
        topCard.shadowOpacity = 0.2
        topCard.shadowOffsetHeight = 0
        topCard.cornerRadius = 0
        
        secondCard.backgroundColor = UIColor.white
        secondCard.shadowOpacity = 0.2
        secondCard.shadowOffsetHeight = 0
        secondCard.cornerRadius = 0
        
        lowercard.backgroundColor = UIColor.white
        lowercard.shadowOpacity = 0.2
        lowercard.shadowOffsetHeight = 0
        lowercard.cornerRadius = 6
        if let details = data{
            itemName.text=details[0] as? String
            itemPrice.text="₹ \(details[1] as! String)"
            itemcode.text="Item code- \(details[4] as! String)"
            finalItemName.text="Payable amount"
            finalItemPrice.text="₹ \(details[1] as! String)"
            data1=details
            self.removeAllOverlays()
            
        }
        else{
            showAlert(Title:"Error",SubTitle:"Data cannot be loaded, please try again")
            
            self.removeAllOverlays()
        }
        let db=Firestore.firestore()
        var collc:CollectionReference!
        collc=db.collection("Users")
        collc.document((Auth.auth().currentUser?.email)!).getDocument(){(querySnapshot,err) in
            if let error = err{
                self.showAlert(Title: "Error", SubTitle: error.localizedDescription)
            }
            else{
                let data=querySnapshot?.data()
                self.credits=data!["Credits"] as! Int
                self.creditslabel.text="Available credits (₹ \(data!["Credits"] as! Int))"
            }
            
        }
        
        
    }
    func fcAlertView(_ alertView: FCAlertView!, clickedButtonIndex index: Int, buttonTitle title: String!) {
        if title == "OK"{
            alertView.dismiss()
        }
    }
    @IBOutlet weak var secondCard: MaterialCard!
    
    @IBAction func useCredits(_ sender: UISwitch) {
        var finalPrice:Int
        promocodeTextField.text=""
        applyCode.isEnabled=true
        let itemPrice:Int=Int(self.data1[1] as! String)!
        if sender.isOn{
            if credits != 0{
                finalPrice = itemPrice - credits/2
                print(finalPrice)
                print(itemPrice/2)
                if finalPrice>0 , finalPrice < (itemPrice/2){
                    finalPrice=itemPrice/2
                    finalItemPrice.text="₹ \(finalPrice)"
                    
                }
                else if finalPrice>0 , finalPrice >= (itemPrice/2){
                    finalPrice=finalPrice*1
                    finalItemPrice.text="₹ \(finalPrice)"
                }
                else if finalPrice<=0{
                    finalPrice=itemPrice/2
                    finalItemPrice.text="₹ \(finalPrice)"
                }else{
                    finalPrice=0
                    finalItemPrice.text="₹ \(finalPrice)"
                }
            }
        }else{
            promocodeTextField.text="Apply coupon"
            promocodeTextField.textColor=UIColor.init(rgba: 0xAB3E28)
            finalItemPrice.text="₹ \(itemPrice)"
        }
    }
    @IBOutlet weak var useCredits: UISwitch!
    @IBAction func applyCode(_ sender: Any) {
        if useCredits.isOn{ return }
        else{
        let db=Firestore.firestore()
        var collc:CollectionReference!
        collc=db.collection("Coupons")
        var check:Bool=false
        
        collc.getDocuments(){(querySnapshot,err) in
            
            if let error = err{
                print(error.localizedDescription)
            }else{
                for document in (querySnapshot?.documents)!{
                    let data=document.data()
                    if (data["Code"] as! String).lowercased().elementsEqual(self.promocodeTextField.text!.lowercased()) {
                        let discount:Int=Int(data["Discount"] as! String)!
                        let initial=Int(self.data1[1] as! String)!
                        print(discount + initial)
                        let finalprice=initial-initial*discount/100
                        self.finalItemPrice.text="₹ \(finalprice)"
                        self.applyCode.setTitle("Applied!", for: .normal)
                        self.applyCode.setTitleColor(UIColor.green, for: .normal)
                        check=true
                        self.promocodeTextField.text=""
                        self.applyCode.isEnabled=false
                        break
                    }
                    else{
                        check=false
                    }
                    
                }
                if !check{
                    self.showAlert(Title: "Error", SubTitle: "Invalid coupon code!")
                }
                else{
                    self.showAlert(Title: "Info", SubTitle: "Promo code applied successfully")
                }
            }
            
            
        }
        }
        
    }
    @IBOutlet weak var applyCode: UIButton!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func itemInCart()->[PKPaymentSummaryItem]{
        let price=finalItemPrice.text
        let priceIn=Double((price?.replacingOccurrences(of: "₹ ", with: ""))!)
        let item = PKPaymentSummaryItem(label: data1[0] as! String, amount: 50.00)
        let discounted = PKPaymentSummaryItem(label: "Discounted price", amount: NSDecimalNumber(string:"\(priceIn)"))
        let final=PKPaymentSummaryItem(label: "Final amount", amount: 20.00)
        return [item,final]
    }
    @IBAction func proceedToPay(_ sender: Any) {
        let paymentNetworks=[PKPaymentNetwork.amex,.discover,.masterCard,.visa,.quicPay,.privateLabel]
        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetworks){
            paymentRequest = PKPaymentRequest()
            paymentRequest.currencyCode="INR"
            paymentRequest.countryCode="IN"
            paymentRequest.merchantIdentifier="merchant.com.app.law.kanishk.IBAP"
            paymentRequest.supportedNetworks=paymentNetworks
            paymentRequest.merchantCapabilities = .capability3DS
            paymentRequest.paymentSummaryItems=self.itemInCart()
            
            let applePayVC = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest
            )
            applePayVC?.delegate=self
            self.present(applePayVC!, animated: true, completion: nil)
            
        }
        else{
            print("tell user")
        }
        
    }
    func showAlert(Title:String,SubTitle:String){
        let alert=FCAlertView()
        alert.delegate=self
        alert.bounceAnimations=true
        alert.delegate=self
        alert.showAlert(inView: self, withTitle: Title, withSubtitle: SubTitle, withCustomImage: nil, withDoneButtonTitle: "OK", andButtons: nil)
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
