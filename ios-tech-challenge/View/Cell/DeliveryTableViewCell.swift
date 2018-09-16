//
//  DeliveryTableViewCell.swift
//  ios-tech-challenge
//
//  Created by Ammad Akhtar on 16/09/2018.
//  Copyright © 2018 Ammad Akhtar. All rights reserved.
//

import UIKit
import PureLayout

class DeliveryTableViewCell: UITableViewCell {
    
    // MARK: - Varibales & UI Elements
    
    var didSetConstraints = false
    
    let deliveryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.white.withAlphaComponent(1.0)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let addressTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.text = "Address:"
        label.textColor = UIColor.gray
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    // MARK: - Init Methods
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(deliveryImageView)
        self.contentView.addSubview(descriptionLabel)
        self.contentView.addSubview(addressTitleLabel)
        self.contentView.addSubview(addressLabel)
        
        self.setNeedsUpdateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func updateConstraints() {
        
        if !didSetConstraints { // only set constraints if they are not set previously
            
            // setting deliveryImageView
            self.deliveryImageView.autoPinEdge(toSuperviewEdge: .left)
            self.deliveryImageView.autoPinEdge(toSuperviewEdge: .top, withInset: 10.0)
            self.deliveryImageView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 10.0)
            self.deliveryImageView.autoSetDimensions(to: CGSize(width: 80, height: 80))
            
            // setting descriptionLabel
            self.descriptionLabel.autoPinEdge(.left , to: .right, of: self.deliveryImageView, withOffset: 2.0)
            self.descriptionLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 10.0)
            self.descriptionLabel.autoSetDimension(.height , toSize: 15.0)
            
            // setting addressTitleLabel
            self.addressTitleLabel.autoPinEdge(.top, to: .bottom, of: self.descriptionLabel, withOffset: 20.0)
            self.addressTitleLabel.autoPinEdge(.left, to: .right, of: deliveryImageView, withOffset: 2.0)
            self.addressTitleLabel.autoPinEdge(toSuperviewEdge: .right)
            self.addressTitleLabel.autoSetDimension(.height, toSize: 10.0)
            
            //setting addressLabel
            self.addressLabel.autoPinEdge(.top, to: .bottom, of: self.addressTitleLabel, withOffset: 2.0)
            self.addressLabel.autoPinEdge(.left, to: .right, of: self.deliveryImageView, withOffset: 2.0)
            self.addressLabel.autoPinEdge(toSuperviewEdge: .right)
            
            didSetConstraints = true
        }
        super.updateConstraints()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
