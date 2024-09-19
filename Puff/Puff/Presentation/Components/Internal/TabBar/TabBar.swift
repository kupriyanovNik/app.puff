//
//  TabBar.swift
//  Puff
//
//  Created by Никита Куприянов on 18.09.2024.
//

import SwiftUI

struct TabBar: View {

    @Binding var selectedTab: TabBarModel

    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    @Previewable @State var selectedTab: TabBarModel = .home

    TabBar(selectedTab: $selectedTab)
}
