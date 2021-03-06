//
//  PhotoLibraryCollectionViewCell.swift
//  CityBikes
//
//  Created by Thoang Tran on 11/19/18.
//  Copyright © 2018 Thoang Tran. All rights reserved.
//

import UIKit

class PhotoLibraryCollectionViewCell: UICollectionViewCell {
    
    var imageView = UIImageView(frame: CGRect.zero)
    
    func configureUI() {
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5.0
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(imageView)
        contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[imageView]|",
            options: NSLayoutConstraint.FormatOptions.alignAllCenterY,
            metrics: nil,
            views: ["imageView": imageView])
        )
        contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[imageView]|",
            options: NSLayoutConstraint.FormatOptions.alignAllCenterX,
            metrics: nil,
            views: ["imageView": imageView])
        )
    }
    
    override func snapshotView(afterScreenUpdates afterUpdates: Bool) -> UIView? {
        let snapshot = super.snapshotView(afterScreenUpdates: afterUpdates)
        
        snapshot?.layer.masksToBounds = false
        snapshot?.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        snapshot?.layer.shadowRadius = 5.0
        snapshot?.layer.shadowOpacity = 0.4
        snapshot?.center = center
        
        return snapshot
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureUI()
    }
}
