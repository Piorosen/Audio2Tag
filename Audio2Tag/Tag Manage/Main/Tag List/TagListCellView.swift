//
//  TagListCellView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/09/14.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

struct TagListCellView: View {
    let item: TagModel
    
    var body: some View {
        VStack {
            HStack {
                Text("\(item.fileName)")
                Spacer()
            }
            Divider()
            HStack {
                Text("ID3 태그 정상")
                Spacer()
                Text("\(item.ext)")
            }
        }
    }
}
