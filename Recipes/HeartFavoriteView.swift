//
//  HeartFavoriteView.swift
//  Recipes
//
//  Created by Noelia Root on 11/29/23.
//

import SwiftUI

struct HeartFavoriteView: View {

    @Binding var isFavorited: Bool
    var sfSymbol: String
    var width: Double
    var color: UIColor
    var body: some View {
        Image(systemName: sfSymbol)
            .resizable()
            .scaledToFit()
            .fillHeart(isFavorited)
            .foregroundStyle(Color(color))
            .onTapGesture {
                withAnimation{
                    isFavorited.toggle()
                }
            }
            .frame(width: CGFloat(width))
    }
}

struct FillHeart: ViewModifier {
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
    func fillHeart(_ fill: Bool) -> some View {
        modifier(FillImage(fill: fill))
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var isFavorited: Bool = true
        var body: some View {
            HeartFavoriteView(
                isFavorited: $isFavorited,
                sfSymbol: "heart", width: 30,
                color: .systemRed
            )
        }
    }
    return PreviewWrapper()
}
