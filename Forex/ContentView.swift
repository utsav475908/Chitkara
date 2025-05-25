//
//  ContentView.swift
//  Forex
//
//  Created by kumar utsav on 24/05/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image("forex")
                .resizable()
                .frame(width: 300, height: 300)
                .padding()
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
