//
//  CueInfoNavigationBarTrailling.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/16.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

struct CueInfoNavigationBarTrailling: View {
    private var folderBadgePlusAction = { }
    private var trashAction = { }
    
    func onFolderBadgePlusAction(_ action: @escaping () -> Void) -> CueInfoNavigationBarTrailling {
        var copy = self
        copy.folderBadgePlusAction = action
        return copy
    }
    
    func onTrashAction(_ action : @escaping () -> Void) -> CueInfoNavigationBarTrailling {
        var copy = self
        copy.trashAction = action
        return copy
    }
    
    var body: some View {
        HStack {
            Button(action: self.folderBadgePlusAction) {
                Image(systemName: "folder.badge.plus").padding(10)
            }
            Button(action: self.trashAction){
                Image(systemName: "trash").padding(10)
            }
        }
    }
}
