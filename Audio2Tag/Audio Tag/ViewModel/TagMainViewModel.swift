//
//  TagMainViewModel.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/06/22.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import Foundation
import SwiftUI
import ID3TagEditor
import SwiftVgmdb
import SwiftMusicBrainz

extension TagMainModel {
    static func make(index:Int, url:URL) -> TagMainModel? {
        let id3TagEditor = ID3TagEditor()
        var title:String = String()
        
        if let tag = try? id3TagEditor.read(from: url.path) {
            title = (tag.frames[.Title] as? ID3FrameWithStringContent)?.content ?? ""
        }
        return TagMainModel.init(index: index, title: title, directory: url.path, fileName: url.lastPathComponent)
    }
}

class TagMainViewModel : ObservableObject {
    @Published var item = [TagMainModel]()
    
    @Published var artist       = String()
    @Published var album        = String()
    @Published var year         = String()
    @Published var track        = String()
    @Published var genre        = String()
    @Published var comment      = String()
    @Published var directory    = String()
    @Published var albumArtist  = String()
    @Published var composer     = String()
    @Published var discNum      = String()
    
    @Published var images = [CGImage]()
    
    func openFile() {
        let panel = NSOpenPanel()
        
        panel.allowsMultipleSelection = true
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        
        panel.begin { res in
            let items = panel.urls
            
            for item in items {
                guard let data = TagMainModel.make(index: self.item.count + 1, url: item) else {
                    continue
                }
                self.item.append(data)
            }
        }
    }
    
    func runTagging() {
        
    }
    
    func downloadFreeDB() {
        
    }
    
    func downloadVgmDB() {
        
        
        
    }
    
    func make() {
        item.append(TagMainModel(index: item.count, title: UUID().uuidString, directory: "dir", fileName: "item\(item.count)"))
    }
}
