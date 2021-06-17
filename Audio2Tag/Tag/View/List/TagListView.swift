//
//  TagFileList.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/28.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI
import SwiftUIListSeparator

struct TagListView: View {
    @Binding var models: [[TagModel]]
    
    var body: some View {
        List {
            ForEach (models.indices, id: \.self) { trackIdx in
                Section(header: Text("Track : \(trackIdx)")) {
                    ForEach (models[trackIdx].indices, id: \.self) { audioIdx in
                        Group {
                            if models[trackIdx][audioIdx].haveID3Tag {
                                NavigationLink(destination: TagFileDetailView(bind: models[trackIdx][audioIdx])) {
                                    TagListCellView(item: models[trackIdx][audioIdx])
                                }
                            }else {
                                TagListCellView(item: models[trackIdx][audioIdx])
                            }
                        }
                    }
                    .onMove {
                        models[trackIdx].move(fromOffsets: $0, toOffset: $1)
                    }
                    .onDelete {
                        models[trackIdx].remove(atOffsets: $0)
                    }
                }
            }
            
            
//            .listRowBackground(Color(UIColor.systemGroupedBackground))
        }
//        .listSeparatorStyle(.none)
    }
}
