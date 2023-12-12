//
//  RatingsView.swift
//  Recipes
//
//  Created by Noelia Root on 11/29/23.
//

//Walkthrough source: https://www.youtube.com/watch?v=dAMFgq4tDPM

import SwiftUI

struct RatingsView: View {
    var maxRating: Int
    @Binding var currentRating: Int?
    var sfSymbol: String
    var width: Double
    var color: Color
    var body: some View {
        HStack {
            ForEach(1...maxRating, id: \.self) {rating in
                Image(systemName: sfSymbol)
                    .resizable()
                    .scaledToFit()
                    .fillImage(correctImage(for: rating))
                    .foregroundStyle(Color(color))
                    .onTapGesture {
                        withAnimation{
                            currentRating = rating
                        }
                    }
                    
            }
        }
        .frame(width: CGFloat(Double(maxRating) * width))
    }
    
    func correctImage(for rating: Int) -> Bool {
        if let currentRating, rating <= currentRating {
            return true
        } else {
            return false
        }
    }
}

struct FillImage: ViewModifier {
    let fill: Bool
    func body(content: Content) -> some View {
        if fill {
            content
                .symbolVariant(.fill)
        } else {
            content
        }
    }
}

extension View {
    func fillImage(_ fill: Bool) -> some View {
        modifier(FillImage(fill: fill))
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var currentRating: Int? = 3
        var body: some View {
            RatingsView(
                maxRating: 5,
                currentRating: $currentRating,
                sfSymbol: "star", width: 30,
                color: Color("BrightAccentColor")
            )
        }
    }
    return PreviewWrapper()
}
