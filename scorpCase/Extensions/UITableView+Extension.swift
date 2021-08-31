//
//  UITableView+Extension.swift
//  scorpCase
//
//  Created by Gokberk Bardakci on 29.08.2021.
//

import UIKit

extension UITableView {
  func setEmptyView(message: String, viewController: UIViewController) {
    let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: viewController.view.bounds.width, height: viewController.view.bounds.height))
    emptyLabel.isUserInteractionEnabled = true
    emptyLabel.numberOfLines = 0
    emptyLabel.text = message
    emptyLabel.textAlignment = NSTextAlignment.center
    self.backgroundView = emptyLabel
    self.separatorStyle = UITableViewCell.SeparatorStyle.none
  }
  
  func disableEmptyLabel() {
    self.backgroundView = nil
    self.separatorStyle = .singleLine
  }
}
