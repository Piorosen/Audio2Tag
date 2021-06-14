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
    
    var editRequest = { (_:TagFileDetailListTextCell) in }
    
    func onEditRequest(_ action: @escaping (TagFileDetailListTextCell) -> Void) -> TagFileDetailListView {
        var copy = self
        copy.editRequest = action
        return copy
    }
    
    init(model: Binding<TagFileDetailListModel>) {
        self._model = model
    }
    
    var body: some View {
        List {
            TagFileDetailListImageCellView(image: $model.image)
                .frame(maxWidth: .infinity, idealHeight: 200, alignment: .center)
            
            Divider().padding(.all, 10)
            
            Section {
                ForEach(model.tag.indices, id: \.self) { idx in
                    TagFileDetailListTextCellView(title: model.tag[idx].title.caseName, text: $model.tag[idx].text)
                        .onRequestEdit { editRequest(model.tag[idx]) }
                }
                .onDelete(perform: { idx in
                    model.tag.remove(atOffsets: idx)
                })
            }
        }
    }
}
