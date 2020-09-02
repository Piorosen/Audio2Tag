//
//  TagFileDetailListSheetView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/30.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

struct TagFileDetailListSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var title: String
    @State var text: String = ""
    
    var body: some View {
        VStack {
            Text("Tag 제목")
            Text("\(title)")
            Text("내용")
            TextField("", text: $text, onEditingChanged: { _ in }, onCommit: {
                presentationMode.wrappedValue.dismiss()
            })
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}
