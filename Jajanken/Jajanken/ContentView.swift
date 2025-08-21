//
//  ContentView.swift
//  Jajanken
//
//  Created by Olzhas Imangeldin on 21.08.2025.
//

import SwiftUI

struct ContentView: View {
    
    let choices = ["Rock", "Paper", "Scissors"]
    let winningChoices = ["Paper", "Scissors", "Rock"]
    let losingChoices = ["Scissors", "Rock", "Paper"]
    
    @State private var computerChoice: Int = Int.random(in: 0..<3)
    @State private var winCondition: Bool = Bool.random()
    
    @State private var playerScore: Int = 0
    @State private var questionsCount: Int = 1
    
    @State private var gameOver: Bool = false
    
    let questionLimit: Int = 10
    
    func playerChoiceMade(_ playerChoice: Int) {
        let correctChoice = winCondition ? winningChoices[computerChoice] : losingChoices[computerChoice]
        if choices[playerChoice] == correctChoice {
            playerScore += 1
        } else {
            playerScore -= 1
        }
    }

    
    func refreshConditions() {
        questionsCount += 1
        
        if questionsCount > questionLimit {
            gameOver = true
            return
        }
        
        winCondition = Bool.random()
        computerChoice = Int.random(in: 0..<3)
        
    }

    
    func resetGame() {
        playerScore = 0
        questionsCount = 1
        winCondition = Bool.random()
        computerChoice = Int.random(in: 0..<3)
        gameOver = false
    }

    
    
    var body: some View {
        VStack {
            
            HStack{
                VStack (spacing: 15) {
                    Image("gon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 200)
                    
                    Text("Jajanken")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Your score: \(playerScore)")
                        .font(.title)
                                        
                    Text("Question: \(questionsCount)/\(questionLimit)")
                        .font(.title)
                    
                }
            }
            Spacer()
            HStack {
                VStack {
                    HStack {
                        Text("You need to:")
                        Text(winCondition ? "win" : "lose")
                            .foregroundColor(winCondition ? .green : .red)
                            .bold()
                            .underline()
                    }
                    Image(choices[computerChoice])
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                }
            }
            
            Spacer()
            
            HStack {
                ForEach(0..<3, id: \.self) { index in
                    Button {
                        playerChoiceMade(index)
                        
                        refreshConditions()
                    } label: {
                        VStack {
                            Image(choices[index])
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                            Text(choices[index])
                        }
                    }
                }
            }
            
            Spacer()
            Spacer()
            
        }
        .alert("Game Ended", isPresented: $gameOver){
            Button("Play again", action: resetGame)
        } message: {
            switch playerScore {
            case -10 ..< -5:
                Text("Your result is low! Try again! \n Your score: \(playerScore)")
            case -5 ..< 5:
                Text("Your result is average! Try again! \n Your score: \(playerScore)")
            default:
                Text("Your result is high! Keep it up! \n Your score: \(playerScore)")
            }
        }
    }
}

#Preview {
    ContentView()
}
