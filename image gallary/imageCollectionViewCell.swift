//
//  imageCollectionViewCell.swift
//  image gallary
//
//  Created by Moutaz_Hegazy on 6/1/20.
//  Copyright © 2020 Moutaz_Hegazy. All rights reserved.
//

import UIKit

class imageCollectionViewCell: UICollectionViewCell
{
    
    var imageURL : URL?{
        didSet{
            
            if let url = imageURL{
                fetchImage(from : url)
            }
        }
    }
    
    var cellDelegate : cellControlDelegate?
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    private func fetchImage(from url : URL){
     
        DispatchQueue.global(qos: .userInitiated).async{
            if let urlContent = try? Data(contentsOf: url){
            
                DispatchQueue.main.async { [weak self] in
                    if let image = UIImage(data: urlContent){
                        self?.imageView.image = image
                        
                    }else{
                        self?.cellDelegate?.delete(cell: self!)
                    }
                }
            }
        }
    }
}
