//
//  CueEditViewModel.swift
//  Audio2Tag
//
//  Created by Mac13 on 2020/12/02.
//

import Foundation
import SwiftUI
import SwiftCueSheet

protocol ChangeEvent {
    func request(_ action: @escaping (CueEditViewModel.Event) -> Void) -> Self
    func meta()
    func rem()
    func track()
}


class CueEditViewModel : ObservableObject {
    var edit: Edit
    var remove: Remove
    var add: Add
    
    @Published var rem = [CueSheetRem]()
    @Published var meta = [CueSheetRem]()
    @Published var track = [CueSheetRem]()
    
    
    public init() {
        edit = Edit().request({ e in })
        remove = Remove().request({ e in })
        add = Add().request({ e in })
    }
    
    enum Event {
        case meta
        case rem
        case track
    }
    
    struct Edit : ChangeEvent {
        private var request: (Event) -> Void = { _ in }
        func request(_ action: @escaping (Event) -> Void) -> Edit {
            var copy = self
            copy.request = action
            return copy
        }
        
        func meta() {
            request(.meta)
        }
        func rem() {
            request(.rem)
        }
        func track() {
            request(.track)
        }
    }
    struct Remove : ChangeEvent {
        private var request: (Event) -> Void = { _ in }
        func request(_ action: @escaping (Event) -> Void) -> Remove {
            var copy = self
            copy.request = action
            return copy
        }
        
        func meta() {
            request(.meta)
        }
        func rem() {
            request(.rem)
        }
        func track() {
            request(.track)
        }
    }
    struct Add : ChangeEvent {
        private var request: (Event) -> Void = { _ in }
        func request(_ action: @escaping (Event) -> Void) -> Add {
            var copy = self
            copy.request = action
            return copy
        }
        
        func meta() {
            request(.meta)
        }
        func rem() {
            request(.rem)
        }
        func track() {
            request(.track)
        }
    }
    
}
