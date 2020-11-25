//
//  JsonLoader.swift
//  CurrencyConverter
//
//  Created by Ankush Singh on 25/11/20.
//

import Foundation
class JsonLoader {
  lazy var currencyLayer: CurrencyLayer? = {
    let bundle = Bundle.main
    guard let url = bundle.url(forResource: "DefaultCurrencyData", withExtension: "json") else { return nil }
    do {
      let data = try Data(contentsOf: url, options: .mappedIfSafe)
      let gameManifest = try JSONDecoder().decode(CurrencyLayer.self, from: data)
      return gameManifest
    } catch let error {
      log(error.localizedDescription)
    }
    return nil
  }()
}
