//
//  TagView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/07/10.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

struct TagView: View {
    @ObservedObject
    var body: some View {
        NavigationView{
            // Image
            LazyVStack {
                
            }
            .navigationTitle("Tag Info")
            .navigationBarItems(trailing: Group {
                Button(action: {
                    print("AA")
                }) {
                    Image(systemName: "plus.app")
                }
            })
        }
    }
}

struct TagView_Previews: PreviewProvider {
    static var previews: some View {
        TagView()
    }
}
