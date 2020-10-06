//
//  macOS_DocumentPicker.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/11.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

#if targetEnvironment(macCatalyst)
import Foundation
import Cocoa
import SwiftUI
import UniformTypeIdentifiers

final class DocumentPicker3: NSObject, UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        viewController.delegate = self
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {
        
    }
    
    typealias UIViewControllerType = UIDocumentPickerViewController
    lazy var viewController:UIDocumentPickerViewController = {
        // For picked only folder
        let vc = UIDocumentPickerViewController(documentTypes: ["public.folder"], in: .open)
        // For picked every document
        // let vc = UIDocumentPickerViewController(documentTypes: ["public.data"], in: .open)
        // For picked only images
        // let vc = UIDocumentPickerViewController(documentTypes: ["public.image"], in: .open)
        vc.allowsMultipleSelection = false
        // vc.accessibilityElements = [kFolderActionCode]
        // vc.shouldShowFileExtensions = true
        vc.delegate = self
        return vc
    }()

}
extension DocumentPicker3: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print(urls)
    }
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true) {
        }
        print("cancelled")
    }
}


final class DocumentPicker2 : NSObject, UIViewControllerRepresentable, UIDocumentPickerDelegate {
    lazy var picker: UIDocumentPickerViewController = {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: utType)
        picker.allowsMultipleSelection = self.allowMultipleSelection
        picker.delegate = self
        return picker
    }()
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: utType)
        picker.allowsMultipleSelection = self.allowMultipleSelection
        picker.delegate = self
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {
        
    }    
    
    typealias UIViewControllerType = UIDocumentPickerViewController
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("closed")
        controller.dismiss(animated: true) {
        }
        
    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print(urls)
        if urls.count != 0 {
            oneFile(urls[0])
            multiFile(urls)
        }
    }
    
    private var isFolderPicker: Bool = false
    private var allowMultipleSelection = false
    private var utType = [UTType]()
    
    fileprivate var oneFile: ((URL) -> Void) = { _ in }
    fileprivate var multiFile: (([URL]) -> Void) = { _ in }
    
    func onSelectFile(completeHanlder: @escaping (URL) -> Void) -> DocumentPicker2 {
        self.oneFile = completeHanlder
        return self
    }
    
    func onSelectFiles(completeHanlder: @escaping ([URL]) -> Void) -> DocumentPicker2 {
        self.multiFile = completeHanlder
        return self
    }
    
    func setConfig(folderPicker:Bool, allowMultiple: Bool = false) -> DocumentPicker2 {
        if (folderPicker) {
            self.utType = [.folder]
        }else {
            self.utType = [.cue, .audio]
        }
        self.isFolderPicker = folderPicker
        self.allowMultipleSelection = allowMultiple
        return self
    }
    
    func setUTType(type: [UTType]) -> DocumentPicker2 {
        self.utType = type
        return self
    }
}


#endif
