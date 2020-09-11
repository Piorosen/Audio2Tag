//
//  TagFileDetailEditCustomAlertView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/09/10.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

struct TagFileDetailEditCustomAlertView: View {
    private var commit = { (_:String) in }
    
    func onCommit(_ action: @escaping (String) -> Void) -> TagFileDetailEditCustomAlertView {
        var copy = self
        copy.commit = action
        return copy
    }
    private let hint: String
    private let title: String
    @State var text: String = "" 
    
    init(title:String, text:String) {
        self.title = title
        self.hint = text
        self.text = ""
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(self.title)
            TextField(hint, text: $text, onEditingChanged: { _ in }, onCommit: { commit(text) })
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }.padding()
    }
}

