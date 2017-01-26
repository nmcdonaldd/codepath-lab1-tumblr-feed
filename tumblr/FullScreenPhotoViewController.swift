//
//  FullScreenPhotoViewController.swift
//  tumblr
//
//  Created by Nick McDonald on 1/26/17.
//  Copyright © 2017 Nick McDonald. All rights reserved.
//

import UIKit

class FullScreenPhotoViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var fullScreenZoomableImageView: UIImageView!
    var imageToUse: UIImage?
    
    @IBOutlet weak var imageScrollView: UIScrollView!
    
    @IBAction func onDismissButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fullScreenZoomableImageView.image = self.imageToUse
        self.imageScrollView.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.fullScreenZoomableImageView
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
