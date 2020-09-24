//
//  SnapShotViewController.swift
//  CCSwiftTest
//
//  Created by Satyar Mansouri on 9/21/20.
//  Copyright © 2020 oulu. All rights reserved.
//

import UIKit

var image:UIImage = UIImage()

class SnapShotViewController: UIViewController {

    @IBAction func btn_save(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        let alert = UIAlertController(title: "Saved", message: "Your Image Has Been Saved", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    @IBOutlet weak var img_snap: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        img_snap.image = image

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
