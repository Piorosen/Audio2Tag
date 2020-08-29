//
//  ActivityIndicator.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/27.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI
import CoreGraphics

struct ActivityIndicator : UIViewRepresentable {
    
    typealias UIViewType = UIActivityIndicatorView
    let style : UIActivityIndicatorView.Style
    
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> ActivityIndicator.UIViewType {
        return UIActivityIndicatorView(style: style)
    }
    
    func updateUIView(_ uiView: ActivityIndicator.UIViewType, context: UIViewRepresentableContext<ActivityIndicator>) {
        uiView.startAnimating()
    }
    
}

struct ActivityIndicatorView : View {
    @Binding var showIndicator: Bool
    let back:Color = Color.secondary
    let forg:Color = Color.primary
    
    var body: some View {
        if showIndicator {
            VStack {
                Text("LOADING")
                ActivityIndicator(style: .large)
            }
            .frame(width: 200, height: 200)
            .background(back)
            .foregroundColor(forg)
            .cornerRadius(20)
        }else {
            EmptyView().frame(width: 200, height: 200)
        }
    }
}
