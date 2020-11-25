//
//  CurrencyConverterApp.swift
//  CurrencyConverter
//
//  Created by Ankush Singh on 23/11/20.
//

import SwiftUI

struct CurrencyConverterApp: View {
  @EnvironmentObject var store: CurrencyStore

  var body: some View {
    NavigationView {
      CurrencyListView(quotes: store.quotes(for: CurrencyLayer.defaultSource), currencies: store.currencies)
      }
    }
}
