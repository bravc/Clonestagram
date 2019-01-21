//
//  PostTableViewCell.swift
//  notinstagram
//
//  Created by Cameron Braverman on 1/14/19.
//  Copyright © 2019 Cameron Braverman. All rights reserved.
//

import UIKit
import SDWebImage

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postDesc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(post: Post) {
        postImage.imageFromURL(urlString: post.image_url)
        self.postDesc.text = post.desc
    }

    @IBAction func favPressed(_ sender: Any) {
    }
    
    @IBAction func savePressed(_ sender: Any) {
        let alert = UIAlertController(title: "Save?", message: "Do you want to save image?", preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Save", style: .default) { (AlertAction) in
            UIImageWriteToSavedPhotosAlbum(self.postImage.image!, self, #selector(self.finishedSaving), nil)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancel)
        if let parent = parentViewController {
            parent.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func finishedSaving() {
        let alert = CBAlert.errorAlert(title: "Success!", message: "Image was saved")
        if let parent = parentViewController {
            parent.present(alert, animated: true, completion: nil)
        }
    }
}

extension UIImageView {
    public func imageFromURL(urlString: String) {

        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        
        if self.image == nil{
            DispatchQueue.main.async(execute: { () -> Void in
                activityIndicator.startAnimating()
                self.addSubview(activityIndicator)
                
            })
            
        }

        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in

            if error != nil {
                print(error ?? "No Error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                activityIndicator.removeFromSuperview()
                self.image = image
            })

        }).resume()
    }
}

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if parentResponder is UIViewController {
                return parentResponder as? UIViewController
            }
        }
        return nil
    }
}
