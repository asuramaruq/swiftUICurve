//
//  ContentView.swift
//  DistanceConverter
//
//  Created by Olzhas Imangeldin on 16.08.2025.
//

import SwiftUI

struct ContentView: View {
    
    @State var inputValue: Double = 0.0
    @State var inputUnit: String = "m"
    @State var outputUnit: String = "km"
    
    @FocusState var isFocused: Bool
    
    let units: [String] = ["m", "km", "feets", "yards", "miles"]
    
    var outputValue: Double {
        var value: Double = 0
        
        //convert everything to meters
        switch inputUnit {
        case "m":
            value = inputValue
        case "km":
            value = inputValue * 1000
        case "feets":
            value = inputValue / 3.281
        case "yards":
            value = inputValue / 1.094
        case "miles":
            value = inputValue * 1609
        default:
            return 0
        }
        
        //convert meters to outputUnit
        switch outputUnit {
        case "m":
            return value
        case "km":
            return value / 1000
        case "feets":
            return value * 3.281
        case "yards":
            return value * 1.094
        case "miles":
            return value / 1609
        default:
            return 0
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section ("Input") {
                    // text field to input the value
                    TextField("Enter the value: ", value: $inputValue, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($isFocused)
                    // picker to choose the unit
                    Picker("Unit", selection: $inputUnit) {
                        ForEach(units, id: \.self) {
                            Text($0)
                        }
                    }.pickerStyle(.segmented)
                }
                
                Section ("Output") {
                    // text view to show the output value
                    Text(outputValue, format: .number)
                    // picker to choose output value unit
                    Picker("Unit", selection: $outputUnit) {
                        ForEach(units, id: \.self) {
                            Text($0)
                        }
                    }.pickerStyle(.segmented)
                }
            }
            .navigationTitle("Distance Converter")
            .toolbar {
                if isFocused {
                    Button("Done") {
                        isFocused = false
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
