//
//  PenguinViewController.swift
//  My Notes
//
//  Created by Mac User on 03.04.18.
//  Copyright © 2018 Annie Alig. All rights reserved.
//

import UIKit
import os.log

class PenguinViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    /*
    This value is either passed by 'PenguinTableViewController' in 'prepare(for:sender)'
     or constructed as part of adding a new penguin
    */
    var penguin: Penguin?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Handle the text field's user input through delegate callbacks.
        titleTextField.delegate = self
        
        //Set up views if editing an existing Penguin.
        if let penguin = penguin {
            navigationItem.title = penguin.name
            titleTextField.text = penguin.name
            photoImageView.image = penguin.photo
            ratingControl.rating = penguin.rating
        }
        
        //Enable the Save button only if text field has a valid Penguin name.
        updateSaveButtonState()
    }
    
    //MARK: UiTextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    func textFieldShouldReturn( _ textField: UITextField) -> Bool {
        //Hide the keybord.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    //MARK: UiImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        //Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddPenguinMode = presentingViewController is UINavigationController
        
        if isPresentingInAddPenguinMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else{
            fatalError("The PenguinViewController is not inside a navigation controller")
        }
        
    }
    
    //This metod lets you configure a vew controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        //Configure the destination view conroller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else{
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = titleTextField.text ?? ""
        let photo = photoImageView.image
        let rating = ratingControl.rating
        
        //Set the penguin to bo passed to PenguinTableViewController after unwind segue.
        penguin = Penguin(name: name, photo: photo, rating: rating)
    }
    
    //MARK: Actions
    @IBAction func SelectImage(_ sender: UITapGestureRecognizer) {
        
        //Hide the keyboard
        titleTextField.resignFirstResponder()
        
        //Chose photo only from photo library
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
   //MARK: Private Methods
    private func updateSaveButtonState() {
        //Disable the Save button if the text field is empty.
        let text = titleTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
}