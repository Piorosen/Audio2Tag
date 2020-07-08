//
//  SearchTrackView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/07/08.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

struct TagSearchTrackModalView: View {
    @Environment(\.presentationMode) private var mode
    
    
    func close() {
        mode.wrappedValue.dismiss()
    }
    
    
    var body: some View {
        VStack{
            EmptyView()
            

        }.frame(width: 400, height: 400)
    }
}

struct TagSearchTrackModal_Previews: PreviewProvider {
    static var previews: some View {
        TagSearchTrackModalView()
    }
}
