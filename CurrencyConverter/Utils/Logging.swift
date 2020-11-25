//
//  Logging.swift
//  CurrencyConverter
//
//  Created by Ankush Singh on 25/11/20.
//

import Foundation
func log(_ message: String) {
  #if DEBUG
  print(message)
  #endif
}
