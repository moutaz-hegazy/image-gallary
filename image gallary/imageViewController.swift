//
//  imageViewController.swift
//  image gallary
//
//  Created by Moutaz_Hegazy on 6/9/20.
//  Copyright © 2020 Moutaz_Hegazy. All rights reserved.
//

import UIKit

class imageViewController: UIViewController, UIScrollViewDelegate
{
    
    
    var image : UIImage?{
        
        get{
            return imageView.image
        }
        set{
            print("wezza : image is set")
            scrollView?.zoomScale = 1.0
            let size = newValue?.size ?? CGSize.zero
            imageView.image = newValue
            scrollView?.contentSize = size
            imageView.frame = CGRect(origin: CGPoint.zero, size: size)

            scrollViewWidth?.constant = size.width
            scrollViewHeight?.constant = size.height
            
            if let fullView = view,size.width > 0,size.height > 0{
                scrollView?.zoomScale = max(fullView.bounds.height/size.height, fullView.bounds.size.width/size.width)
            }
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollViewHeight.constant = imageView.frame.height
        scrollViewWidth.constant = imageView.frame.width
    }
    
    private var imageView  =  UIImageView()

    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var scrollViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.delegate = self
            scrollView.addSubview(imageView)
            scrollView.minimumZoomScale = 1/10
            scrollView.maximumZoomScale = 4
        }
    }
    
}
