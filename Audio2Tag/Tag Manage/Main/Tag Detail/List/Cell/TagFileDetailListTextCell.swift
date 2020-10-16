//
//  TagFileDetailListTextCell.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/09/06.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

struct TagFileDetailListTextCellView: View {
    var title: String
    @Binding var text: String
    private var requestEdit = { }
    
    init(title: String, text: Binding<String>) {
        self.title = title
        self._text = text
    }
    
    func onRequestEdit(_ action: @escaping () -> Void) -> TagFileDetailListTextCellView {
        var copy = self
        copy.requestEdit = action
        return copy
    }
    
    var body: some View {
        Button(action: {
            requestEdit()
        }) {
            HStack {
                Text(self.title)
                Spacer()
                Text(self.text)
            }
        }
    }
}
