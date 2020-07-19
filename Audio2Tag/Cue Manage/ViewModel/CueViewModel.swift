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
    
    
    func testMakeItem() -> Void {
        let t1 = Bundle.main.path(forResource: "1.txt", ofType: nil)!
        let t2 = Bundle.main.path(forResource: "2.txt", ofType: nil)!
        
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let a1 = try? String(contentsOfFile: t1)
        let a2 = try? String(contentsOfFile: t2)
        
        try? a1?.write(to: url.appendingPathComponent("1.cue"), atomically: true, encoding: .utf8)
        try? a2?.write(to: url.appendingPathComponent("2.cue"), atomically: true, encoding: .utf8)
        
        
//        print(item1.count)
        
    }
}
