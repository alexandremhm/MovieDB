//
//  RetrievePersistedData.swift
//  moviesDb
//
//  Created by Matheus Henrique Mendes Alexandre on 09/09/22.
//

import Foundation

struct RetrievePersistedData {
    let decoder = JSONDecoder()

    func getPersistedGenreData(genres: [Int:String]) {
        do {
            let genreURL = URL(fileURLWithPath: "Genre", relativeTo: FileManager.documentsDirectoryURL)
            let savedGenreData = try Data(contentsOf: genreURL)
            let genreDecoded = try decoder.decode([Int:String].self, from: savedGenreData)
            genres = genreDecoded
        } catch {
            print(error)
        }
    }
    
    func getPersistedMovieData() {
        do {
            let movieURL = URL(fileURLWithPath: "MovieDetails", relativeTo: FileManager.documentsDirectoryURL)
            let savedMovieData = try Data(contentsOf: movieURL)
            let movieDecoded = try decoder.decode(MovieDetails.self, from: savedMovieData)
            self.movieExtraInfos = movieDecoded
        } catch {
            print(error)
        }
    }
    
    func getPersistedCreditsData() {
        do {
            let creditsURL = URL(fileURLWithPath: "Credits", relativeTo: FileManager.documentsDirectoryURL)
            let savedCreditsData = try Data(contentsOf: creditsURL)
            let creditsDecoded = try decoder.decode(Credits.self, from: savedCreditsData)
            self.credits = creditsDecoded
        } catch {
            print(error)
        }
    }
}
