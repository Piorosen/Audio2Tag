//
//  TagFileDetailListViewModel.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/29.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI
import ID3TagEditor

class TagFileDetailListViewModel : ObservableObject {
    @Published var image = UIImage()
    
    init() {
        let p = Bundle.main.urls(forResourcesWithExtension: "mp3", subdirectory: nil)
        

        do {
            var data = try? Data(contentsOf: p![0])
            let tag = try ID3TagEditor().read(mp3: data!)
            print(tag)
        }catch {
            print(error)
        }
    }

    
}
