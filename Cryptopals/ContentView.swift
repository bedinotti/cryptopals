//
//  ContentView.swift
//  Cryptopals
//
//  Created by Chris Downie on 4/25/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
            .onAppear(perform: runCurrentChallenge)
    }
    
    func runCurrentChallenge() {
        if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] == nil {
            ChallengeOne.run()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
