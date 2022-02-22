//
//  ShowDetailsInformationBikeStationViewController.swift
//  CityBikes
//
//  Created by Thoang Tran on 11/18/18.
//  Copyright © 2018 Thoang Tran. All rights reserved.
//

import UIKit

class ShowDetailsInformationBikeStationViewController: UIViewController {

    var bikeStationPassed = [Any]()
    
    @IBOutlet var bikeAvailLabel: UILabel!
    @IBOutlet var dockAvailLabel: UILabel!
    @IBOutlet var systemIDLabel: UILabel!
    @IBOutlet var lastReportedTimeLabel: UILabel!
    @IBOutlet var distance: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = bikeStationPassed[3] as? String

        // Do any additional setup after loading the view.
        let bikeAvail = bikeStationPassed[4] as? Int
        let dockAvail = bikeStationPassed[5] as? Int
        bikeAvailLabel.text = String(format: "%d", bikeAvail!)
        dockAvailLabel.text = String(format: "%d", dockAvail!)
        systemIDLabel.text = bikeStationPassed[6] as? String
        lastReportedTimeLabel.text = bikeStationPassed[2] as? String
         distance.text = bikeStationPassed[7] as? String
    
    }
}
