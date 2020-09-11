//
//  DocumentBrowserView.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/07/12.
//  Copyright © 2020 Aoikazto. All rights reserved.
//


#if !targetEnvironment(macCatalyst)
import UIKit
import SwiftUI
import MobileCoreServices
import UniformTypeIdentifiers

class DocumentPickerCoordinator : NSObject, UIDocumentPickerDelegate {
    var parent: DocumentPicker
    
    init(_ parent:DocumentPicker){
        self.parent = parent
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if urls.count != 0 {
            parent.oneFile(urls[0])
            parent.multiFile(urls)
        }
    }
}

extension UTType {
    /**
            cue Sheet파일의 UTI 입니다.
     */
    static let cue = UTType(exportedAs: "com.aoikazto.Auido2Tag.cue")
}

// 기본으로 파일을 선택을 하도록 되어 있습니다.
struct DocumentPicker : UIViewControllerRepresentable {
    private var isFolderPicker: Bool = false
    private var allowMultipleSelection = false
    private var utType:[UTType] = [.cue, .audio]
    
    fileprivate var oneFile: ((URL) -> Void) = { _ in }
    fileprivate var multiFile: (([URL]) -> Void) = { _ in }
    
    
    func onSelectFile(completeHanlder: @escaping (URL) -> Void) -> DocumentPicker {
        var copy = self
        copy.oneFile = completeHanlder
        return copy
    }
    
    func onSelectFiles(completeHanlder: @escaping ([URL]) -> Void) -> DocumentPicker {
        var copy = self
        copy.multiFile = completeHanlder
        return copy
    }
    
    func setConfig(folderPicker:Bool, allowMultiple: Bool = false) -> DocumentPicker {
        var copy = self
        if (folderPicker) {
            copy.utType.removeAll()
            copy.utType.append(.folder)
        }
        copy.isFolderPicker = folderPicker
        copy.allowMultipleSelection = allowMultiple
        return copy
    }
    
    func setUTType(type: [UTType]) -> DocumentPicker {
        var copy = self
        copy.utType = type
        return copy
    }
    
    func makeCoordinator() -> DocumentPickerCoordinator {
        return DocumentPickerCoordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPicker>) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: utType)

        picker.allowsMultipleSelection = self.allowMultipleSelection
        picker.delegate = context.coordinator
        return picker
    }
        
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext<DocumentPicker>) {
        
    }
    
}
#endif
