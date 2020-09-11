//
//  MusicBrainz.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/25.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI
import SwiftVgmdb

enum TagSearchKind {
    case vgmDb
    case musicBrainz
}


struct TagSearchView: View {
    @ObservedObject var viewModel = TagSearchViewModel()
    
    private var selectTag = { (_:VDAlbum, _:[[TagSearchTrackModel]]) in }
    private var funcOfKind = { (_:String) in }
    private var kind: TagSearchKind
    private var name = ""
    
    func onSelectTag(_ action: @escaping (VDAlbum, [[TagSearchTrackModel]]) -> Void) -> TagSearchView {
        var copy = self
        copy.selectTag = action
        return copy
    }
    
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
                        NavigationLink(destination: TagSearchTrackView(bind: viewModel.items[item], kind: self.kind)
                                        .onSelectTag({ items in selectTag(viewModel.items[item].result, items) })) {
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

