//
//  CurrencyListView.swift
//  CurrencyConverter
//
//  Created by Ankush Singh on 24/11/20.
//

import SwiftUI
import RealmSwift

var currentCurrency = CurrencyLayer.defaultSource

struct CurrencyListView: View {

  @EnvironmentObject var store: CurrencyStore
  @State private var amount = "1"
  @State private var selectedCurrencyIndex = 0
  let quotes: [Quote]
  let currencies: [String]

  @State private var exchangeRatesToShow: [Quote] = []

  var body: some View {
    VStack{
      Text("Amount to be converted")
      TextField("Enter the amount", text: $amount)
      NavigationView {
        Form {
          Section {
            Picker(selection: $selectedCurrencyIndex, label: Text("Currency")) {
              ForEach(0 ..< currencies.count) {
                Text(self.currencies[$0])
              }
            }          }
        }
      }
      let selectedCurrency = currencies.isEmpty ? CurrencyLayer.defaultSource: currencies[selectedCurrencyIndex]
      Text("Currency Choosen: \(selectedCurrency)")
      Spacer()
      addConvertButton
      List {
        Section(header: Text("Exchange Rates")) {
          ForEach(quotes, id: \.self) { quote in
            AmountRow(quote: quote)
          }
        }
      }
      .listStyle(GroupedListStyle())
    }.navigationBarTitle("Currency Current Value")
  }

  var addConvertButton: some View {
    Button(action: convert) {
      HStack {
        Text("Convert")
          .bold()
      }
    }
    .foregroundColor(.green)
    .padding()
    .border(Color.green, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
    .cornerRadius(5.0)
  }

}


// MARK: - Actions
extension CurrencyListView {
  func convert() {
    let selectedCurrency = currencies.isEmpty ? CurrencyLayer.defaultSource: currencies[selectedCurrencyIndex]
    currentCurrency = selectedCurrency
    print("Convert Pressed")

  }
}

