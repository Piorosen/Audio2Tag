//
//  TagFileDetailListView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/09/01.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

struct TagFileDetailListView: View {
    @Binding var model: TagFileDetailListModel
    
    var body: some View {
        List {
            TagFileDetailListImageCellView(image: $model.image)
                .frame(maxWidth: .infinity, idealHeight: 200, alignment: .center)
            
            Divider().padding(.all, 10)
            
            Section {
                ForEach(model.tag.indices, id: \.self) { idx in
                    TagFileDetailListTextCellView(title: model.tag[idx].title, text: $model.tag[idx].text)
                }
                .onDelete(perform: { idx in
                    model.tag.remove(atOffsets: idx)
                })
            }
        }
    }
}
