//
//  CurrencyListDB.swift
//  CurrencyConverter
//
//  Created by Ankush Singh on 25/11/20.
//

import Foundation
import RealmSwift

@objcMembers
class CurrencyListDB: Object {

  dynamic var id = 0
  dynamic var name = ""

  override static func primaryKey() -> String? {
    return "id"
  }

  override static func indexedProperties() -> [String] {
    return ["name"]
  }

}
