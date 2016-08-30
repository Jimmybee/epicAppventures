//
//  PictureClueViewController.swift
//  EA - Clues
//
//  Created by James Birtwell on 09/02/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import UIKit

class PictureClueViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    lazy var clueImage =  UIImage()
    @IBOutlet var imageView: UIImageView!
    
    weak var delegate: PictureClueViewControllerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.backgroundColor = UIColor.blackColor()
        scrollView.contentSize = self.view.bounds.size
        scrollView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
    }
    
    func setup () {
        imageView.image = clueImage
    }
    
    func zoomOut() {
        scrollView.scrollEnabled = false
        scrollView.zoomScale = 1
    }
    
    @IBAction func zoomTap(sender: UITapGestureRecognizer) {
        if scrollView.zoomScale == 1 {
            
            scrollView.scrollEnabled = true
            scrollView.zoomScale = 2
            delegate.closePan()
        } else {
             zoomOut()
        }
    }


}

extension PictureClueViewController : UIScrollViewDelegate {
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}

protocol PictureClueViewControllerDelegate : NSObjectProtocol {
    func closePan ()
}