//
//  TagElementView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/07/04.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

struct TagElementView: View {
    init(_ name: String, text: Binding<String>) {
        self.name = name
        self._text = text
    }
    
    let name:String
    @Binding var text: String
    var body: some View {
        VStack (alignment: .leading){
            Text(name)
            TextField(name, text: self.$text)
        }.padding(5)
//        .background(color)
    }
}
//
struct TagElementView_Previews: PreviewProvider {
    @State static var test = ""
    static var previews: some View {
        TagElementView("test", text: $test)
    }
}
