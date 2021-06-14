//
//  TagFileDetailEditCustomAlertView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/09/10.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI
import ID3TagEditor

class TagFileDetailEditCustomAlertViewModel : ObservableObject {
    //    @Published var
}

struct TagFileDetailEditCustomAlertView: View {
    private let hint: String
    private let title: FrameName
    @Binding var text: String
    
    init(title:FrameName, hint:String, text:Binding<String>) {
        self.title = title
        self.hint = hint
        self._text = text
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(self.title.caseName)
            TextField(hint, text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }.padding()
    }
}

