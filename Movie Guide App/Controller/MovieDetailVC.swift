//
//  MovieDetailVC.swift
//  Movie Guide App
//
//  Created by Mohamed on 1/24/18.
//  Copyright © 2018 Mohamed. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD


class MovieDetailVC: UIViewController {

    var movie: Movie!
    let trailer = Trailer()
    let trailerVC = TrailerVC()
    
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var langageLabel: UILabel!
    @IBOutlet weak var keylabel: UILabel!
    @IBOutlet weak var watchTrailerButton: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
       overviewLabel.text = movie.overview
        let myurl = URL(string: movie.image)!
        downloadImage(url: myurl, myImage: posterImage)
        titleLabel.text = movie.title
        rateLabel.text = String(movie.rate!)
        releaseDateLabel.text = movie.release_Date
        langageLabel.text = movie.original_langage
    
     
        
        getMovieTrailerData()
        
    }


    @IBAction func backButtonPressed(_ sender: Any) {
        SVProgressHUD.show()
        self.dismiss(animated: true, completion: nil)
        SVProgressHUD.dismiss()
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
    
    
    func getMovieTrailerData(){
           let trailer_url = "https://api.themoviedb.org/3/movie/\(self.movie.video_ID!)/videos?api_key=90b29a16adf0d3f819e9f2a88ae669d9&language=en-US"
        Alamofire.request(trailer_url, method: .get).responseJSON{
            response in
                if response.result.isSuccess{
                    print("We have got the movie trailer Data!!")
                    let movieTrailerJson: JSON = JSON(response.result.value!)
                    print(movieTrailerJson)
                    self.updatemovietrailerDate(json: movieTrailerJson)
                }
             }
          }
    
    
    func updatemovietrailerDate(json: JSON){
        if let results = json["results"].array{
            if results.isEmpty == false{
          trailer.video_key = results[0]["key"].stringValue
            updateUI()
            }
            else{
                watchTrailerButton.isEnabled = false
                
                let alert = UIAlertController(title: "Trailer Unavailable", message: "Sorry,trailer is not available for that movie.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
               alert.addAction(okAction)
               present(alert, animated: true)
            }
           
            }
        }
    
    func updateUI(){
        keylabel.text = trailer.video_key
    }
    
    
    @IBAction func watchTrailerPressed(_ sender: Any) {
        SVProgressHUD.show()
        performSegue(withIdentifier: "goToTrailer", sender: self)
        SVProgressHUD.dismiss()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToTrailer"
        {
            let destinationVC = segue.destination as! TrailerVC
            destinationVC.code = keylabel.text!
        }
    }
    
    
}
