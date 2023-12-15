//
//  DirectionsView.swift
//  Recipes
//
//  Created by Noelia Root on 12/14/23.
//

import SwiftUI

struct DirectionsView: View {
    var directions: [Direction]
    var sortedDirections: [Direction] {
        directions.sorted(by: {$0.order < $1.order})
    }
    var notes: String
    
    var body: some View {
        Text("Directions")
            .foregroundStyle(Color("MainColor"))
        ForEach(sortedDirections) {direction in
            Text("\(direction.order). \(direction.direction)")
        }
        if notes != "" {
            Text("Notes")
                .foregroundStyle(Color("MainColor"))
            Text(notes).multilineTextAlignment(.leading)
        }
  
    }
}

//#Preview {
//    DirectionsView()
//}
