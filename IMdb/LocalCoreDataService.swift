//
//  LocalCoreDataService.swift
//  IMdb
//
//  Created by formador on 5/5/17.
//  Copyright © 2017 formador. All rights reserved.
//

import Foundation
import CoreData


class LocalCoreDataservice{
    
    let remotemovieService = RemoteItunesMovieServie()
    let stack = CoreDataStack.shared
    
    //1
    func searchMovie(_ byTerm : String, remoteHandler : @escaping ([MovieModel]?) -> ()){
        remotemovieService.searchMovies(byTerm) { (result) in
            if let movieData = result{
                var modelMovie = [MovieModel]()
                for c_movie in movieData{
                    let obj = MovieModel(pId: c_movie["id"]!,
                                         pTitle: c_movie["title"]!,
                                         pOrder: nil,
                                         pSummary: c_movie["summary"]!,
                                         pImage: c_movie["image"]!,
                                         pCategory: c_movie["category"]!,
                                         pDirector: c_movie["director"]!)
                    modelMovie.append(obj)
                }
                remoteHandler(modelMovie)
            }else{
                print("Error mientras se llama a los servicios de iTunes")
                remoteHandler(nil)
            }
        }
    }
    
    //2
    func topMovie(_ localHandler: @escaping ([MovieModel]?) ->(), remoteHandler : @escaping ([MovieModel]?) -> ()){
        
        localHandler(queryTopMovies())
        
        remotemovieService.getTopMovies { (result) in
            if let moviesData = result{
                self.markAllmoviesAnunsync()
                var order = 1
                for c_movieDiccionario in moviesData{
                    if let movieDataDes = self.getMovieById(c_movieDiccionario["id"]!, favorito: false){
                        //update
                        self.updateMovie(c_movieDiccionario, movie: movieDataDes, order: order)
                    }else{
                        //insert
                        self.insertMovie(c_movieDiccionario, order: order)
                    }
                    order += 1
                }
                remoteHandler(self.queryTopMovies())
                
            }else{
                print("Error mientras se llama a la API de iTunes")
                remoteHandler(nil)
            }
        }
    }
    
    //3
    func queryTopMovies() -> [MovieModel]?{
        let context = stack.persistentContainer.viewContext
        let request : NSFetchRequest<MovieManager> = MovieManager.fetchRequest()
        let sortDescription = NSSortDescriptor(key: "order", ascending: true)
        request.sortDescriptors = [sortDescription]
        
        let customPredicate = NSPredicate(format: "favorito = \(false)" )
        request.predicate = customPredicate
        
        do{
            let fetchMovies = try context.fetch(request)
            var movie = [MovieModel]()
            
            for c_movie in fetchMovies{
                movie.append(c_movie.mappedObj())
            }
            return movie
        }catch{
            print("Error mientras se obtienen las peliculas desde CoreData")
            return nil
        }
    }
    
    //4
    func markAllmoviesAnunsync(){
        
        let context = stack.persistentContainer.viewContext
        let request : NSFetchRequest<MovieManager> = MovieManager.fetchRequest()
        let customPredicate = NSPredicate(format: "favorito = \(false)")
        request.predicate = customPredicate
        do{
            let fetchMovies = try context.fetch(request)
            
            for c_manage in fetchMovies{
                c_manage.sync = false
            }
            try context.save()
        }catch{
            print("Error mientras se actualizan las peliculas desde CoreData")
        }
    }
    
    
    //5
    func getMovieById(_ id : String, favorito : Bool) -> MovieManager?{
        let context = stack.persistentContainer.viewContext
        let request : NSFetchRequest<MovieManager> = MovieManager.fetchRequest()
        let customPredicate = NSPredicate(format: "id = '\(id)' and favorito = \(favorito)")
        request.predicate = customPredicate
        
        do{
            let fetchmovies = try context.fetch(request)
            if fetchmovies.count > 0{
                return fetchmovies.last
            }else{
                return nil
            }
            
        }catch{
            print("Error mientras se obtienen las peliculas desde CoreData")
            return nil
        }
    }
    
    //5 - 1
    func insertMovie(_ movieDiccionario : [String : String], order : Int){
        let context = stack.persistentContainer.viewContext
        let movie = MovieManager(context: context)
        movie.id = movieDiccionario["id"]
        updateMovie(movieDiccionario, movie: movie, order: order)
    }
    
    
    //6
    func updateMovie (_ movieDiccionario : [String : String], movie : MovieManager, order : Int){
        let context = stack.persistentContainer.viewContext
        movie.order = Int16(order)
        movie.title = movieDiccionario["title"]
        movie.summary = movieDiccionario["summary"]
        movie.category = movieDiccionario["category"]
        movie.director = movieDiccionario["director"]
        movie.image = movieDiccionario["image"]
        movie.sync = true
        do{
            try context.save()
        }catch{
            print("Error mientras se actualiza el CoreData")
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
