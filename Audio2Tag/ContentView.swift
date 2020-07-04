//
//  ContentView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/06/04.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            CueView().tabItem {
                Text("Trim Cue")
            }
            TagMainView().tabItem {
                Text("Convert")
            }
            EmptyView().tabItem {
                Text("Tagging")
            }
            EmptyView().tabItem {
                Text("Setting")
            }
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
