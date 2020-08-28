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
                List(viewModel.items, id: \.self) { item in
                    Text("\(item)")
                }
            }.navigationTitle(Text("\(name) : Track"))
            .navigationBarItems(trailing:
                                    Button("Select", action: {
                                        
                                    }))
            if viewModel.showIndicator {
                VStack {
                    Text("LOADING")
                    ActivityIndicator(style: .large)
                }
                .frame(width: 200, height: 200)
                .background(Color.secondary.colorInvert())
                .foregroundColor(Color.primary)
                .cornerRadius(20)
            }
        }.onAppear {
            self.funcOfKind(String(self.checked.result.id))
        }
    }
}

