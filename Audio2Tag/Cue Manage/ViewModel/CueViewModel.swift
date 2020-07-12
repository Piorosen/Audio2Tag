//
//  CueViewModel.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/07/12.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

class CueViewModel : ObservableObject {
    
    @Published var isDocumentShow = false
    
    func addItem() -> Void {
        isDocumentShow = true
    }
    func showDocument() -> some View {
        return DocumentPicker()
    }
    
}
