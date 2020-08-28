//
//  ActivityIndicator.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/27.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI

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
