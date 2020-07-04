//
//  TagSearchModal.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/07/04.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

struct TagSearchModalView: View {
    @Environment(\.presentationMode) private var mode
    
    func close() {
        mode.wrappedValue.dismiss()
    }
    
    var body: some View {
        VStack{
            Button(action: self.close) {
                Text("HI!")
            }
        }.frame(width: 400, height: 400)
    }
}
struct TagSearchModal_Previews: PreviewProvider {
    static var previews: some View {
        TagSearchModalView()
    }
}
