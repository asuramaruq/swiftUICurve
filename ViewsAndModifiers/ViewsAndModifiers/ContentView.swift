//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by Olzhas Imangeldin on 19.08.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Modifier with Extension")
            .prominentTitle()
    }
}

struct ProminentTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundStyle(.blue)
    }
}

extension View {
    func prominentTitle() -> some View {
        modifier(ProminentTitle())
    }
}

#Preview {
    ContentView()
}
