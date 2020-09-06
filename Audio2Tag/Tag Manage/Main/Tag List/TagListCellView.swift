//
//  TagFileListCell.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/28.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

struct TagListCellView: View {
    @Binding var item: TagModel
    
    var body: some View {
        Section(header: Text("파일 정보")) {
            NavigationLink(destination: TagFileDetailView(bind: $item)) {
                VStack {
                    HStack {
                        Text("\(item.fileName)")
                        Spacer()
                    }
                    Divider()
                    HStack {
                        Text("\(item.haveID3Tag ? "ID3 태그 정상" : "ID3 태그 오류")")
                        Spacer()
                        Text("\(item.ext)")
                    }
                }
            }
        }
    }
}
