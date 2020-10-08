//
//  TagFileDetailCustomAlertView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/09/07.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI
import ID3TagEditor

struct TagFileDetailCustomAlertView: View {
    @Binding var selectableTag: [FrameName]
    private var selectedTag = { (_:FrameName) in }
    
    init(tag: Binding<[FrameName]>) {
        _selectableTag = tag
    }
    
    func onSelectedTag(_ action: @escaping (FrameName) -> Void) -> TagFileDetailCustomAlertView {
        var copy = self
        copy.selectedTag = action
        return copy
    }
    
    var body: some View {
        VStack {
            List (selectableTag , id: \.self) { item in
                Button(item.caseName) {
                    selectedTag(item)
                }
            }.frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height * 0.5)
        }
    }
}
