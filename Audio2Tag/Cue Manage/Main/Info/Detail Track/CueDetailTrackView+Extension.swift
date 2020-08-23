//
//  CueDetailTrackView+Extension.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/22.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import Foundation
import SwiftUI

extension CueDetailTrackView {
    
    func makeSheet() -> some View {
        Group {
            VStack {
                Text("키값")
                TextField("", text: self.$key)
                Text("밸류 값")
                TextField("", text: self.$value)
                Button("적용", action: {
                    switch (self.sheetType) {
                    case .Rem:
                        var copy = viewModel.rem
                        copy.append(RemModel(value: (self.key, self.value)))
                        self.changeRem(copy)
                        break
                    default:
                        break
                    }
                    self.openSheet = false
                })
            }
        }
    }
}
