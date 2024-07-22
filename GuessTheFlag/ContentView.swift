//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Enzo Ficoseco on 16/07/2024.
// Project 2

import SwiftUI

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}
//////////////////////////////////////
struct FlagImage: View {
    var imageName : String
    
    
    var body: some View {
        Image(imageName)
            .clipShape(.buttonBorder)
            .shadow(radius: 5)
    }
}

struct ContentView: View {
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var showingGameOver = false
    @State private var scoreTitle = ""
    @State private var userScore = 0
    @State private var tries = 0
    @State private var questionsAsked = 0
    @State private var totalQuestions = 8
    
    
    
    
    
    
    var body: some View {
        ZStack{
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.35), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
            VStack{
                
                Spacer()
                Text("Guess the Flag")
                    .foregroundColor(.white)
                    .titleStyle()
                VStack(spacing: 15){
                    VStack{
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .titleStyle()
                    }
                    
                    ForEach(0..<3) { number in
                        Button{
                            flagTapped(number)
                        } label: {
                            FlagImage(imageName: countries[number])
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score \(userScore)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                Text("Try: \(tries)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        
            .alert(scoreTitle, isPresented: $showingScore){
                Button("Continue", action: askQuestion)
            } message: {
                Text("Your score is \(userScore)")
            }
        
            .alert("Game Over", isPresented: $showingGameOver){
                Button("Restart", action: resetGame)
            } message: {
                Text("Your final score is \(userScore)")
            }
        
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct!"
            userScore += 1
        } else {
            scoreTitle = "Wrong.. That's the flag of \(countries[number])"
            if userScore > 0 {
                userScore -= 1
            }
        }
        tries += 1
        
        if tries == totalQuestions {
            showingGameOver = true
        } else {
            showingScore = true
        }
        
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func resetGame(){
        userScore = 0
        tries = 0
        askQuestion()
    }
        
}

#Preview {
    ContentView()
}
