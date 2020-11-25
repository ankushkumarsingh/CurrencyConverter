//
//  CurrencyLayerDB.swift
//  Marvel
//
//  Created by Ankush Singh on 23/11/20.
//

import Foundation
import RealmSwift

@objcMembers
class CurrencyLayerDB: Object {

  dynamic var id = 0
  dynamic var success = false
  dynamic var terms = ""
  dynamic var privacy = ""
  dynamic var date = Date()
  dynamic var source = ""
  dynamic var quotes = List<QuoteDB>()

  override static func primaryKey() -> String? {
    return "id"
  }

  override static func indexedProperties() -> [String] {
    return ["source"]
  }

}

@objcMembers
class QuoteDB: Object {
  dynamic var name = ""
  dynamic var value = 0.0
}
