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
    
    func update(_ urls:[URL]) {
//        cue.update(urls: urls)
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
        }.onAppear(perform: {
            
//            let paste = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask)[0]
//            var fileList =             Bundle.main.urls(forResourcesWithExtension: "wav", subdirectory: nil)
//            fileList!.append(contentsOf: Bundle.main.urls(forResourcesWithExtension: "cue", subdirectory: nil)!)
            
//            for item in fileList! {
//                _ = try? FileManager.default.copyItem(at: item, to: paste.appendingPathComponent(item.lastPathComponent))
//            }
            
            

        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
