//
//  AmountRow.swift
//  CurrencyConverter
//
//  Created by Ankush Singh on 15/11/20.
//

import SwiftUI

struct AmountRow: View {
  @EnvironmentObject var store: CurrencyStore
  @State private var amount = "0"
  let quote: String

    var body: some View {
      VStack {
        TextField("Enter the amount", text: $amount)
        Text("Quote, \(quote)")
        Text("Amount, \(amount)!")
      }
    }
}

#if DEBUG
//struct IngredientRow_Previews: PreviewProvider {
//  static var previews: some View {
//    Group {
//      
//    }
//    .previewLayout(.sizeThatFits)
//  }
//}
#endif
