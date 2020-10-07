//
//  ImagePicker.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/10/07.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI



struct ImagePicker : UIViewControllerRepresentable {
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let image = info[.originalImage] as? UIImage else {
                return
            }
            
            parent.selectImage(image)
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    @Environment(\.presentationMode) var presentationMode
    
    fileprivate var selectImage:(UIImage) -> Void = { _ in }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    
    func onSelectFile(_ action: @escaping (UIImage) -> Void) -> ImagePicker {
        var copy = self
        copy.selectImage = action
        return copy
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
}
