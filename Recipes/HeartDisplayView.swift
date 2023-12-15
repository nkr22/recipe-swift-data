//
//  HeartDisplayView.swift
//  Recipes
//
//  Created by Noelia Root on 12/10/23.
//
// Walkthrough source: https://www.youtube.com/watch?v=dAMFgq4tDPM

import SwiftUI

struct HeartDisplayView: View {

    var isFavorited: Bool
    var sfSymbol: String = "heart"
    var width: Double = 30
    var color: UIColor = .systemRed
    var body: some View {
        Image(systemName: sfSymbol)
            .resizable()
            .scaledToFit()
            .fillHeart(isFavorited)
            .foregroundStyle(Color(color))
            .frame(width: CGFloat(width))
    }
}

//#Preview {
//    HeartDisplayView()
//}
