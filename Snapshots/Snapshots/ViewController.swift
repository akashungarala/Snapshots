//
//  ViewController.swift
//  Snapshots
//
//  Created by Akash Ungarala on 6/18/17.
//  Copyright © 2017 Akash Ungarala. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
import KeychainAccess

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    var pickedVideo: URL!

    @IBOutlet weak var snapshotsCaptured: UILabel!
    
    @IBAction func openCamera(_ sender: UIButton) {
        snapshotsCaptured.isHidden = true
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            if UIImagePickerController.availableCaptureModes(for: .front) != nil {
                imagePicker.sourceType = .camera
                imagePicker.showsCameraControls = false
                imagePicker.cameraDevice = .front
                imagePicker.mediaTypes = [kUTTypeMovie as String]
                imagePicker.allowsEditing = false
                imagePicker.delegate = self
                present(imagePicker, animated: true, completion: {
                    self.imagePicker.startVideoCapture()
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(6), execute: {
                        self.imagePicker.stopVideoCapture()
                        self.snapshotsCaptured.isHidden = false
                    })
                })
            } else {
                alert("Application cannot access the camera.", title: "Front camera doesn't exist")
            }
        } else {
            alert("Application cannot access the camera.", title: "Camera inaccessable")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        snapshotsCaptured.isHidden = true
    }
    
    // Finished recording a video
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let url = (info[UIImagePickerControllerMediaURL] as? URL) {
            pickedVideo = url
            var snapshots: [UIImage]! = []
            let asset = AVAsset(url: pickedVideo)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            for timeValue in stride(from: 0.5, through: 5, by: 0.5) {
                do {
                    let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(Int64(timeValue), 1), actualTime: nil)
                    snapshots.append(UIImage(cgImage: cgImage))
                } catch let error {
                    print("Error generating thumbnail: \(error.localizedDescription)")
                }
            }
            saveSnapshots(snapshots: snapshots)
        }
        imagePicker.dismiss(animated: true, completion: {
            // Anything you want to happen when the user saves an video
        })
    }
    
    // Called when the user selects cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: {})
    }
    
    // Handles presenting alert to the user with given message and title
    func alert(_ message: String, title: String = "") {
        // Create an alert controller
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // Create an alert action
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        // Add the alert action to the alert controller
        alertController.addAction(OKAction)
        // Present the alert controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Save Snapshots locally
    func saveSnapshots(snapshots: [UIImage]) {
        var i: Int = 0
        for snapshot in snapshots {
            let fileName = "snapshot\(i).png"
            i += 1
            let imageData = UIImagePNGRepresentation(snapshot)
            let keychain = Keychain()
            keychain[data: "snapshot\(i)"] = imageData
            let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
            let documentsDirectory: URL = URL(fileURLWithPath: paths[0])
            let dataPath = documentsDirectory.appendingPathComponent(fileName)
            try! imageData?.write(to: dataPath, options: [])
        }
    }

}
