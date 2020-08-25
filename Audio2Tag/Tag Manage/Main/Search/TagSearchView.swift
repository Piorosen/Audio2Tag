//
//  MusicBrainz.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/25.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

enum TagSearchKind {
    case VgmDB
    case MusicBrainz
}

struct TagSearchView: View {
    @ObservedObject var viewModel = TagSearchViewModel()
    private var funcOfKind = { }
    
    func setKind(kind: TagSearchKind) -> TagSearchView {
        var copy = self
        if (kind == .MusicBrainz) {
            copy.funcOfKind = viewModel.musicBrainz
        }else if (kind == .VgmDB) {
            copy.funcOfKind = viewModel.vgmDB
        }
        return copy
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

