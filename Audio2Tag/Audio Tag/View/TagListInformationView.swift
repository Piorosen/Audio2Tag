//
//  TagListInformationView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/07/04.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

struct TagListInformationView: View {
    @Binding var item: TagMainModel
    
    var body: some View {
        VStack {
            TagElementView("File Name", text: self.$item.fileName)
            TagElementView("Title", text: self.$item.title)
            TagElementView("Directory", text: self.$item.directory)
        }.frame(maxWidth: 250, maxHeight: .infinity, alignment: .top)
    }
}
