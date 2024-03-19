//
//  MovieDataManager.swift
//  BANQUEMISR
//
//  Created by Prakash Kotwal on 19/03/2024.
//

import CoreData
import Combine

class MovieDataManager {
	static let shared = MovieDataManager()
	
	private init() {}
	
	private var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "BANQUEMISR")
		container.loadPersistentStores(completionHandler: { (_, error) in
			if let error = error {
				fatalError("Failed to load Core Data stack: \(error)")
			}
		})
		return container
	}()
	
	private var mainContext: NSManagedObjectContext {
		return persistentContainer.viewContext
	}
	
	func saveMovies(_ movies: [Movie]) -> AnyPublisher<Void, Error> {
		return Future<Void, Error> { [weak self] promise in
			guard let self = self else {
				promise(.failure(CoreDataError.unknownError))
				return
			}
			self.mainContext.perform {
				do {
					for movie in movies {
						let movieObject = MovieEntity(context: self.mainContext)
						self.update(movieObject, with: movie)
					}
					try self.mainContext.save()
					promise(.success(()))
				} catch {
					promise(.failure(CoreDataError.saveError(error)))
				}
			}
		}
		.eraseToAnyPublisher()
	}
	
	
	func fetchNowPlayingMovies() -> AnyPublisher<[Movie], Error> {
		let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
		return Future<[Movie], Error> { [weak self] promise in
			guard let self = self else {
				promise(.failure(CoreDataError.unknownError))
				return
			}
			self.mainContext.perform {
				do {
					let movieEntities = try self.mainContext.fetch(fetchRequest)
					let movies = movieEntities.map { self.movie(from: $0) }
					promise(.success(movies))
				} catch {
					promise(.failure(CoreDataError.fetchError(error)))
				}
			}
		}
		.eraseToAnyPublisher()
	}
	
	private func update(_ movieObject: MovieEntity, with movie: Movie) {
		movieObject.id = Int64(movie.id)
		movieObject.title = movie.title
		movieObject.overview = movie.overview
		movieObject.backdropPath = movie.backdropPath
		movieObject.genreIds = movie.genreIds.map(String.init).joined(separator: ",")
		movieObject.originalLanguage = movie.originalLanguage
		movieObject.originalTitle = movie.originalTitle
		movieObject.popularity = movie.popularity
		movieObject.posterPath = movie.posterPath
		movieObject.releaseDate = movie.releaseDate
		movieObject.video = movie.video
		movieObject.voteAverage = movie.voteAverage
		movieObject.voteCount = Int64(movie.voteCount)
	}
	
	private func movie(from movieObject: MovieEntity) -> Movie {
		let genreIdsString = movieObject.genreIds ?? ""
		let genreIds = genreIdsString.split(separator: ",").compactMap { Int($0) }
		
		return Movie(
			id: Int(movieObject.id),
			title: movieObject.title ?? "",
			overview: movieObject.overview ?? "",
			backdropPath: movieObject.backdropPath,
			genreIds: genreIds,
			originalLanguage: movieObject.originalLanguage ?? "",
			originalTitle: movieObject.originalTitle ?? "",
			popularity: movieObject.popularity,
			posterPath: movieObject.posterPath,
			releaseDate: movieObject.releaseDate ?? "",
			video: movieObject.video,
			voteAverage: movieObject.voteAverage,
			voteCount: Int(movieObject.voteCount)
		)
	}
}
