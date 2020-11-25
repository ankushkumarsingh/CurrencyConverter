//
//  CurrencyUpdater.swift
//  CurrencyConverter
//
//  Created by Ankush Singh on 24/11/20.
//

import Foundation
import RealmSwift

class CurrencyUpdater {

  private let queueManager: QueueManager
  var currencyFetchTimer: Timer?
  private var currencyFetchOperation: CurrencyLayerFetchOperation?
  private var dispatchQueue = DispatchQueue(label: "com.ankushkumarsingh.backgroundWrite")

  init() {
    queueManager = QueueManager.shared
    currencyFetchTimer = Timer.scheduledTimer(timeInterval: 30*60, target: self, selector: #selector(fetchCurrentCurrencyData), userInfo: nil, repeats: true)
  }

  deinit {
    currencyFetchTimer?.invalidate()
  }

  fileprivate func currencyHandler() -> (Result<CurrencyLayer>) -> Void {
    return { [weak self] result in
      guard let self = self else {return}
      switch result {
        case .failure(let error):
          log("Could not copy file to disk: \(error.localizedDescription)")
        case .success(let currencyLayer):
          DispatchQueue.global(qos: .default).async {
            self.parseCurrencyLayer(currencyLayer: currencyLayer)
          }
      }
      self.currencyFetchOperation = nil
    }
  }

  @objc func fetchCurrentCurrencyData() {
    //http://api.currencylayer.com/live?access_key=360c26300af78dd73ad9a21fbfe85876
    let stringURL = "\(NetworkHelper.shared.baseURL)live?access_key=\(NetworkHelper.shared.accessKey)"
    if currencyFetchOperation != nil {
      currencyFetchOperation?.cancel()
      currencyFetchOperation = nil
    }
    currencyFetchOperation = CurrencyLayerFetchOperation(stringURL: stringURL)
    currencyFetchOperation?.name = stringURL
    currencyFetchOperation?.completionHandler = currencyHandler()
    if let operation = currencyFetchOperation {
      queueManager.enqueueDownload(operation)
    }
  }

  func parseCurrencyLayer(currencyLayer: CurrencyLayer) {
   create(currencyLayer: currencyLayer)
  }
}

extension CurrencyUpdater {

  private func convert(quotes: [String: Double]) -> List<QuoteDB>{
    let list = List<QuoteDB>()
    quotes.forEach { (key: String, value: Double) in
      let quote = QuoteDB()
      quote.name = key
      quote.value = value
      list.append(quote)
    }
    return list
  }

  func create(currencyLayer: CurrencyLayer) {
    do {
      let realm = try Realm()

      let currencyLayerDB = CurrencyLayerDB()
      currencyLayerDB.id = UUID().hashValue
      currencyLayerDB.success = currencyLayer.success
      currencyLayerDB.terms = currencyLayer.terms
      currencyLayerDB.privacy = currencyLayer.privacy
      currencyLayerDB.date = Date(timeIntervalSince1970: currencyLayer.timestamp)
      currencyLayerDB.source = currencyLayer.source
      currencyLayerDB.quotes = convert(quotes: currencyLayer.quotes)

      try realm.write {
        realm.add(currencyLayerDB)
      }
    } catch let error {
      // Handle error
      log(error.localizedDescription)
    }

  }
}