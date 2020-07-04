//
//  TagListInformationView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/07/04.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

struct TagListInformationView: View {
    var item: TagMainModel
    
    
    var body: some View {
            Text("\(item.id)")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
