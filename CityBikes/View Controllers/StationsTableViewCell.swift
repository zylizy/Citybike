//
//  StationsTableViewCell.swift
//  CityBikes
//
//  Created by Xue on 12/4/18.
//  Copyright © 2018 Thoang Tran. All rights reserved.
//

import UIKit

class StationsTableViewCell: UITableViewCell {

    
    @IBOutlet var addressLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
