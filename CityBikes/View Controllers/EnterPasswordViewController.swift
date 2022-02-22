//
//  EnterPasswordViewController.swift
//  CityBikes
//
//  Created by Zhiyuan Li on 12/3/18.
//  Copyright © 2018 Thoang Tran. All rights reserved.
//

import UIKit

class EnterPasswordViewController: UIViewController {

    @IBOutlet var star1: UILabel!
    
    @IBOutlet var star2: UILabel!
    
    @IBOutlet var star3: UILabel!
    @IBOutlet var star4: UILabel!
    
    @IBOutlet var resultsLabel: UILabel!
    var fourDig = 0
    var currPass = [String]()
    var reset = false
    override func viewDidLoad() {
        
        super.viewDidLoad()
        resultsLabel.text = "Enter Password!"
        currPass = []
        star1.isHidden = true
        star2.isHidden = true
        star3.isHidden = true
        star4.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func passcodeEntered(_ sender: UIButton) {
        resultsLabel.text = "Enter Password!"
        if fourDig <= 3 {
            let tag = sender.tag
            switch tag {
            case 1:
                currPass.append("1")
                showStar(star: fourDig)
                fourDig = fourDig + 1
                
            case 2:
                currPass.append("2")
                showStar(star: fourDig)
                fourDig = fourDig + 1
                
            case 3:
                currPass.append("3")
                showStar(star: fourDig)
                fourDig = fourDig + 1
                
            case 4:
                currPass.append("4")
                 showStar(star: fourDig)
                fourDig = fourDig + 1
               
            case 5:
                currPass.append("5")
                showStar(star: fourDig)
                fourDig = fourDig + 1
                
            case 6:
                currPass.append("6")
                showStar(star: fourDig)
                fourDig = fourDig + 1
                
            case 7:
                currPass.append("7")
                showStar(star: fourDig)
                fourDig = fourDig + 1
                
            case 8:
                currPass.append("8")
                showStar(star: fourDig)
                fourDig = fourDig + 1
                
            case 9:
                currPass.append("9")
                showStar(star: fourDig)
                fourDig = fourDig + 1
                
            default:
                currPass.append("0")
                showStar(star: fourDig)
                fourDig = fourDig + 1
            }
        }
       
        // enterd four dig
        if fourDig == 4 {
            let password = UserDefaults.standard.value(forKey: "password") as! Array<String>
            var passed = false
            for i in 0...3 {
                var allequal = true
                if currPass[i] != password[i] {
                    resultsLabel.text = "Password wrong!"
                    fourDig = 0
                    allequal = false
                    star1.isHidden = true
                    star2.isHidden = true
                    star3.isHidden = true
                    star4.isHidden = true
                }
                if i == 3 && allequal == true {
                    passed = true
                }
            }
            if passed == true {
                resultsLabel.text = "Passed!!!"
                fourDig = 0
                if reset {
                    reset = false
                    performSegue(withIdentifier: "resetPassword", sender: self)
                } else {
                    performSegue(withIdentifier: "passwordPassed", sender: self)
                }
            } else {
                currPass = []
            }
        }
    }
    
    func showStar(star : Int) {
        switch star {
        case 0:
            star1.isHidden = false
        case 1:
            star2.isHidden = false
        case 2:
            star3.isHidden = false
        default:
            star4.isHidden = false
        }
    }
    
    
    @IBAction func resetPassword(_ sender: Any) {
        resultsLabel.text = "Enter password first!"
        reset = true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
