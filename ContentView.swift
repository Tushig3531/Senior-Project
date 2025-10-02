//
//  ContentView.swift
//  
//
//  Created by Tushig Erdenebulgan on 10/1/25.
//
import SwiftUI
struct ContentView: View {
    var body: some View {
        ZStack{
            LinearGradient(
                colors: [Color.blue, Color.purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoreSafeArea()
            
            VStack{
                Spacer()
                Text(showName ? "Team Miracle":"Hello World"):
                    .font(.system(size:40,weight:.bold,design:.rounded))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(12)
                    .shadow(radius:10)
                    .scaleEffect(animateThrow ? 0.5:1.0)
                    .offset(x: animateThrow ? 200 : 0, y: animateThrow ? -400 : 0)
                    .rotationEffect(.degress(animateThrow ? 720 : 0))
                    .animation(.easeIn(duration:1),value: animateThrow)
                    .onTapGesture{
                        animateThrow=true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            showName=true
                            animateThrow=false
                        }
                    }
                Spacer()
            }
        }
    }
}
#Preview{
    ContentView()
}


