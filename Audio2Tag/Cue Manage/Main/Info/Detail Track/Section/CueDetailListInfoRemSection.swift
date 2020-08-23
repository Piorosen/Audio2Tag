//
//  CueDetailListInfoRemSection.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/22.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

struct CueDetailListInfoRemSection: View {
    let rem: [RemModel]
    
    var body: some View {
        Section(header: Text("Rem")) {
            ForEach (self.rem) { item in
                HStack {
                    Text("\(item.value.key)")
                    Spacer()
                    Text("\(item.value.value)")
                }
            }
            Button(action: {
//                sheetType = .Rem
//                openSheet = true
            }) {
                HStack {
                    Text("Rem 정보 추가")
                    Spacer()
                    Image(systemName: "plus")
                }
            }
        }
    }
}
