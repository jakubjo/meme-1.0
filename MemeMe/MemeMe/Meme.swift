//
//  Meme.swift
//  MemeMeImagePicker
//
//  Created by Jakub on 02.08.15.
//  Copyright (c) 2015 Jakub Jozefek. All rights reserved.
//

import UIKit

class Meme {
    
    var texts: (top: String, bottom: String)!
    var image: UIImage!
    var memedImage: UIImage!
    
    init(texts:(top: String, bottom: String), image:UIImage, memedImage:UIImage) {
        self.texts = texts
        self.image = image
        self.memedImage = memedImage
    }
    
}
