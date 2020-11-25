//
//  AmountRow.swift
//  CurrencyConverter
//
//  Created by Ankush Singh on 15/11/20.
//

import SwiftUI

struct AmountRow: View {

  @EnvironmentObject var store: CurrencyStore

  let quote: Quote

    var body: some View {
      HStack {
        Text(quote.name)
        Spacer()
        Text("\(quote.amount)")
      }
    }
}

