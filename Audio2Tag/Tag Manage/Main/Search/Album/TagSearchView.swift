//
//  MusicBrainz.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/25.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

enum TagSearchKind {
    case vgmDb
    case musicBrainz
}


struct TagSearchView: View {
    @ObservedObject var viewModel = TagSearchViewModel()
    
    private var funcOfKind = { (_:String) in }
    private var kind: TagSearchKind
    private var name = ""
    
    
    init(kind: TagSearchKind) {
        self.kind = kind
        if (kind == .musicBrainz) {
            funcOfKind = viewModel.musicBrainz
            name = "MusicBrainz"
        }else if (kind == .vgmDb) {
            funcOfKind = viewModel.vgmDB
            name = "Vgm DB"
        }
    }
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    // Search view
                    SearchView()
                        .onCommit { text in
                            self.funcOfKind(text)
                        }
                    Divider()
                    List(viewModel.items.indices, id:\.self) { item in
                        NavigationLink(destination: TagSearchTrackView(bind: $viewModel.items[item], kind: self.kind)) {
                            Text("\(viewModel.items[item].result.albumTitle)")
                        }
                    }
                    .navigationBarTitle(Text("Search"))
                    .resignKeyboardOnDragGesture()
                }
            }
            
            ActivityIndicatorView(showIndicator: $viewModel.showIndicator)
        }
    }
}

