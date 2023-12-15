//
//  View+ToolbarBackground.swift
//  Recipes
//
//  Created by Noelia Root on 12/12/23.
//

import SwiftUI

extension View {
  func navigationBarBackground(_ background: Color = Color("MainColor")) -> some View {
    return self
      .modifier(ColoredNavigationBar(background: background))
  }
}

struct ColoredNavigationBar: ViewModifier {
  var background: Color
  
  func body(content: Content) -> some View {
    content
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(background)
        .toolbarColorScheme(.dark, for: .navigationBar)
  }
}
