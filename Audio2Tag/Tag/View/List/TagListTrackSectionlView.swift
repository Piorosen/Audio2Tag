//
//  TagListTrackCellView.swift
//  Audio2Tag
//
//  Created by aoikazto on 2021/06/23.
//

import SwiftUI


enum TagListActionSheet : Identifiable {
    var id: Int {
        return 0
    }
    
    case editSection(Int)
}

extension TagListTrackSectionlView {
    func makeActionSheet(_ item: TagListActionSheet) -> ActionSheet {
        switch item {
        case .editSection(let idx):
            return ActionSheet(title: Text("삭제"),
                               message: Text("\(idx + 1)번 트랙을 삭제 하시겠습니까?, 삭제 후 복구는 불가능 합니다."),
                               buttons: [
                                .destructive(Text("Delete"), action: {
                                    DispatchQueue.main.async {
                                        removeSection(idx)
                                    }
                                }),
                                .cancel(Text("Cancel"))
                               ])
        }
    }
}

struct TagListTrackSectionlView: View {
    let index: Int
    
    @State var actionSheet: TagListActionSheet? = nil
    @Binding var models: [TagModel]
    var sectionTap: (Int) -> Void = { _ in }
    var removeSection: (Int) -> Void = { _ in }
    
    func onSectionTap(_ callback: @escaping (Int) -> Void) -> Self {
        var copy = self
        copy.sectionTap = callback
        return copy
    }
    
    func onRemoveSection(_ callback: @escaping (Int) -> Void) -> Self {
        var copy = self
        copy.removeSection = callback
        return copy
    }
    
    var body: some View {
        Section(header: HStack {
            Image(systemName: "plus.app")
            Text("Track : \(index + 1)")
        }
        .onTapGesture { sectionTap(index) }
        .onLongPressGesture { actionSheet = .editSection(index) })
        {
            ForEach (models.indices, id: \.self) { audioIdx in
                TagListCellView(item: $models[audioIdx])
            }
            .onMove {
                models.move(fromOffsets: $0, toOffset: $1)
            }
            .onDelete {
                models.remove(atOffsets: $0)
            }
        }.actionSheet(item: $actionSheet) { makeActionSheet($0) }
    }
}
