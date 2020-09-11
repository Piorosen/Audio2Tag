//
//  TagFileList.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/28.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

struct TagListView: View {
    @Binding var models: [TagModel]
    
    var body: some View {
        List {
            ForEach(models.indices, id: \.self) { item in
                Section(header: Text("파일 정보")) {
                    NavigationLink(destination: TagFileDetailView(bind: models[item])) {
                        VStack {
                            HStack {
                                Text("\(models[item].fileName)")
                                Spacer()
                            }
                            Divider()
                            HStack {
                                Text("\(models[item].haveID3Tag ? "ID3 태그 정상" : "ID3 태그 오류")")
                                Spacer()
                                Text("\(models[item].ext)")
                            }
                        }
                    }
                }
            }
        }
    }
}
