//
//  ViewController.swift
//  Movie Guide App
//
//  Created by Mohamed on 1/24/18.
//  Copyright © 2018 Mohamed. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var moviesCollection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    //Variables:
    var filteringMode = false
    var moviesArray = [Movie]()
    var filteredMovies = [Movie]()
    var menuManager = MenuManager()
    var source = "top_rated"
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        moviesCollection.delegate = self
        moviesCollection.dataSource = self
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.done
        
        getMovieData(fromSource: source)
        
    }


    func getMovieData(fromSource provider: String){
        let url = "https://api.themoviedb.org/3/movie/\(provider)?api_key=90b29a16adf0d3f819e9f2a88ae669d9"
        Alamofire.request(url, method: .get).responseJSON{
         response in
            if response.result.isSuccess{
             print("Success We have got the movie data!!")
                let movieJson: JSON = JSON(response.result.value!)
                self.updateMovieData(json: movieJson)
                
            }else{
                
                print("problem in connection!")
                let alert = UIAlertController(title: "Connection Error", message: "Sorry, there is a problem in internet connection", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(okAction)
               self.present(alert, animated: true)
            }
        }
    }
   
    
    
    func updateMovieData(json: JSON)
    {
        if let results = json["results"].array{
            
            for result in results {
                let movie = Movie(result: result.dictionaryObject!)
                moviesArray.append(movie)
            }
          self.moviesCollection.reloadData()
        }
        else{
            print("data unavailable")
            let alert = UIAlertController(title: "Data Unavailable", message: "Sorry, there is a problem in fetching data", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
    }
    
    
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    
    func downloadImage(url: URL, myImage:UIImageView) {
        print("Download Started")
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                myImage.image = UIImage(data: data)
            }
        }
    }
    
    func videoID(){
        print()
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if filteringMode == false{
            return moviesArray.count
        }
        else {
            return filteredMovies.count
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as? MovieCell{
            
            
            if filteringMode == false {
            let myurl = URL(string: moviesArray[indexPath.row].image)!
            downloadImage(url: myurl, myImage: cell.posterImage)
            cell.titleLabel.text = moviesArray[indexPath.row].title
            }
            else{
                let myurl = URL(string: filteredMovies[indexPath.row].image)!
                downloadImage(url: myurl, myImage: cell.posterImage)
                cell.titleLabel.text = filteredMovies[indexPath.row].title
            }
       return cell
            
        }else{
     return UICollectionViewCell()
    }
 }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        SVProgressHUD.show()
        
        var movie: Movie!
        if filteringMode == true{
            
            movie = filteredMovies[indexPath.row]
        }else{
            
            movie = moviesArray[indexPath.row]
        }
        
        performSegue(withIdentifier: "movieDetail", sender: movie)
        SVProgressHUD.dismiss()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "movieDetail"{
            
            if let movieDetail = segue.destination as? MovieDetailVC{
                if let movie = sender as? Movie{
                    movieDetail.movie = movie
                }
            }
        }
    }
    
    
    
    @IBAction func menuPressed(_ sender: Any) {
        menuManager.openMenu()
        menuManager.mainVC = self
    }
    
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            filteringMode = false
           moviesCollection.reloadData()
           view.endEditing(true)
        }
        else{
        filteringMode = true
            let searchKey = searchBar.text!
            filteredMovies = moviesArray.filter({$0.title.range(of: searchKey ) != nil})
            moviesCollection.reloadData()
        }
        
    }
    

}
