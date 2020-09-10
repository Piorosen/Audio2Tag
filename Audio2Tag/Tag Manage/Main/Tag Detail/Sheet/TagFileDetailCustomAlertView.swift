//
//  TagFileDetailCustomAlertView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/09/07.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

struct TagFileDetailCustomAlertView: View {
    @Binding var selectableTag: [String]
    private var selectedTag = { (_:String) in }
    
    init(tag: Binding<[String]>) {
        _selectableTag = tag
    }
    
    func onSelectedTag(_ action: @escaping (String) -> Void) -> TagFileDetailCustomAlertView {
        var copy = self
        copy.selectedTag = action
        return copy
    }
    
    var body: some View {
        VStack {
            List (selectableTag , id: \.self) { item in
                Button(item) {
                    selectedTag(item)
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
