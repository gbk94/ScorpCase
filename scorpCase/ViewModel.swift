//
//  ViewModel.swift
//  scorpCase
//
//  Created by Gokberk Bardakci on 29.08.2021.
//

import Foundation

protocol ViewModelDelegate: AnyObject {
  func onFetchCompleted(message: String?)
}

class ViewModel {
  var next: String?
  var people = [Person]()
  var isFetching = false
  var lastFetchTimestamp = Date().timeIntervalSince1970 - 1
  private weak var delegate: ViewModelDelegate?
  
  init(delegate: ViewModelDelegate) {
    self.delegate = delegate
  }
  
  func fetchPeople() {
    if isFetching {
      return
    }
    
    isFetching = true
    
    if Date().timeIntervalSince1970 > lastFetchTimestamp + Constants.fetchTimeBuffer {
      fetchPeople(retryCounter: 0)
    }else {
      isFetching = false
      return
    }
    
  }
  
  private func fetchPeople(retryCounter: Int){
      DataSource.fetch(next: next) { (fetchResponse, fetchError) in
        self.lastFetchTimestamp = Date().timeIntervalSince1970
        if let error = fetchError {
          self.delegate?.onFetchCompleted(message: error.errorDescription)
          self.isFetching = false
          return
        }
        if let response = fetchResponse {
          if response.people.count == 0 {
            self.isFetching = false
            if retryCounter < Constants.maxRetryCount {
              self.fetchPeople(retryCounter: retryCounter + 1)
            }else {
              self.delegate?.onFetchCompleted(message: Constants.tryAgainMessage)
            }
            return
          }
          self.next = response.next
          let uniquePeople = self.getUniquePeople(incomingPeople: response.people)
          if uniquePeople.count == 0 {
            self.delegate?.onFetchCompleted(message: Constants.noMorePeopleMessage)
          }else {
            self.people.append(contentsOf: uniquePeople)
            self.delegate?.onFetchCompleted(message: nil)
          }
          self.isFetching = false
        }
      }
    
  }
  
  func getUniquePeople (incomingPeople: [Person]) -> [Person] {
    var uniquePeople = [Person]()
    for person in incomingPeople {
      if !self.people.contains(where: {$0.id == person.id}) {
        uniquePeople.append(person)
      }
    }
    return uniquePeople
  }
  
  func clearPeople() {
    next = nil
    people = []
  }
  
}
