//
//  ViewController.swift
//  scorpCase
//
//  Created by Gokberk Bardakci on 29.08.2021.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  
  private var viewModel: ViewModel!
  let refreshControl = UIRefreshControl()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self
    tableView.allowsSelection = false
    
    refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
    
    tableView.addSubview(refreshControl)
    refreshControl.beginRefreshing()
    
    viewModel = ViewModel(delegate: self)
    viewModel.fetchPeople()
  }
  
  @objc func refresh(_ sender: AnyObject) {
    viewModel.clearPeople()
    tableView.reloadData()
    viewModel.fetchPeople()
  }
  
  func isRefreshing() -> Bool {
    return refreshControl.isRefreshing
  }
  
}

// MARK: UIScrollViewDelegate
extension ViewController: UIScrollViewDelegate {
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    let offsetY = scrollView.contentOffset.y
    let contentHeight = scrollView.contentSize.height
    let isDeepOfScrollView = offsetY > (contentHeight - scrollView.frame.size.height)
    if !viewModel.people.isEmpty && !viewModel.isFetching && isDeepOfScrollView {
        viewModel.fetchPeople()
    }
  }
}

// MARK: UITableViewDataSource, UITableViewDelegate
extension ViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if viewModel.people.isEmpty {
      let message = Constants.emptyViewMessage
      tableView.setEmptyView(message: message, viewController: self)
    }else {
      tableView.disableEmptyLabel()
    }
    return viewModel.people.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath)
    cell.textLabel?.text = "\(viewModel.people[indexPath.row].fullName) (\(viewModel.people[indexPath.row].id))"
    
    if indexPath.row > viewModel.people.count - Constants.tableViewRefetchThreshold {
      viewModel.fetchPeople()
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if viewModel.isFetching {
      let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
      spinner.startAnimating()
      spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
      
      tableView.tableFooterView = spinner
      tableView.tableFooterView?.isHidden = false
    }
  }
  
}

// MARK: ViewModelDelegate
extension ViewController: ViewModelDelegate {  
  func onFetchCompleted(message: String?) {
    self.tableView.tableFooterView?.isHidden = true
    if isRefreshing() {
      refreshControl.endRefreshing()
    }
    if let message = message {
      self.errorPopUp(message: message)
    }else {
      self.tableView.reloadData()
    }
  }
  
}
