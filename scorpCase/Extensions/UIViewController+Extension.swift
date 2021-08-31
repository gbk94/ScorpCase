//
//  UIViewController+Extension.swift
//  scorpCase
//
//  Created by Gokberk Bardakci on 29.08.2021.
//

import UIKit

extension UIViewController {
  func errorPopUp(message: String) {
    let popUpView = UIView()
    let screenSize = UIScreen.main.bounds
    let margin:CGFloat = 16
    let height:CGFloat = 50
    let label = UILabel()
    label.text = message
    label.textColor = .white
    popUpView.frame = CGRect(x: margin / 2, y: screenSize.height, width: screenSize.width - margin, height: height)
    popUpView.layer.cornerRadius = 5
    popUpView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.51)
    label.frame = CGRect(x: margin / 2, y: 0, width: screenSize.width - margin - height, height: height)
    popUpView.addSubview(label)
    self.view.addSubview(popUpView)
    
    UIView.animate(withDuration: 0.3) {
      popUpView.frame = popUpView.frame.offsetBy(dx: 0, dy: -90)
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
      popUpView.removeFromSuperview()
    }
    
  }
}
