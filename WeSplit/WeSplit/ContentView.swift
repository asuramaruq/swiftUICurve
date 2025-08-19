//
//  ContentView.swift
//  WeSplit
//
//  Created by Olzhas Imangeldin on 12.08.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 10
    
    @FocusState private var amountIsFocused: Bool
    
    let tipPercentages = [30, 25, 20, 15, 10, 5, 0]
    
    var totalAmount: Double {
        guard checkAmount > 0 else { return 0 }
        let tipAmount = checkAmount * Double(tipPercentage) / 100
        return checkAmount + tipAmount
    }
    
    var totalPerPerson: Double {
        return totalAmount / Double(numberOfPeople + 2)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section ("Check Amount") {
                    TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused)
                }
                    
                Section ("How much do you want to tip?") {
                    Picker("Tip percentage", selection: $tipPercentage) {
                        //ForEach(tipPercentages, id: \.self) {
                        //    Text($0, format: .percent)
                        //}
                        ForEach(0..<101) {
                            Text($0, format: .percent)
                        }
                    }
                    .pickerStyle(.navigationLink)
                    //.pickerStyle(.segmented)
                }
                
                Section {
                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2..<100) {
                            Text("\($0) people")
                        }
                    }
                    .pickerStyle(.navigationLink)
                }
                
                Section ("Total Amount"){
                    Text(totalAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .foregroundStyle(tipPercentage == 0 ? .red : .primary)
                }
                
                Section ("Amount Per Person") {
                    Text(totalPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                }
            }
            .navigationTitle("WeSplit")
            .toolbar {
                if amountIsFocused {
                    Button("Done") {
                        amountIsFocused = false
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
