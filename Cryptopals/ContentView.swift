//
//  ContentView.swift
//  Cryptopals
//
//  Created by Chris Downie on 4/25/21.
//

import SwiftUI

struct ContentView: View {
    let shouldRunAllChallenges = true
    
    var body: some View {
        Text("Hello, world!")
            .padding()
            .onAppear(perform: runCurrentChallenge)
    }
    
    func runCurrentChallenge() {
        if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] == nil {
            if shouldRunAllChallenges {
                let runner = MultipleChallengeRunner(types: Challenges.all)
                runner.run()
            } else {
                let runner = TimedChallengeRunner(challengeType: Challenges.current)
                runner.run()
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
