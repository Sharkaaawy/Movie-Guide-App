//
//  Movie.swift
//  Movie Guide App
//
//  Created by Mohamed on 1/24/18.
//  Copyright © 2018 Mohamed. All rights reserved.
//

import Foundation
import SwiftyJSON

class Movie{
    
    var title: String!
    var image: String!
    var overview: String!
    var original_langage: String!
    var rate: Double!
    var release_Date: String!
    var video_ID: Int!
    
    
    
    init(){
        
        
    }
    
    
    init(result: [String:Any]) {
        title = result["original_title"] as! String
        let temp = result["poster_path"] as! String
        image = "https://image.tmdb.org/t/p/w500\(temp)"
        overview = result["overview"] as! String
        original_langage = result["original_language"] as! String
        rate = result["vote_average"] as! Double
        release_Date = result["release_date"] as! String
        video_ID = result["id"] as! Int
        
    }
    
    
    
}
