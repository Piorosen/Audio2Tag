//
//  TagFileDetailListTextCell.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/09/06.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

struct TagFileDetailListTextCellView: View {
    var title: String
    @Binding var text: String
    
    var body: some View {
        NavigationLink(destination: EmptyView()) {
            HStack {
                Text(self.title)
                Spacer()
                Text(self.text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }
    }
}
