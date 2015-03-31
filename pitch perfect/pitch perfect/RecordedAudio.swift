//
//  RecordedAudio.swift
//  pitch perfect
//
//  Created by Ethan Haley on 3/17/15.
//  Copyright (c) 2015 Ethan Haley. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    
    let filePathUrl: NSURL!
    let title: String!
    
    init(filePathUrl: NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}