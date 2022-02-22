//
//  AuthenViewController.swift
//  CityBikes
//
//  Created by Zhiyuan Li on 12/2/18.
//  Copyright © 2018 Thoang Tran. All rights reserved.
//

import UIKit
import LocalAuthentication


class AuthenViewController: UIViewController {

    @IBOutlet var successLabel: UILabel!
    @IBOutlet var passwordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       passwordButton.isHidden = true
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func touchIdAction(_ sender: UIButton) {
    
        let myContext = LAContext()
        let myLocalizedReasonString = "Biometric Authntication testing !! "
        
        var authError: NSError?
        if #available(iOS 8.0, macOS 10.12.1, *) {
            if myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                myContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString) { success, evaluateError in
                    
                    DispatchQueue.main.async {
                        if success {
                            // User authenticated successfully, take appropriate action
                            self.successLabel.text = "User authenticated successfully"
                            self.authenSuccessed()
                        } else {
                            // User did not authenticate successfully, look at error and take appropriate action
                            self.successLabel.text = "Sorry! Authentication Fialed"
                        }
                    }
                }
            } else {
                // Could not evaluate policy; look at authError and present an appropriate message to user
                successLabel.text = "Sorry! Could not evaluate policy."
            }
        } else {
            // Fallback on earlier versions
            
            successLabel.text = "Biometric authentication is not supported."
        }
        
        
        
    }
    
//    @IBAction func pass(_ sender: Any) {
//        let havePassword = UserDefaults.standard.value(forKey: "havePassword")
//        if havePassword == nil {
//            performSegue(withIdentifier: "createPassword", sender: self)
//        }
//        else if havePassword as! Bool {
//            performSegue(withIdentifier: "enterPassword", sender: self)
//        }
//        else if havePassword as! Bool == false {
//            performSegue(withIdentifier: "createPassword", sender: self)
//        }
//    }
    
    func authenSuccessed() {
        performSegue(withIdentifier: "afterAuthen", sender: self)
    }
    
    @IBAction func skipTapped(_ sender: Any) {
        performSegue(withIdentifier: "afterAuthen", sender: self)
    }
    

}

