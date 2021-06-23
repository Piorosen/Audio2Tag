//
//  TagListCellView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/09/14.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

struct TagListCellView: View {
    @Binding var item: TagModel
    
    func element() -> some View {
        return VStack {
            HStack {
                Text("파일 정보")
                Spacer()
            }
            HStack {
                Text("\(item.fileName)")
                Spacer()
            }
            Divider()
            HStack {
                Text(item.haveID3Tag ? "ID3 태그 정상" : "ID3 태그 이상")
                Spacer()
                Text("\(item.ext)")
                
            }
        }
        .background(Color(UIColor.tertiarySystemBackground))
    }
    
    var body: some View {
        Group {
            if item.haveID3Tag {
                NavigationLink(destination: TagFileDetailView(bind: item)) {
                    element()
                }
            }else {
                element()
            }
        }
    }
}
