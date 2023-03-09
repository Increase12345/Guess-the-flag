


import SwiftUI

struct ContentView: View {
    @State private var showingScoreAlert = false
    @State private var showingEndAlert = false
    @State private var gameProcess = 10
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var catchFlag = 0
    @State private var scoreTrigger = false
    @State private var isOpacity = false
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    
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

    var body: some View {
        ZStack {
            
            // Background setup
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // Title
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                // Working Space with user interaction
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    .padding()
                    
                    // Performing loop of flags
                    ForEach(0..<3) { number in
                        Button(action: {
                            flagTapped(number)
                        }, label: {
                            Image(countries[number])
                                .renderingMode(.original)
                                .cornerRadius(20)
                                .shadow(radius: 10)
                                .opacity(isOpacity && catchFlag != number ? 0.25 : 1)
                                .accessibilityLabel(labels[countries[number], default: "Unknown flag"])
                        })
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                Spacer()
                Spacer()
                
                // Bottom score information
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Spacer()
                Text("\(gameProcess) tries left")
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
        
        // Performing Alerts
        .alert(scoreTitle, isPresented: $showingScoreAlert) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("That’s the flag of \(countries[catchFlag])")
        }
        .alert(scoreTrigger ? "Oops your score is negative 😢 try again": "Congratulation 🥳", isPresented: $showingEndAlert) {
            Button("Restart", action: restartGame)
        } message: {
            Text("You finished and your score is \(score)")
        }
    }

    // Define was the answer correct or not + triggering alrets
    func flagTapped(_ number: Int) {
        catchFlag = number
        if gameProcess > 1 {
            if number == correctAnswer {
                scoreTitle = "Correct"
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    score += 100
                }
                gameProcess -= 1
                isOpacity = true
            } else {
                scoreTitle = "Wrong!"
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    score -= 100
                }
                gameProcess -= 1
                isOpacity = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                showingScoreAlert = true
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
