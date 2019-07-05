//
//  ViewController.swift
//  CameraGallery
//
//  Created by Sunil Kumar on 04/07/19.
//  Copyright © 2019 Sunil Kumar. All rights reserved.
//

import UIKit
import UserNotifications


class ViewController: UIViewController,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate
{
    let picker = UIImagePickerController()
    @IBOutlet weak var myImageView: UIImageView!
    
    @IBAction func photoFromLibrary(_ sender: UIAlertAction) {
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.modalPresentationStyle = .popover
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func shootPhoto(_ sender: UIAlertAction) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = UIImagePickerController.SourceType.camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            present(picker,animated: true,completion: nil)
        } else {
            noCamera()
        }
    }
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        notCamera()
        
        // Notification
        let notification = UNUserNotificationCenter.current()
        notification.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Sunil Said:", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Hello Developer! Let's code somemore in Xcode using Swift", arguments: nil)
        content.sound = UNNotificationSound.default
        content.badge = UIApplication.shared.applicationIconBadgeNumber + 1 as NSNumber;
        content.categoryIdentifier = "CameraGallery APp"
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 60.0, repeats: true)
        let request = UNNotificationRequest.init(identifier: "FiveSecond", content: content, trigger: trigger)
        // Schedule the notification.
        let center = UNUserNotificationCenter.current()
        center.add(request)
    }
    
    func notCamera(){
        let alertVC = UIAlertController()
        let okAction = UIAlertAction(
            title: "Camera",
            style:.default,
            handler: shootPhoto(_:))
        let osAction = UIAlertAction(
            title: "Gallery",
            style:.default,
            handler: photoFromLibrary(_:))
        let ocAction = UIAlertAction(
            title: "Cancel",
            style:.cancel,
            handler: cancelNotification(_:))
        alertVC.addAction(okAction)
        alertVC.addAction(osAction)
        alertVC.addAction(ocAction)
        
        modalPresentationStyle = .popover
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
    
    func cancelNotification(_ sender: UIAlertAction){
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        // or you can remove specifical notification:
        // center.removePendingNotificationRequests(withIdentifiers: ["FiveSecond"])
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        var  chosenImage = UIImage()
        chosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
    
        myImageView.contentMode = .scaleAspectFill
        myImageView.image = chosenImage
        dismiss(animated:true, completion: nil)
       //notCamera(CAAction)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        // or you can remove specifical notification:
        // center.removePendingNotificationRequests(withIdentifiers: ["FiveSecond"])
        dismiss(animated: true, completion: nil)
}
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.myImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.5)
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .allowUserInteraction, animations: {
        self.myImageView.transform = CGAffineTransform.identity
        }, completion: nil)
        
        super.touchesBegan(touches, with: event)
        notCamera()
        

    }

}

