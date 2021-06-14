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
        GroupBox(label: Text("파일 정보").foregroundColor(.black)) {
            HStack {
                Text("\(item.fileName)")
                    .foregroundColor(.black)
                Spacer()
            }
            Divider()
            HStack {
                Text(item.haveID3Tag ? "ID3 태그 정상" : "ID3 태그 이상")
                    .foregroundColor(.black)
                Spacer()
                Text("\(item.ext)")
                    .foregroundColor(.black)
            }
        }.padding(.top)
        .padding(.leading)
        .padding(.trailing)
    }
}
