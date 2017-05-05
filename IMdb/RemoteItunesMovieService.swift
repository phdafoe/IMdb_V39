//
//  RemoteItunesMovieService.swift
//  IMdb
//
//  Created by formador on 28/4/17.
//  Copyright © 2017 formador. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class RemoteItunesMovieServie {
    
    //metodo top Movies
    func getTopMovies(_ completionHandler : @escaping ([[String : String]]?) -> ()){
        
        
        let urlData = CONSTANTES.BASE_URL.BASE_ITUNES
        
        Alamofire.request(URL(string: urlData)!,method: .get).validate().responseJSON { (responseData) in
            switch responseData.result{
            case .success:
                if let valorData = responseData.result.value{
                    
                    let json = JSON(valorData)
                    var resultData = [[String : String]]()
                    let entries = json["feed"]["entry"].arrayValue
                    for c_entry in entries{
                        
                        var movieDiccionario = [String : String]()
                        movieDiccionario["id"] = c_entry["id"]["attributes"]["im:id"].stringValue
                        //movieDiccionario[""]
                        
                        resultData.append(movieDiccionario)
                    }
                    completionHandler(resultData)
                }
                
                
                
                
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                completionHandler(nil)
            }
        }
        
        
        
        
        
    }
    
    
    
    
}
