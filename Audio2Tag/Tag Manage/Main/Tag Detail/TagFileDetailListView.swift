//
//  TagFileDetailListView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/28.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI
import ID3TagEditor

struct TagFileDetailListView: View {
    @ObservedObject var viewModel = TagFileDetailListViewModel()
    
    
    var body: some View {
        LazyVStack {
            Group {
                Image(uiImage: viewModel.image)
                    
            }
            Divider()
            
            
        }
    }
}
