//
//  ContentView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/07/10.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI


struct ContentView: View {
    
    let cue = CueView()
    
    func test(_ urls:[URL]) {
        cue.test(urls: urls)
    }
    
    var body: some View {
        TabView {
            cue.tabItem {
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
//        .onAppear {
//            guard let cue = Bundle.main.urls(forResourcesWithExtension: "cue", subdirectory: nil) else {
//                return
//            }
//            guard let wav = Bundle.main.urls(forResourcesWithExtension: "wav", subdirectory: nil) else {
//                return
//            }
//            
//            let url = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask)[0]
//            
//            for item in cue {
//                try? FileManager.default.copyItem(at: item, to: url.appendingPathComponent(item.lastPathComponent))
//            }
//            for item in wav {
//                try? FileManager.default.copyItem(at: item, to: url.appendingPathComponent(item.lastPathComponent))
//            }
//            
//            
//            print(cue)
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
