//
//  CueDetailListInfoRemSection.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/22.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

struct CueDetailListInfoRemSection: View {
    @State var openAlert = false
    
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
            AddButton("REM 추가") {
                openAlert = true
            }
        }.alert(isPresented: $openAlert) {
            Alert(title: Text("미 구현 입니다."))
        }
    }
}
