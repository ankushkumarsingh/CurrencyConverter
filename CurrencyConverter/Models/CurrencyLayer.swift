//
//  CurrencyLayer.swift
//  Marvel
//
//  Created by Ankush Singh on 23/11/20.
//

import Foundation

struct CurrencyLayer: Hashable, Codable {
  let success: Bool
  let terms: String
  let privacy: String
  let timestamp: Double
  let source: String
  let quotes: [String: Double]
}

// MARK: Convenience init
extension CurrencyLayer {
  init(currencyLayerDB: CurrencyLayerDB) {
    success = currencyLayerDB.success
    terms = currencyLayerDB.terms
    privacy = currencyLayerDB.privacy

    let dateStamp:TimeInterval = currencyLayerDB.date.timeIntervalSince1970
    timestamp = Double(dateStamp)
    source = currencyLayerDB.source
    let dbQuotes = currencyLayerDB.quotes
    var dict = [String: Double]()
    for quote in dbQuotes {
      dict[quote.name] = quote.value
    }
    quotes = dict
  }
}

// MARK: Default value
extension CurrencyLayer {
  static let defaultSource = "USD"
}

struct Quote: Hashable {
  let name: String
  let amount: Double
}
