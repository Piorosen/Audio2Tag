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
    
    init(c: Binding<TagSearch>) {
        self._checked = c
        print("\(checked.result.id)")
    }
    
    private var funcOfKind = { (_:String) in }
    private var name = ""
    
    func setKind(kind: TagSearchKind) -> TagSearchTrackView {
        var copy = self
        if (kind == .MusicBrainz) {
            copy.funcOfKind = viewModel.musicBrainz
            copy.name = "MusicBrainz"
        }else if (kind == .VgmDB) {
            copy.funcOfKind = viewModel.vgmDb
            copy.name = "Vgm DB"
        }
        return copy
    }
    
    var body: some View {
        ZStack {
            VStack {
                List(viewModel.items, id: \.self) { item in
                        Text("\(item)")
                }
            }
            if viewModel.showIndicator {
                VStack {
                    Text("LOADING")
                    ActivityIndicator(style: .large)
                }
                .frame(width: 200, height: 200.0)
                .background(Color.secondary.colorInvert())
                .foregroundColor(Color.primary)
                .cornerRadius(20)
            }
        }
    }
}

