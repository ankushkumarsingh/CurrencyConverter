//
//  Results+Extension.swift
//  CurrencyConverter
//
//  Created by Ankush Singh on 25/11/20.
//

import Foundation
import RealmSwift

extension Results {
  func toArray() -> [Element] {
    return compactMap { $0 }
  }
}
