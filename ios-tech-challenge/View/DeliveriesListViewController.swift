//
//  DeliveriesListViewController.swift
//  ios-tech-challenge
//
//  Created by Ammad Akhtar on 16/09/2018.
//  Copyright © 2018 Ammad Akhtar. All rights reserved.
//

import UIKit
import PureLayout

class DeliveriesListViewController: UIViewController {
    
    // MARK: - UI Elements & variables
    
    var didSetConstraints = false
    
    let deliveryListTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        return tableView
    }()
    
    // MARK: - UIViewController Methods
    
    override func loadView() {
        super.loadView()
        self.title = "Things To Deliver"
        self.view = UIView()
        self.view.backgroundColor = UIColor.white.withAlphaComponent(1.0)
        
        self.view.addSubview(self.deliveryListTableView)
        deliveryListTableView.delegate = self
        deliveryListTableView.dataSource = self
        deliveryListTableView.register(DeliveryTableViewCell.self, forCellReuseIdentifier: kDeliveryCellIdentifier)
        self.updateConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        ViewModel.shared.getDeliveryItems() {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.deliveryListTableView.reloadData()
        }
    }
    
    // MARK: - Private Methods
    
    func updateConstraints() {
        
        if !didSetConstraints {   // check if constraints are not set than only set constraints
            
            deliveryListTableView.autoPinEdge(toSuperviewEdge: .top)
            deliveryListTableView.autoPinEdge(toSuperviewEdge: .bottom)
            deliveryListTableView.autoPinEdge(toSuperviewEdge: .right)
            deliveryListTableView.autoPinEdge(toSuperviewEdge: .left)
            didSetConstraints = true
        }
        super.updateViewConstraints()
    }
    
    // MARK: - UIScrollView Delegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if (Int(deliveryListTableView.contentOffset.y + deliveryListTableView.frame.size.height) >= Int(deliveryListTableView.contentSize.height)) {
            
            if ViewModel.shared.deliveryItems.count >= kLimit && ViewModel.shared.lastFetchedCount >= kLimit {
                ViewModel.shared.getDeliveryItems {
                    self.deliveryListTableView.reloadData()
                }
            }
        }
    }
}

extension DeliveriesListViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDataSource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if ViewModel.shared.numberOfItemsToDisplay(in: 0) != 0 {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ViewModel.shared.numberOfItemsToDisplay(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kDeliveryCellIdentifier) as! DeliveryTableViewCell
        cell.addressLabel.text = ViewModel.shared.deliveryAddress(for: indexPath)
        cell.descriptionLabel.text = ViewModel.shared.deliveryDescription(for: indexPath)
        
        ViewModel.shared.deliveryItemImageUrl(for: indexPath) { (image) in
            
            if image != nil {
                cell.deliveryImageView.image = image
           
            } else {
               cell.deliveryImageView.image = #imageLiteral(resourceName: "place_holder.png")
            }
        }
        cell.setNeedsUpdateConstraints()
        return cell
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let deliveryDetailViewController = DeliveryDetailViewController(ViewModel.shared.deliveryItems[indexPath.row])
        self.navigationController?.pushViewController(deliveryDetailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        // Setting initial state
        cell.alpha = 0.4
        let transform = CATransform3DTranslate(CATransform3DIdentity, -tableView.bounds.size.width, 30, 0)
        cell.layer.transform = transform
        
        // Animating to final stage
        UIView.animate(withDuration: 1.0) {
            cell.alpha = 1.0
            cell.layer.transform = CATransform3DIdentity
        }
    }
}
