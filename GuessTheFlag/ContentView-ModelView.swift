//
//  ContentView-ModelView.swift
//  GuessTheFlag
//
//  Created by Nick Pavlov on 3/8/23.
//

import Foundation

extension ContentView {
    @MainActor class ViewModel: ObservableObject {
        @Published var showingScoreAlert = false
        @Published var showingEndAlert = false
        @Published var gameProcess = 10
        @Published var scoreTitle = ""
        @Published var score = 0
        @Published var correctAnswer = Int.random(in: 0...2)
        @Published var catchFlag = 0
        @Published var scoreTrigger = false
        @Published var isOpacity = false
        @Published var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
        
        let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
        ]
        
        // Define was the answer correct or not + triggering alrets
        func flagTapped(_ number: Int) {
            catchFlag = number
            if gameProcess > 1 {
                if number == correctAnswer {
                    scoreTitle = "Correct"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        self.score += 100
                    }
                    gameProcess -= 1
                    isOpacity = true
                } else {
                    scoreTitle = "Wrong!"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        self.score -= 100
                    }
                    gameProcess -= 1
                    isOpacity = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    self.showingScoreAlert = true
                }
            } else {
                if score < 0 {
                    scoreTrigger = true
                }
                showingEndAlert = true
                gameProcess = 0
                
            }
        }

        // Method for alert during the game
        func askQuestion() {
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
            isOpacity = false
        }
        
        // Method for alert at the end of the game
        func restartGame() {
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
            gameProcess = 10
            score = 0
        }
    }
}
