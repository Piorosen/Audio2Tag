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

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct TagSearchView: View {
    @ObservedObject var viewModel = TagSearchViewModel()
    @State private var searchText = ""
    @State private var showCancelButton: Bool = false
    @State var test = [String]()
    
    private var funcOfKind = { (_:String) in }
    private var name = ""
    
    init(kind: TagSearchKind) {
        if (kind == .musicBrainz) {
            funcOfKind = viewModel.musicBrainz
            name = "MusicBrainz"
        }else if (kind == .vgmDb) {
            funcOfKind = viewModel.vgmDB
            name = "Vgm DB"
        }
    }
    
    
    var body: some View {
        ZStack{
        NavigationView {
            VStack {
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        
                        TextField("search", text: $searchText, onEditingChanged: { isEditing in
                            if isEditing {
                                self.showCancelButton = true
                            }
                        }, onCommit: {
                            self.showCancelButton = false
                            funcOfKind(searchText)
                        }).foregroundColor(.primary)
                        .animation(.easeOut)
                        
                        Button(action: {
                            self.searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
                        }.animation(.easeOut)
                    }
                    .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                    .foregroundColor(.secondary)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10.0)
                }
                .padding(.horizontal)
                .animation(.spring())
                
                List(viewModel.items.indices, id:\.self) { (item:Int) in
                    NavigationLink(destination: TagSearchTrackView(c: $viewModel.items[item]).setKind(kind: .vgmDb)) {
                        Text("\(viewModel.items[item].result.albumTitle)")
                    }
                }
            }.navigationTitle(Text("\(name)"))
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

