//
//  TagFileDetailEditCustomAlertView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/09/10.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

class TagFileDetailEditCustomAlertViewModel : ObservableObject {
    //    @Published var
}

struct TagFileDetailEditCustomAlertView: View {
    private let hint: String
    private let title: String
    @Binding var text: String
    
    init(title:String, hint:String, text:Binding<String>) {
        self.title = title
        self.hint = hint
        self._text = text
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(self.title)
            TextField(hint, text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }.padding()
    }
}

