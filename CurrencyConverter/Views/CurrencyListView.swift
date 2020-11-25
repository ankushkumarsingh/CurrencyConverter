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
  var currencyOptions = CurrencyType.allCases.map {$0.rawValue}
  @State private var selectedCurrencyIndex = 0
  let quotes: [Quote]

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
    print("Convert Pressed")

  }
}

