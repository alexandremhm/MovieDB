//
//  NetworkService.swift
//  CollectionDiffable
//
//  Created by Matheus Henrique Mendes Alexandre on 07/09/22.
//

import Foundation

protocol MoviesManagerDelegate {
    func setUpcomingMovies(movies: [Movie])
    func setNowPlayingMovies(movies: [Movie])
}

struct MovieService {
    let baseURL = "https://api.themoviedb.org/3/movie/"
    let apiKey = "4b1041b588de8acc39afce6ad7f95ecb"
    
    var delegate: MoviesManagerDelegate?
    

    func fetchMovies(moviePath: String) {
        let urlString = "\(baseURL)\(moviePath)?api_key=\(apiKey)&language=en-US&page=1"
        print(urlString)
        //1- Create an URL
        guard let url = URL(string: urlString) else { return }
        // 2 - Create URL SESSION
        let session = URLSession.shared
        // 3 - Give Session a task
        let task = session.dataTask(with: url) {data, response, error in
            if error != nil {
                print(error!)
                return
            }
            guard let data = data else { return }
            
            if let movies = self.parseJSON(movieData: data) {
                if (moviePath == "upcoming") {
                    self.delegate?.setUpcomingMovies(movies: movies.results)
                } else {
                    self.delegate?.setNowPlayingMovies(movies: movies.results)
                }
            }
            
        }
        task.resume()
    }
    
    func getMovieGenres(completion: @escaping(GenresList) -> Void)  {
        let urlString = "https://api.themoviedb.org/3/genre/movie/list?api_key=\(apiKey)&language=en-US"
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            let decoder = JSONDecoder()
            
            do {
                let genres = try decoder.decode(GenresList.self, from: data)
                completion(genres)
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func getMovieDetailsBy(id: Int, completion: @escaping(MovieDetails) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/\(id)?api_key=\(apiKey)&language=en-US"

        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            let decoder = JSONDecoder()
            
            do {
                let movie = try decoder.decode(MovieDetails.self, from: data)
                completion(movie)
            } catch {
                print(error)
            }
        }
        task.resume()
    }
        
    func getMovieCreditsBy(id: Int, completion: @escaping(Credits) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/\(id)/credits?api_key=\(apiKey)&language=en-US"
        
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            let decoder = JSONDecoder()
            
            do {
                let credits = try decoder.decode(Credits.self, from: data)
                completion(credits)
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    

    func getMovieImagesBy(id: Int, completion: @escaping(MoviePosters) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/\(id)/images?api_key=\(apiKey)"
        
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            let decoder = JSONDecoder()
            
            do {
                let images = try decoder.decode(MoviePosters.self, from: data)
                completion(images)
            } catch {
                print(error)
            }
        }
        task.resume()
    }
      
    
    func parseJSON(movieData: Data) -> MovieList? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(MovieList.self, from: movieData)
            return decodedData
        } catch {
            print(error)
            return nil
        }
    }
}
