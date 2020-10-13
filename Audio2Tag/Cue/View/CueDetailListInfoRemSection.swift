//
//  CueDetailListInfoRemSection.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/22.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

struct CueDetailListInfoRemSection: View {
    var rem: [RemModel]
    init(rem: [RemModel]) {
        self.rem = rem
    }
    
    // MARK: - Event
    private var remChanged = { (_:[RemModel]) -> Void in }
    
    
    // MARK: - Handler
    func onRemChanged(_ action: @escaping ([RemModel]) -> Void) -> CueDetailListInfoRemSection {
        var copy = self
        copy.remChanged = action
        return copy
    }
    
    // MARK: - BODY
    var body: some View {
        Section(header: Text("Rem")) {
            ForEach (self.rem) { item in
                HStack {
                    Text("\(item.value.key)")
                    Spacer()
                    Text("\(item.value.value)")
                }
            }
//            Button(action: {
//                // 시트 열고 수정해야함.
//                
//            }) {
//                HStack {
//                    Text("Rem 정보 추가")
//                    Spacer()
//                    Image(systemName: "plus")
//                }
//            }
        }
    }
}
