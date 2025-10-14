//
//  ContentView.swift
//  BaseballApp
//
//  Created by Tushig Erdenebulgan on 10/8/25.
//
import SwiftUI

struct ContentView: View {
    @State private var index = 0
    @State private var opacity: Double = 1.0
    private let texts = ["Hello World", "Team Miracle", "Tushig, Durah, Brody"]

    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack {
                Spacer()
                Text(texts[index])
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(12)
                    .shadow(radius: 10)
                    .opacity(opacity)
                    .onTapGesture {
                        withAnimation { opacity = 0.0 }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            index = (index + 1) % texts.count
                            withAnimation { opacity = 1.0 }
                        }
                    }
                Spacer()
            }
        }
    }
}
