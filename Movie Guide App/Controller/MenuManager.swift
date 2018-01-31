//
//  MenuManager.swift
//  Movie Guide App
//
//  Created by Mohamed on 1/27/18.
//  Copyright © 2018 Mohamed. All rights reserved.
//

import UIKit
import SVProgressHUD

class MenuManager: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    let blackView = UIView()
    let menuTableView = UITableView()
    var menuArray = ["top_rated", "popular", "upcoming", "now_playing"]
    var mainVC: ViewController?
    
    override init() {
        super.init()
        
        menuTableView.delegate = self
        menuTableView.dataSource = self
        
        menuTableView.isScrollEnabled = false
        menuTableView.bounces = false
        
        menuTableView.register(BaseViewCell.classForCoder(), forCellReuseIdentifier: "cellID")
    }
    
    
    
    public func openMenu(){
        if let window = UIApplication.shared.keyWindow{
         blackView.frame = window.frame
         blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
           
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissMenu)))
            
            let height: CGFloat = 200
            let y = window.frame.height - height
            menuTableView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            
         window.addSubview(blackView)
         window.addSubview(menuTableView)
            
         UIView.animate(withDuration: 0.5, animations: {
                self.blackView.alpha = 1
                self.menuTableView.frame.origin.y = y
            })
        }
    }
    
    @objc public func dismissMenu(){
    self.blackView.alpha = 0
        if let window = UIApplication.shared.keyWindow{
            self.menuTableView.frame.origin.y = window.frame.height
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as UITableViewCell
        cell.textLabel?.text = menuArray[indexPath.item]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = mainVC{
            vc.source = menuArray[indexPath.item]
            vc.getMovieData(fromSource: menuArray[indexPath.item])
            dismissMenu()
        }
    }

}
