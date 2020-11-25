//
//  NetworkHelper.swift
//  CurrencyConverter
//
//  Created by Ankush Singh on 24/11/20.
//

import Foundation
import Reachability

public enum APIError: Error {
  case unknown
  case missingData
  case serialization
  case invalidData
  case unzipFailure
  case downloadFailure
  case decryptionFailure
  case networkUnavailable
  case alreadyDownloaded
}

enum HTTPRequestMethod: String {
  case get = "GET"
  case post = "POST"
}

final class NetworkHelper {

  static let shared = NetworkHelper()

  var reachability: Reachability!
  let baseURL: String
  let accessKey: String

  private init() {
    self.baseURL = "http://api.currencylayer.com/"
    self.accessKey = "360c26300af78dd73ad9a21fbfe85876"
    start()
  }

  class var connectedToNetwork: Bool {
    false
  }

  func baseRequest(stringURL: String) -> URLRequest {
    let url = URL(string: stringURL)!
    var request = URLRequest(url: url)
    request.httpMethod = HTTPRequestMethod.get.rawValue
    return request
  }

  func jsonRequest(stringURL: String) -> URLRequest {
    var request = baseRequest(stringURL: stringURL)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    return request
  }

  func start() {
    do {
      reachability = try Reachability()
    } catch let error {
      log(error.localizedDescription)
    }
    reachability.whenUnreachable = { _ in
      log("Not reachable")
    }

    NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
    do{
      try reachability.startNotifier()
    }catch{
      log("could not start reachability notifier")
    }
  }

  @objc func reachabilityChanged(note: Notification) {

    let reachability = note.object as! Reachability

    switch reachability.connection {
      case .wifi:
        log("Reachable via WiFi")
      case .cellular:
        log("Reachable via Cellular")
      case .unavailable:
        log("Network not reachable")
      case .none:
        log("none")
    }
  }

  func stop() {
    reachability.stopNotifier()
    NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
  }
}
