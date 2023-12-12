//
//  RatingsDisplayView.swift
//  Recipes
//
//  Created by Noelia Root on 12/8/23.
//

import SwiftUI

struct RatingsDisplayView: View {
    var maxRating: Int
    var currentRating: Int?
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

#Preview {
    RatingsDisplayView(
        maxRating: 5,
        currentRating: 3,
        sfSymbol: "star", width: 30,
        color: Color("MainColor")
    )
}
