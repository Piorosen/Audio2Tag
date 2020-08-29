//
//  MusicBrainz.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/25.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI
import SwiftVgmdb

struct TagSearchTrackView: View {
    @ObservedObject var viewModel = TagSearchTrackViewModel()
    @Binding var checked:TagSearch
    
    private var funcOfKind = { (_:String) in }
    private var name = ""
    
    init(bind: Binding<TagSearch>, kind: TagSearchKind) {
        self._checked = bind
        if (kind == .musicBrainz) {
            funcOfKind = viewModel.musicBrainz
            name = "MusicBrainz"
        }else if (kind == .vgmDb) {
            funcOfKind = viewModel.vgmDb
             name = "Vgm DB"
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                List {
                    // Section
                    ForEach (viewModel.items.indices, id: \.self) { sec in
                        Section(header: Text("\(sec + 1)번 트랙")) {
                            ForEach(viewModel.items[sec], id: \.self) { (item:String) in
                                Text("\(item)")
                            }
                        }
                    }
                }
            }.navigationTitle(Text("\(name) : Track"))
            .navigationBarItems(trailing:
                                    Button("Select", action: {
                                        
                                    }))
            
            
            ActivityIndicatorView(showIndicator: $viewModel.showIndicator)
        }.onAppear {
            if viewModel.items.count == 0 {
                self.funcOfKind(String(self.checked.result.id))
            }
            
        }
    }
}

