//
//  IMListMoviesViewController.swift
//  IMdb
//
//  Created by formador on 5/5/17.
//  Copyright © 2017 formador. All rights reserved.
//

import UIKit

class IMListMoviesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let remote = RemoteItunesMovieServie()
        remote.getTopMovies { (resultData) in
            print("\(resultData)")
        }
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
