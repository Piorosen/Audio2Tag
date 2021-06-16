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
    @Binding var models: [TagModel]
    
    var body: some View {
        List {
            ForEach (models.indices, id: \.self) { item in
                Group {
                    if models[item].haveID3Tag {
                        NavigationLink(destination: TagFileDetailView(bind: models[item])) {
                            TagListCellView(item: models[item])
                        }
                    }else {
                        TagListCellView(item: models[item])
                    }
                }
//                .frame(maxWidth: .infinity, maxHeight: <#T##CGFloat?#>)
//                .listRowInsets(EdgeInsets(top: -20, leading: -20, bottom: 20, trailing: 20))
            }
            .onMove {
                models.move(fromOffsets: $0, toOffset: $1)
            }
            .onDelete {
                models.remove(atOffsets: $0)
            }
            
//            .listRowBackground(Color(UIColor.systemGroupedBackground))
        }
//        .listSeparatorStyle(.none)
    }
}
