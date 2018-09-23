//
//  MemeSceneViewController.swift
//  MemeMeV1
//
//  Created by cedro_nds on 21/07/18.
//  Copyright © 2018 Lorrayne Paraiso. All rights reserved.
//

import UIKit

class MemeSceneViewController: UIViewController {
    
    // MARK: Outlet
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    // MARK: Constraints
    
    @IBOutlet weak var shareConstraint: NSLayoutConstraint!
    @IBOutlet weak var topViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var cameraConstraint: NSLayoutConstraint!
    @IBOutlet weak var photoConstraint: NSLayoutConstraint!
    @IBOutlet weak var editConstraint: NSLayoutConstraint!
    
    // MARK: Properties
    var primaryShareConstraint: CGFloat!
    var primaryTopViewConstraint: CGFloat!
    var primaryCameraConstraint: CGFloat!
    var primaryPhotoConstraint: CGFloat!
    var primaryEditConstraint: CGFloat!
    var red:CGFloat = 0.0
    var blue:CGFloat = 0.0
    var green:CGFloat = 0.0
    
    
    var menuIsActive: Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveConstraints()
        subscribeToKeyboardNotifications()
        closedMenuConstraintsUpdate()
        topView.isHidden = true
        configureTextField(textField: topTextField, text: "TOP TEXT HERE")
        configureTextField(textField: bottomTextField, text: "BOTTOM TEXT HERE")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if menuIsActive {
            menuAnimation(activeMenu: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: Business Logic
    
    func generateMemedImage() -> UIImage {
        alphaButtons(alpha: 0)
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        alphaButtons(alpha: 1)
        return memedImage
    }
    
    func changeColorButton(color: UIColor) {
        shareButton.imageView?.image? = (shareButton.imageView?.image?.makeTintable())!
        shareButton.imageView?.tintTo(color: color)
        
        photoButton.imageView?.image? = (photoButton.imageView?.image?.makeTintable())!
        photoButton.imageView?.tintTo(color: color)
        
        cameraButton.imageView?.image? = (cameraButton.imageView?.image?.makeTintable())!
        cameraButton.imageView?.tintTo(color: color)
        
        menuButton.imageView?.image? = (menuButton.imageView?.image?.makeTintable())!
        menuButton.imageView?.tintTo(color: color)
        
        cancelButton.imageView?.image? = (cancelButton.imageView?.image?.makeTintable())!
        cancelButton.imageView?.tintTo(color: color)
        
        editButton.imageView?.image? = (editButton.imageView?.image?.makeTintable())!
        editButton.imageView?.tintTo(color: color)
    }
    
    // MARK: Actions
    
    @IBAction func menuAction(_ sender: Any) {
        menuAnimation(activeMenu: menuIsActive)
    }
    
    @IBAction func tapToDismisskeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func editAction(_ sender: Any) {
        // I will implement this function in the next version of this code
        let alert = UIAlertController(title: "For now, this is not working.", message: "This functionality will be available on the next version.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        topTextField.text = "TOP TEXT HERE"
        bottomTextField.text = "BOTTOM TEXT HERE"
        imageView.image = nil
        changeColorButton(color: .white)
    }
    
    @IBAction func shareAction(_ sender: Any) {
        
        let activityViewController = UIActivityViewController(activityItems: [generateMemedImage()], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        self.present(activityViewController, animated: true, completion: nil)
        activityViewController.completionWithItemsHandler = { (activityType, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if completed {
                let _ = MemeScene.Meme(topText: self.topTextField.text!, bottomText: self.bottomTextField.text!, originalImage: self.imageView.image!, memedImage: self.generateMemedImage())
            }
        }
    }
    
    @IBAction func cameraAction(_ sender: Any) {
        openPicker(sourceType: .camera)
    }
    
    @IBAction func photoAction(_ sender: Any) {
        openPicker(sourceType: .photoLibrary)
    }
    
    // MARK: UIImagePickerController Method
    func openPicker(sourceType: UIImagePickerControllerSourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = sourceType
        present(pickerController, animated: true, completion: nil)
    }
}


// MARK: - TextField

extension MemeSceneViewController: UITextFieldDelegate  {
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = 0 - getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true;
    }
    
    func textFieldDidBeginEditing (_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.count == 0 {
            textField.text = textField.tag == 1 ? "BOTTOM TEXT HERE" : "TOP TEXT HERE"
        }
    }
    
    private func configureTextField(textField: UITextField, text: String) {
        let memeTextAttributes:[String:Any] = [
            NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
            NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
            NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedStringKey.strokeWidth.rawValue: -4.5]
        
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.text = text
    }
    
}


// MARK: - ImagePicker
extension MemeSceneViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            if (imageView.image?.isDark)! {
                changeColorButton(color: .gray)
            }
            dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}



// MARK: - Animated Menu

extension MemeSceneViewController {
    
    func menuAnimation(activeMenu: Bool) {
        
        enableButtons(isEnabled:false)
        
        if activeMenu {
            
            topView.isHidden = false
            cancelButton.isHidden = false
            
            closedMenuConstraintsUpdate()
            
            
            self.view.layoutIfNeeded()
            
            
            topViewConstraint.constant = primaryTopViewConstraint
            
            
            UIView.animate(withDuration: 0.35, animations: {
                self.view.layoutIfNeeded()
            }) { _ in
                
                self.cameraButton.isHidden = false
                self.editButton.isHidden = false
                
                self.view.layoutIfNeeded()
                
                self.cameraConstraint.constant = self.primaryCameraConstraint
                self.editConstraint.constant = self.primaryEditConstraint
                
                UIView.animate(withDuration: 0.35, animations: {
                    self.view.layoutIfNeeded()
                }) { _ in
                    
                    self.shareButton.isHidden = false
                    self.photoButton.isHidden = false
                    
                    self.view.layoutIfNeeded()
                    
                    self.shareConstraint.constant = self.primaryShareConstraint
                    self.photoConstraint.constant = self.primaryPhotoConstraint
                    
                    UIView.animate(withDuration: 0.35, animations: {
                        self.view.layoutIfNeeded()
                    }) { _ in
                        self.enableButtons(isEnabled:true)
                    }
                }
            }
        } else {
            
            
            shareConstraint.constant = self.view.bounds.size.width - 16 - shareButton.bounds.size.height
            photoConstraint.constant = self.view.bounds.size.width - 16 - photoButton.bounds.size.height
            // topViewConstraint.constant = primaryTopViewConstraint
            
            
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            }) { _ in
                
                self.shareButton.isHidden = true
                self.photoButton.isHidden = true
                
                self.view.layoutIfNeeded()
                
                self.editConstraint.constant = ((self.view.bounds.size.width - self.editButton.bounds.size.height) / 2) - 16
                self.cameraConstraint.constant = ((self.view.bounds.size.width - self.cameraButton.bounds.size.height) / 2) - 16
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.layoutIfNeeded()
                }) { _ in
                    
                    self.cameraButton.isHidden = true
                    self.editButton.isHidden = true
                    
                    self.view.layoutIfNeeded()
                    
                    self.topViewConstraint.constant = (self.view.bounds.size.height - self.bottomView.bounds.size.height ) - 20
                    
                    UIView.animate(withDuration: 0.2, animations: {
                        self.view.layoutIfNeeded()
                    }) { _ in
                        
                        self.topView.isHidden = true
                        self.enableButtons(isEnabled:true)
                    }
                }
            }
        }
        
        
        self.menuIsActive = !activeMenu
    }
    
    
    func closedMenuConstraintsUpdate() {
        topViewConstraint.constant = (self.view.bounds.size.height - bottomView.bounds.size.height ) - 20
        shareConstraint.constant = self.view.bounds.size.width - 16 - shareButton.bounds.size.height
        cameraConstraint.constant = ((self.view.bounds.size.width - cameraButton.bounds.size.height) / 2) - 16
        photoConstraint.constant = self.view.bounds.size.width - 16 - photoButton.bounds.size.height
        editConstraint.constant = ((self.view.bounds.size.width - editButton.bounds.size.height) / 2) - 16
    }
    
    func enableButtons(isEnabled: Bool) {
        shareButton.isUserInteractionEnabled = isEnabled
        menuButton.isUserInteractionEnabled = isEnabled
        photoButton.isUserInteractionEnabled = isEnabled
        cameraButton.isUserInteractionEnabled = isEnabled
        cancelButton.isUserInteractionEnabled = isEnabled
        editButton.isUserInteractionEnabled = isEnabled
    }
    
    func alphaButtons(alpha: CGFloat) {
        if alpha == 0 {
            enableButtons(isEnabled:false)
        } else {
            enableButtons(isEnabled:true)
        }
        shareButton.alpha = alpha
        menuButton.alpha = alpha
        photoButton.alpha = alpha
        cameraButton.alpha = alpha
        cancelButton.alpha = alpha
        editButton.alpha = alpha
    }
    
    
    func saveConstraints() {
        primaryEditConstraint = editConstraint.constant
        primaryTopViewConstraint = topViewConstraint.constant
        primaryShareConstraint  = shareConstraint.constant
        primaryCameraConstraint = cameraConstraint.constant
        primaryPhotoConstraint = photoConstraint.constant
    }
}

