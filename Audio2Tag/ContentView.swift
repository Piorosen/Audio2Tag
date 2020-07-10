//
//  ContentView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/07/10.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            CueView().tabItem {
                Text("Cue")
            }
            TagView().tabItem {
                Text("Tag")
            }
            FileView().tabItem {
                Text("File")
            }
            SettingView().tabItem {
                Text("Setting")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
