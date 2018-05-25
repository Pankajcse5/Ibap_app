//
//  AppDelegate.swift
//  IBAP
//
//  Created by CHARU GUPTA on 27/04/18.
//  Copyright © 2018 CritaxCorp. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import GoogleSignIn
import IQKeyboardManagerSwift
import ImagePicker



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    

    var window: UIWindow?
    var status:Bool!


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        IQKeyboardManager.shared.enable = true
        let db = Firestore.firestore()
        
        

        

        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url as URL?, sourceApplication: sourceApplication, annotation: annotation)
    }
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: [:])
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        
        if let error = error {
            
            //showAlert(title: "Error", msg: error.localizedDescription)
        }
        else{
            print("Success google login")
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential){(user,error) in
            if let error=error{
                //self.showAlert(title: "Error", msg: error.localizedDescription)
                print(error.localizedDescription)
            }
            else{
                //self.showAlert(title: "info", msg: "Success")
                print("firebase login")
                var docRef:CollectionReference!
                let db=Firestore.firestore()
                docRef=db.collection("Users")
                print(docRef)
                docRef.document((user?.email)!).getDocument(){(docSnapshot,error) in
                    guard let docSnapshot=docSnapshot,!docSnapshot.exists else{return}
                    docRef.document((user?.email)!).setData([
                        "Email":user?.email ?? " ",
                        "Password":"  ",
                        "Name":user?.displayName ?? "  ",
                        "Profile_pic":user?.photoURL as? String? ?? "  ",
                        "Referral_code":"",
                        "Credits":0
                        
                    ]){(error) in
                        if  let Error = error{
                           print(Error)
                        }else{
                            let userdefault=UserDefaults.standard
                            userdefault.set(true, forKey: "loginStatus")
                            self.status = true
                            print("login")
                            
                            
                        }
                    }
                    
                    
                }
            }
            
            
            
        }
        // ...
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    func googleStatus()->Bool{
        
        return status
        
    }
    
        
    

    

}

