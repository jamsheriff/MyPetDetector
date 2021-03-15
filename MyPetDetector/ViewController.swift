//
//  ViewController.swift
//  MyPetDetector
//
//  Created by Sherif Musa on 03.02.2020.
//  Copyright © 2020 Sherif Musa. All rights reserved.
//

import UIKit
import CoreML
import Vision
import Social

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    var classificationResults : [VNClassificationObservation] = []
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
    }
    
    func detect(image: CIImage) {
        
        // Load the ML model through its generated class
        guard let model = try? VNCoreMLModel(for: MyPetImageClassifier().model) else {
            fatalError("can't load ML model")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
                  guard let result = request.results?.first as? VNClassificationObservation else {
                      fatalError("Could not complete classfication")
                  }
            
                  self.navigationItem.title = result.identifier.capitalized
                  
//                  self.beginRequest(with:  request)(name: result.identifier)
                  
              }
              
              let handler = VNImageRequestHandler(ciImage: image)
              
              do {
                  try handler.perform([request])
              }
              catch {
                  print(error)
              }
              
              
          }
        
     
            
 
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            
            imageView.image = image
            imagePicker.dismiss(animated: true, completion: nil)
            guard let ciImage = CIImage(image: image) else {
                fatalError("couldn't convert uiimage to CIImage")
            }
            detect(image: ciImage)
        }
    }
    
    
    @IBAction func cameraTapped(_ sender: Any) {
        
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
  
    @IBAction func exitButton(_ sender: UIBarButtonItem) {
        
    }
    
    
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}



