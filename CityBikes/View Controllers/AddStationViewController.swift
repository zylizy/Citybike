//
//  AddStationViewController.swift
//  CityBikes
//
//  Created by Zhiyuan Li on 12/5/18.
//  Copyright © 2018 Thoang Tran. All rights reserved.
//

import UIKit

class AddStationViewController: UIViewController {

    
    @IBOutlet var stationNameTF: UITextField!
    
    @IBOutlet var longTF: UITextField!
    
    
    @IBOutlet var laTF: UITextField!
    
    @IBOutlet var countryTF: UITextField!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func keyboardDone(_ sender: UITextField) {
        
        // When the Text Field resigns as first responder, the keyboard is automatically removed.
        sender.resignFirstResponder()
    }
    
    @IBAction func backgroundTouch(_ sender: UIControl) {
        /*
         "This method looks at the current view and its subview hierarchy for the text field that is
         currently the first responder. If it finds one, it asks that text field to resign as first responder.
         If the force parameter is set to true, the text field is never even asked; it is forced to resign." [Apple]
         
         When the Text Field resigns as first responder, the keyboard is automatically removed.
         */
        view.endEditing(true)
    }
    
    

}
