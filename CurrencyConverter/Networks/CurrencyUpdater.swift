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
    currencyFetchTimer = Timer.scheduledTimer(timeInterval: 30*60, target: self, selector: #selector(fetchCurrencyListData), userInfo: nil, repeats: true)
    fetchCurrencyListData()
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

  @objc func fetchCurrentData() {
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

  @objc func fetchCurrencyListData() {
    do {
      let realm = try Realm()
      let currencyListResults = realm.objects(CurrencyListDB.self)
      let currencyStringList = currencyListResults.reduce("USD") { (partialResult, currencyListDB) -> String in
        let newString = partialResult + "," + currencyListDB.name
        return newString
      }
      let stringURL = "\(NetworkHelper.shared.baseURL)live?access_key=\(NetworkHelper.shared.accessKey)&currencies=\(currencyStringList)"
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

    } catch let error {
      log(error.localizedDescription)
    }

  }

  func parseCurrencyLayer(currencyLayer: CurrencyLayer) {
   create(currencyLayer: currencyLayer)
  }
}

extension CurrencyUpdater {

  private func convert(quotes: [String: Double], with source: String) -> (quotes: List<QuoteDB>, currencies: List<String>){
    let quoteList = List<QuoteDB>()
    let currencyList = List<String>()
    quotes.forEach { (key: String, value: Double) in
      let currencyName = key.replacingOccurrences(of: source, with: "")
      currencyList.append(currencyName)
      let quote = QuoteDB()
      quote.name = currencyName
      quote.value = value
      quoteList.append(quote)
    }
    return (quotes: quoteList, currencies: currencyList)
  }

  func create(currencyLayer: CurrencyLayer) {
    do {
      let realm = try Realm()

      let currencyTuple = convert(quotes: currencyLayer.quotes, with: currencyLayer.source)

      let currencyLayerDB = CurrencyLayerDB()
      currencyLayerDB.id = UUID().hashValue
      currencyLayerDB.success = currencyLayer.success
      currencyLayerDB.terms = currencyLayer.terms
      currencyLayerDB.privacy = currencyLayer.privacy
      currencyLayerDB.date = Date(timeIntervalSince1970: currencyLayer.timestamp)
      currencyLayerDB.source = currencyLayer.source
      currencyLayerDB.quotes = currencyTuple.quotes

      try realm.write {

        realm.add(currencyLayerDB)

        let currencyListDB = CurrencyListDB()
        currencyListDB.id = UUID().hashValue
        currencyListDB.name = CurrencyLayer.defaultSource
        realm.add(currencyListDB)

        let currencies = currencyTuple.currencies
        for currency in currencies {
          let currencyListDB = CurrencyListDB()
          currencyListDB.id = UUID().hashValue
          currencyListDB.name = currency
          realm.add(currencyListDB)
        }

      }
    } catch let error {
      // Handle error
      log(error.localizedDescription)
    }

  }
}
