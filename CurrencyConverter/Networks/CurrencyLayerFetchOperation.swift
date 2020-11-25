//
//  CurrencyLayerFetchOperation.swift
//  CurrencyConverter
//
//  Created by Ankush Singh on 24/11/20.
//

import Foundation
class CurrencyLayerFetchOperation: ConcurrentOperation<CurrencyLayer> {
  private let session: URLSession
  private var task: URLSessionTask?
  private let stringURL: String

  init(session: URLSession = URLSession.shared, stringURL: String) {
    self.session = session
    self.stringURL = stringURL
  }

  override func main() {
    NetworkHelper.shared.reachability.whenReachable = { [weak self] _ in
      guard let self = self else {return}
      if let url = URL(string: self.stringURL) {
        self.task = self.session.dataTask(with: url) { data, response, error in
          if let data = data {
            do {
              let res = try JSONDecoder().decode(CurrencyLayer.self, from: data)
              self.complete(result: .success(res))
              log(response.debugDescription)
            } catch let error {
              self.complete(result: .failure(error))
              log(error.localizedDescription)
            }
          }
        }
      }
      self.task?.resume()
    }
    NetworkHelper.shared.reachability.whenUnreachable = { [weak self] _ in
      self?.complete(result: .failure(APIError.networkUnavailable))
    }

  }
}
