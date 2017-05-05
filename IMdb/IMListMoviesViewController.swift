//
//  IMListMoviesViewController.swift
//  IMdb
//
//  Created by formador on 5/5/17.
//  Copyright © 2017 formador. All rights reserved.
//

import UIKit
import Kingfisher

class IMListMoviesViewController: UIViewController {
    
    //MARK: - Variables locales
    var movies = [MovieModel]()
    var collectionPadding : CGFloat = 0
    let customRefresh = UIRefreshControl()
    let dataProvider = LocalCoreDataservice()
    var tapGR : UITapGestureRecognizer!
    
    
    //MARK: - IBOutlets
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var mySearchBar: UISearchBar!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        customRefresh.addTarget(self,
                                action: #selector(loadData),
                                for: .valueChanged)
        myCollectionView.refreshControl?.tintColor = UIColor.white
        myCollectionView.refreshControl = customRefresh
        
        tapGR = UITapGestureRecognizer(target: self,
                                       action: #selector(hideKeyboard))
        
        loadData()
        
        setupPadding()
        
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        mySearchBar.delegate = self
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Utils
    func loadData(){
        dataProvider.topMovie({ (localResult) in
            if let movieData = localResult{
                self.movies = movieData
                DispatchQueue.main.async {
                    self.myCollectionView.reloadData()
                }
            }else{
                print("No hay registros en CoreData")
            }
            //self.customRefresh.endRefreshing()
        }) { (remoteResult) in
            if let movieData = remoteResult{
                self.movies = movieData
                DispatchQueue.main.async {
                    self.myCollectionView.reloadData()
                    self.customRefresh.endRefreshing()
                }
            }
        }
    }
    
    func hideKeyboard(){
        
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}// FIN DE LA CLASE

//MARK: - Extension de Collection Delegate
extension IMListMoviesViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate{
    
    func setupPadding(){
        let anchoPantalla = self.view.frame.width
        collectionPadding = (anchoPantalla - (3 * 113)) / 4
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: collectionPadding,
                            left: collectionPadding,
                            bottom: collectionPadding,
                            right: collectionPadding)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return collectionPadding
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! IMDetailCustomCell
        let model = movies[indexPath.row]
        configuredCell(cell, withMovie: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 113, height: 170)
    }
    
    
    func configuredCell(_ cell : IMDetailCustomCell, withMovie movie : MovieModel){
        if let imageData = movie.image{
            cell.myImageMovie.kf.setImage(with: ImageResource(downloadURL: URL(string: imageData)!),
                                          placeholder: #imageLiteral(resourceName: "img-loading"),
                                          options: nil,
                                          progressBlock: nil,
                                          completionHandler: nil)
        }
    }
    
    
    
    
    
    
    
    
    
}
















