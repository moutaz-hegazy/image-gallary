//
//  gallary model.swift
//  image gallary
//
//  Created by Moutaz_Hegazy on 6/1/20.
//  Copyright © 2020 Moutaz_Hegazy. All rights reserved.
//

import Foundation


struct collectionViewModel {
    
    var title : String = "Untitled"
    
    var imageUrl : URL?
    
    var imageHeight : Float?
    
    init (withURL url:URL? ){
        imageUrl = url
    }
    
}


struct tableViewModel{
    
    var title  = "Untitled"
    
    var imageObjects = [collectionViewModel]()
    
}
