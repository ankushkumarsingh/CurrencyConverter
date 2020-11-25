//
//  CurrencyListView.swift
//  CurrencyConverter
//
//  Created by Ankush Singh on 24/11/20.
//

import SwiftUI
import RealmSwift

struct CurrencyListView: View {

  @EnvironmentObject var store: CurrencyStore
  @State private var amount = "0"
  var currencyOptions = CurrencyOptions.allCases.map {$0.rawValue}
  @State private var selectedCurrencyIndex = 0
  let quotes: [String]

  var body: some View {
    VStack{
      Text("Amount to be converted")
      TextField("Enter the amount", text: $amount)
      NavigationView {
        Form {
          Section {
            Picker(selection: $selectedCurrencyIndex, label: Text("Currency")) {
              ForEach(0 ..< currencyOptions.count) {
                Text(self.currencyOptions[$0])
              }
            }          }
        }
      }
      Text("Currency Choosen: \(currencyOptions[selectedCurrencyIndex])")
      List {
        Section(header: Text("Exchange Rates")) {
          ForEach(quotes, id: \.self) { quote in
            AmountRow(quote: quote)
          }
          addConvertButton
        }
      }
      .listStyle(GroupedListStyle())
    }.navigationBarTitle("Currency Current Value")
  }

  var addConvertButton: some View {
    Button(action: convert) {
      HStack {
        Image(systemName: "plus.circle.fill")
        Text("Convert")
          .bold()
      }
    }
    .foregroundColor(.green)
  }

}


// MARK: - Actions
extension CurrencyListView {
  func convert() {
    print("Convert Pressed")
//    marvelCharFormIsPresented.toggle()
  }
}

#if DEBUG
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//
//    }
//}
#endif
