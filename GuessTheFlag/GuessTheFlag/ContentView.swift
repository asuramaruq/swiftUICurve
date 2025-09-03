//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Olzhas Imangeldin on 17.08.2025.
//

import SwiftUI

struct ContentView: View {
    
    @State private var countries: [String] = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in:0...2)
    @State private var chosenFlag: Int = 5
    
    @State private var showingScoreAlert = false
    @State private var scoreTitle = ""
    
    @State private var score: Int = 0
    @State private var questionCounter: Int = 1
    
    @State private var gameEnd = false
    
    @State private var animationAmount = [0.0, 0.0, 0.0]
    @State private var fadeAmount = 1.0
    
    func flagTapped(_ number: Int) {
        chosenFlag = number
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 2
        } else {
            scoreTitle = "Wrong"
            score -= 1
        }

        showingScoreAlert = true
    }
    
    func askQuestion() {
        countries.shuffle()
        if questionCounter == 8 { gameEnd = true }
        questionCounter += 1
        correctAnswer = Int.random(in: 0...2)
        chosenFlag = 5
    }
    
    func resetGame() {
        score = 0
        questionCounter = 0
        askQuestion()
    }
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
                .ignoresSafeArea()
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)
                
                VStack (spacing: 15) {
                    VStack {
                        Text("Tap the flag of ")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .foregroundStyle(.primary)
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            withAnimation (.easeInOut) {
                                animationAmount[number] += 360
                            }
                            flagTapped(number)
                        } label: {
                            FlagImage(country: countries[number])
                        }
                        .rotation3DEffect(.degrees(animationAmount[number]), axis: (x: 0, y: 1, z: 0))
                        .opacity((chosenFlag == 5 || chosenFlag == number) ? 1.0 : 0.25)
                        .scaleEffect((chosenFlag == 5 || chosenFlag == number) ? 1.0 : 0.8)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.thinMaterial)
                .clipShape(.rect(cornerRadius: 20))

                
                Spacer()
                
                Button {
                    resetGame()
                } label: {
                    Text("Restart")
                        .font(.title2.bold())
                }
                .buttonStyle(.borderedProminent)
                .tint(Color(red: 0.1, green: 0.2, blue: 0.45))

                Spacer()
                
                Text("Question: \(questionCounter)/8")
                    .foregroundStyle(.white)
                    .font(.title2.bold())
                
                Spacer()
            }
            .padding(20)
        }
        .alert("Game Ended", isPresented: $gameEnd){
            Button("Play again", action: resetGame)
        } message: {
            switch score {
            case 0..<5:
                Text("Your result is low! Try again! \n Your score: \(score)")
            case 5..<12:
                Text("Your result is average! Try again! \n Your score: \(score)")
            default:
                Text("Your result is high! Keep it up! \n Your score: \(score)")
            }
        }
        .alert(scoreTitle, isPresented: $showingScoreAlert){
            Button("Continue", action: askQuestion)
        } message: {
            if chosenFlag != correctAnswer {
                Text("Incorrect! This is \(countries[chosenFlag]) flag. \n Current score: \(score)")
            } else {
                Text("Correct! This is \(countries[correctAnswer]) flag. \n Current score: \(score)")
            }
        }
    }
}

struct FlagImage: View {
    var country: String
    
    var body: some View {
        Image(country)
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
}

#Preview {
    ContentView()
}
