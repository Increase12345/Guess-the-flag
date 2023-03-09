


import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    
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
                        Text(viewModel.countries[viewModel.correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    .padding()
                    
                    // Performing loop of flags
                    ForEach(0..<3) { number in
                        Button(action: {
                            viewModel.flagTapped(number)
                        }, label: {
                            Image(viewModel.countries[number])
                                .renderingMode(.original)
                                .cornerRadius(20)
                                .shadow(radius: 10)
                                .opacity(viewModel.isOpacity && viewModel.catchFlag != number ? 0.25 : 1)
                                .accessibilityLabel(viewModel.labels[viewModel.countries[number], default: "Unknown flag"])
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
                Text("Score: \(viewModel.score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Spacer()
                Text("\(viewModel.gameProcess) tries left")
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
        
        // Performing Alerts
        .alert(viewModel.scoreTitle, isPresented: $viewModel.showingScoreAlert) {
            Button("Continue", action: viewModel.askQuestion)
        } message: {
            Text("That’s the flag of \(viewModel.countries[viewModel.catchFlag])")
        }
        .alert(viewModel.scoreTrigger ? "Oops your score is negative 😢 try again": "Congratulation 🥳", isPresented: $viewModel.showingEndAlert) {
            Button("Restart", action: viewModel.restartGame)
        } message: {
            Text("You finished and your score is \(viewModel.score)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
