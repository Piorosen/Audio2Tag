//
//  TagFileList.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/28.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

struct TagListView: View {
    @Binding var models: [TagModel]
    
    var body: some View {
        List {
            ForEach(models.indices, id: \.self) { item in
                Section(header: Text("파일 정보")) {
                    if models[item].haveID3Tag {
                        NavigationLink(destination: TagFileDetailView(bind: models[item])) {
                            TagListCellView(item: models[item])
                        }
                    }else {
                        TagListCellView(item: models[item])
                    }
                }
            }
        }
    }
}
