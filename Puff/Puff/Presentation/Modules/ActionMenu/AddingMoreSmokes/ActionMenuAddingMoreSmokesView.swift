//
//  ActionMenuAddingMoreSmokesView.swift
//  Puff
//
//  Created by Никита Куприянов on 26.09.2024.
//

import SwiftUI

struct ActionMenuAddingMoreSmokesView: View {

    var onAddedMoreSmokes: (Int) -> Void
    var onDismiss: () -> Void

    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    ActionMenuAddingMoreSmokesView { _ in

    } onDismiss: {

    }
}
