//
//  TrailerVC.swift
//  Movie Guide App
//
//  Created by Mohamed on 1/29/18.
//  Copyright © 2018 Mohamed. All rights reserved.
//

import UIKit
import SVProgressHUD

class TrailerVC: UIViewController {
    
    
  @IBOutlet weak var trailerWebView: UIWebView!
    
    var code: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
     
     loadTrailer(code: code)
        
    }
    
    
    
    func loadTrailer(code: String)
    {
        
        
        let trailer_url = URL(string: "https://www.youtube.com/watch?v=\(code)")
        trailerWebView.loadRequest(URLRequest(url: trailer_url!))
        

    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        SVProgressHUD.show()
        self.dismiss(animated: true, completion: nil)
        SVProgressHUD.dismiss()
    }
    

}
