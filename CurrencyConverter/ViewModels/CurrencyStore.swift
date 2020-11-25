//
//  CurrencyStore.swift
//  Marvel
//
//  Created by Ankush Singh on 23/11/20.
//

import Foundation
import RealmSwift

final class CurrencyStore: ObservableObject {

  private var currencyLayerResults: Results<CurrencyLayerDB>
  private var currencyListResults: Results<CurrencyListDB>
  
  init(realm: Realm) {
    let currencyUpdater = CurrencyUpdater()
    currencyUpdater.fetchCurrentData()
    currencyLayerResults = realm.objects(CurrencyLayerDB.self).sorted(byKeyPath: "date")
    currencyListResults = realm.objects(CurrencyListDB.self)
  }

  func currencyLayer(for currency: String)-> CurrencyLayer? {
    if let currencyLayerDB = currencyLayerResults.filter("source = %@",currency).first {
      return CurrencyLayer(currencyLayerDB: currencyLayerDB)
    }
    return nil
  }

  var currencies: [String] {
    currencyListResults.map {$0.name}
  }

  func quotes(for currency: String) -> [Quote] {
    if let layer = currencyLayer(for: currency) {
      return layer.quotes.compactMap({ (key: String, value: Double) -> Quote in
        return Quote(name: key, amount: value)
      })
    }
    return []
  }


}

// MARK: - CRUD Actions
extension CurrencyStore {

  func create(currencyLayer: CurrencyLayer) {
    objectWillChange.send()

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

  func update(currencyLayerID: Int, currencyLayer: CurrencyLayer) {
    objectWillChange.send()
    do {
      let realm = try Realm()
      try realm.write {
        realm.create(
          CurrencyLayerDB.self,
          value: [
            "id": currencyLayerID,
            "success": currencyLayer.success,
            "terms": currencyLayer.terms,
            "privacy": currencyLayer.privacy,
            "timestamp": currencyLayer.timestamp,
            "source": currencyLayer.source,
            "quotes": convert(quotes: currencyLayer.quotes)
          ],
          update: .modified)
      }
    } catch let error {
      log(error.localizedDescription)
    }
  }

  func delete(currencyLayerID: Int) {
    objectWillChange.send()
    guard let currencyLayerID = currencyLayerResults.first(
            where: { $0.id == currencyLayerID })
    else { return }

    do {
      let realm = try Realm()
      try realm.write {
        realm.delete(currencyLayerID)
      }
    } catch let error {
      log(error.localizedDescription)
    }
  }
}
