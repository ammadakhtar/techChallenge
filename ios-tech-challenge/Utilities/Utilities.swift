//
//  Utilities.swift
//  ios-tech-challenge
//
//  Created by Ammad Akhtar on 17/09/2018.
//  Copyright © 2018 Ammad Akhtar. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class Utilities: NSObject {
  
    // MARK: - Custom Methods
    
    class func showLoading(viewController: UIViewController, offSet: CGFloat = 0) {
        let superView = UIView(frame: CGRect(x: 0, y: 0 - offSet, width: getScreenWidth(), height: getScreenHeight()))
        
        if let navController = viewController.navigationController, !navController.navigationBar.isTranslucent {
            superView.frame =  CGRect(x: 0, y: -64 - offSet, width: getScreenWidth(), height: getScreenHeight())
        }
        
        let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: superView.frame.width/2 - 32.5, y: superView.frame.height/2 - 32.5, width: 65, height: 65))
        let iconImageView = UIImageView(frame: CGRect(x: superView.frame.width/2 - 25, y: superView.frame.height/2 - 25, width: 50, height: 50))
        
        iconImageView.image =  #imageLiteral(resourceName: "lalamoveicon_20")
        iconImageView.layer.cornerRadius = iconImageView.frame.size.width / 2;
        iconImageView.clipsToBounds = true
        superView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        superView.tag = 9000
        activityIndicator.type = .circleStrokeSpin
        activityIndicator.color = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        activityIndicator.startAnimating()
        superView.addSubview(iconImageView)
        superView.addSubview(activityIndicator)
        superView.bringSubview(toFront: activityIndicator)
        superView.bringSubview(toFront: iconImageView)
        viewController.view.addSubview(superView)
        viewController.view.bringSubview(toFront: superView)
        viewController.view.isUserInteractionEnabled = false
        viewController.view.setNeedsLayout()
        viewController.view.setNeedsDisplay()
    }
    
    class func hideLoading(viewController: UIViewController?) {
        
        if let activityView = viewController?.view.viewWithTag(9000) {
            viewController?.view.isUserInteractionEnabled = true
            activityView.removeFromSuperview()
        }
    }
    
    class func getScreenWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
    
    class func getScreenHeight() -> CGFloat {
        return UIScreen.main.bounds.height
    }
}
