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
        if (kind == .MusicBrainz) {
            funcOfKind = viewModel.musicBrainz
            name = "MusicBrainz"
        }else if (kind == .VgmDB) {
            funcOfKind = viewModel.vgmDB
             name = "Vgm DB"
        }
    }

    
    var body: some View {
        ZStack {
            VStack {
                VStack {
                    HStack {
                        Text("검색 엔진 : \(self.name)").font(.title)
                    }
                    
                    // Search view
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
                    .navigationBarHidden(showCancelButton) // .animation(.default) // animation does not work properly
                    
                }
                .animation(.spring())
                
                NavigationView {
                List(viewModel.items.indices, id:\.self) { (item:Int) in
                    
                    NavigationLink(destination: TagSearchTrackView(c: $viewModel.items[item]).setKind(kind: .VgmDB)) {
                        Text("\(viewModel.items[item].result.albumTitle)")
                    }
                    
                }
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
