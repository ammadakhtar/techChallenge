//
//  DeliveryDetailViewController.swift
//  ios-tech-challenge
//
//  Created by Ammad Akhtar on 17/09/2018.
//  Copyright © 2018 Ammad Akhtar. All rights reserved.
//

import Foundation
import UIKit
import PureLayout
import GoogleMaps

class DeliveryDetailViewController: UIViewController {
    
    // MARK: - Variables
    
    let delivery:DeliveryItem?
    var mapView:GMSMapView?
    var currentLocationMarker = GMSMarker()
    var didSetConstraints = false
    var imageCache = NSCache<AnyObject, AnyObject>()
    
    // MARK: - UI Elements
    
    let descriptionTitleLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.text = "Description:"
        label.textColor = UIColor.gray
        return label
    }()
    
    let descriptionLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    let addressTitleLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.text = "Address:"
        label.textColor = UIColor.gray
        return label
    }()
    
    let addressLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    var deliveryImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(white: 1, alpha: 0)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - Init Methods
    
    init(_ delivery: DeliveryItem) {
        self.delivery = delivery
        self.mapView = nil
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.delivery = nil
        self.mapView = nil
        super.init(coder: aDecoder)
    }
    
    deinit {
        self.mapView = nil
    }
    
    // MARK: - UIViewController Methods
    
    override func loadView() {
        super.loadView()
        
        self.title = "Delivery Details"
        
        self.view = UIView();
        self.view.backgroundColor = UIColor(white: 1, alpha: 1)
        
        guard self.delivery != nil else { return }
        
        let camera = GMSCameraPosition.camera(withLatitude: self.delivery!.latitude, longitude: self.delivery!.longitude, zoom: 17.0)
        self.mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        let position = CLLocationCoordinate2D(latitude: self.delivery!.latitude, longitude: self.delivery!.longitude)
        let marker = GMSMarker(position: position)
        marker.map = mapView
        
        self.view.addSubview(self.mapView!)
        self.view.addSubview(self.deliveryImageView)
        
        if let image = imageCache.object(forKey: (delivery?.imageUrl as NSString?)!) as? UIImage {
            self.deliveryImageView.image = image
            
        } else {
            
            if let url = URL(string: (delivery?.imageUrl)!) {
                
                URLSession.shared.dataTask(with: url) { [weak self] (data , response , error ) in
                    
                    if error != nil {
                        return
                        
                    } else {
                        let image = UIImage(data: data!)
                        self?.imageCache.object(forKey: (self?.delivery?.imageUrl as NSString?)!)
                        
                        DispatchQueue.main.async(execute: { () -> Void in
                            self?.deliveryImageView.image = image
                        })
                    }
                    }.resume()
                
            } else {
                self.deliveryImageView.image = #imageLiteral(resourceName: "place_holder")
            }
        }
    
        self.view.addSubview(self.descriptionTitleLabel)
        self.view.addSubview(self.descriptionLabel)
        self.descriptionLabel.text = self.delivery!.description
        self.view.addSubview(self.addressTitleLabel)
        self.view.addSubview(self.addressLabel)
        self.addressLabel.text = self.delivery!.address
        
        self.updateViewConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func updateViewConstraints() {
      
        if(!didSetConstraints){
            
            // set mapView
            self.mapView!.autoPinEdge(toSuperviewEdge: .left)
            self.mapView!.autoPinEdge(toSuperviewEdge: .top)
            self.mapView!.autoPinEdge(toSuperviewEdge: .right)
            self.mapView!.autoSetDimension(.height, toSize: 350)
            
            // set deliveryImageView
            self.deliveryImageView.autoPinEdge(.top, to: .bottom, of: self.mapView!, withOffset: 10.0)
            self.deliveryImageView.autoPinEdge(toSuperviewEdge: .left)
            self.deliveryImageView.autoSetDimensions(to: CGSize(width:80.0, height:80.0))
            
            // set descriptionTitleLabel
            self.descriptionTitleLabel.autoPinEdge(.top, to: .bottom, of: self.deliveryImageView, withOffset: 10.0)
            self.descriptionTitleLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10.0)
            self.descriptionTitleLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10.0)
            
            // set descriptionLabel
            self.descriptionLabel.autoPinEdge(.top, to: .bottom, of: self.descriptionTitleLabel)
            self.descriptionLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10.0)
            self.descriptionLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10.0)
            
            // set addressTitleLabel
            self.addressTitleLabel.autoPinEdge(.top, to: .bottom, of: self.descriptionLabel, withOffset: 20.0)
            self.addressTitleLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10.0)
            self.addressTitleLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10.0)
            
            // set addressLabel
            self.addressLabel.autoPinEdge(.top, to: .bottom, of: self.addressTitleLabel)
            self.addressLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10.0)
            self.addressLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 10.0)
            
            
            didSetConstraints = true
        }
        super.updateViewConstraints()
    }
}
