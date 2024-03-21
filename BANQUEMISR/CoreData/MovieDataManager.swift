//
//  MovieDataManager.swift
//  BANQUEMISR
//
//  Created by Prakash Kotwal on 19/03/2024.
//

import CoreData
import Combine
//
class MovieDataManager {
	static let shared = MovieDataManager()
	
	internal init() {}
	
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
//class MovieDataManager {
//	static let shared = MovieDataManager()
//	
//	internal init() {}
//	
//	private var persistentContainer: NSPersistentContainer = {
//		let container = NSPersistentContainer(name: "BANQUEMISR")
//		container.loadPersistentStores(completionHandler: { (_, error) in
//			if let error = error {
//				fatalError("Failed to load Core Data stack: \(error)")
//			}
//		})
//		return container
//	}()
//	
//	private var mainContext: NSManagedObjectContext {
//		return persistentContainer.viewContext
//	}
//	
//	func saveMovies(_ movies: [Movie], movieDetails: [MovieDetail]) -> AnyPublisher<Void, Error> {
//		return Future<Void, Error> { [weak self] promise in
//			guard let self = self else {
//				promise(.failure(CoreDataError.unknownError))
//				return
//			}
//			self.mainContext.perform {
//				do {
//					for (movie, movieDetail) in zip(movies, movieDetails) {
//						let movieObject = MovieEntity(context: self.mainContext)
//						self.update(movieObject, with: movie)
//						
//						let movieDetailObject = MovieDetailEntity(context: self.mainContext)
//						self.update(movieDetailObject, with: movieDetail)
//						
//						// Associate MovieEntity with MovieDetailEntity
//						movieObject.movieDetail = movieDetailObject
//					}
//					try self.mainContext.save()
//					promise(.success(()))
//				} catch {
//					promise(.failure(CoreDataError.saveError(error)))
//				}
//			}
//		}
//		.eraseToAnyPublisher()
//	}
//	
//	
//	func fetchNowPlayingMovies() -> AnyPublisher<[Movie], Error> {
//		let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
//		return Future<[Movie], Error> { [weak self] promise in
//			guard let self = self else {
//				promise(.failure(CoreDataError.unknownError))
//				return
//			}
//			self.mainContext.perform {
//				do {
//					let movieEntities = try self.mainContext.fetch(fetchRequest)
//					let movies = movieEntities.map { self.movie(from: $0) }
//					promise(.success(movies))
//				} catch {
//					promise(.failure(CoreDataError.fetchError(error)))
//				}
//			}
//		}
//		.eraseToAnyPublisher()
//	}
//	
//	private func update(_ movieObject: MovieEntity, with movie: Movie) {
//		movieObject.id = Int64(movie.id)
//		movieObject.title = movie.title
//		movieObject.overview = movie.overview
//		movieObject.backdropPath = movie.backdropPath
//		movieObject.genreIds = movie.genreIds.map(String.init).joined(separator: ",")
//		movieObject.originalLanguage = movie.originalLanguage
//		movieObject.originalTitle = movie.originalTitle
//		movieObject.popularity = movie.popularity
//		movieObject.posterPath = movie.posterPath
//		movieObject.releaseDate = movie.releaseDate
//		movieObject.video = movie.video
//		movieObject.voteAverage = movie.voteAverage
//		movieObject.voteCount = Int64(movie.voteCount)
//	}
//	
//	private func update(_ movieDetailObject: MovieDetailEntity, with movieDetail: MovieDetail) {
//		movieDetailObject.adult = movieDetail.adult
//		movieDetailObject.backdropPath = movieDetail.backdropPath
//		movieDetailObject.budget = movieDetail.budget
//		movieDetailObject.homepage = movieDetail.homepage
//		movieDetailObject.id = Int64(movieDetail.id)
//		movieDetailObject.imdbID = movieDetail.imdbID
//		movieDetailObject.originalLanguage = movieDetail.originalLanguage
//		movieDetailObject.originalTitle = movieDetail.originalTitle
//		movieDetailObject.overview = movieDetail.overview
//		movieDetailObject.popularity = movieDetail.popularity
//		movieDetailObject.posterPath = movieDetail.posterPath
//		movieDetailObject.releaseDate = movieDetail.releaseDate
//		movieDetailObject.revenue = Int64(movieDetail.revenue)
//		movieDetailObject.runtime = Int64(movieDetail.runtime)
//		movieDetailObject.status = movieDetail.status
//		movieDetailObject.tagline = movieDetail.tagline
//		movieDetailObject.title = movieDetail.title
//		movieDetailObject.video = movieDetail.video
//		movieDetailObject.voteAverage = movieDetail.voteAverage
//		movieDetailObject.voteCount = Int64(movieDetail.voteCount)
//		
//		// Update other properties similarly
//		
//		// Update the relationships and genre, prodtcion compamny and country, spoken language
//		if let belongsToCollection = movieDetail.belongsToCollection {
//			let collectionObject = BelongsToCollectionEntity(context: mainContext)
//			collectionObject.id = Int64(belongsToCollection.id)
//			collectionObject.name = belongsToCollection.name
//			movieDetailObject.belongsToCollection = collectionObject
//		}
//		for genre in movieDetail.genres{
//			let collectionObject = GenreEntity(context: mainContext)
//			collectionObject.id = Int64(genre.id)
//			collectionObject.name = genre.name
//		}
//		
//		for company in movieDetail.productionCompanies{
//			let collectionObject = ProductionCompanyEntity(context: mainContext)
//			collectionObject.id = Int64(company.id)
//			collectionObject.logoPath = company.logoPath
//			collectionObject.name = company.name
//			collectionObject.originCountry = company.originCountry
//		}
//		
//		for country in movieDetail.productionCountries{
//			let collectionObject = ProductionCountryEntity(context: mainContext)
//			collectionObject.iso_3166_1 = country.iso_3166_1
//			collectionObject.name = country.name
//		}
//		
//		for language in movieDetail.spokenLanguages{
//			let collectionObject = SpokenLanguageEntity(context: mainContext)
//			collectionObject.englishName = language.englishName
//			collectionObject.name = language.name
//			collectionObject.iso_639_1 = language.iso_639_1
//		}
//		
//		// Similarly, update other relationships like productionCompanies, productionCountries, spokenLanguages, etc.
//	}
//	
//	private func movie(from movieObject: MovieEntity) -> Movie {
//		let genreIdsString = movieObject.genreIds ?? ""
//		let genreIds = genreIdsString.split(separator: ",").compactMap { Int($0) }
//		
//		return Movie(
//			id: Int(movieObject.id),
//			title: movieObject.title ?? "",
//			overview: movieObject.overview ?? "",
//			backdropPath: movieObject.backdropPath,
//			genreIds: genreIds,
//			originalLanguage: movieObject.originalLanguage ?? "",
//			originalTitle: movieObject.originalTitle ?? "",
//			popularity: movieObject.popularity,
//			posterPath: movieObject.posterPath,
//			releaseDate: movieObject.releaseDate ?? "",
//			video: movieObject.video,
//			voteAverage: movieObject.voteAverage,
//			voteCount: Int(movieObject.voteCount)
//		)
//	}
//	
//	func saveMovieDetail(_ movieDetail: MovieDetail) -> AnyPublisher<Void, Error> {
//		return Future<Void, Error> { [weak self] promise in
//			guard let self = self else {
//				promise(.failure(CoreDataError.unknownError))
//				return
//			}
//			self.mainContext.perform {
//				do {
//					let movieDetailObject = MovieDetailEntity(context: self.mainContext)
//					self.update(movieDetailObject, with: movieDetail)
//					try self.mainContext.save()
//					promise(.success(()))
//				} catch {
//					promise(.failure(CoreDataError.saveError(error)))
//				}
//			}
//		}
//		.eraseToAnyPublisher()
//	}
//	
//	func fetchMovieDetail(for movieID: Int) -> AnyPublisher<MovieDetail?, Error> {
//		let fetchRequest: NSFetchRequest<MovieDetailEntity> = MovieDetailEntity.fetchRequest()
//		fetchRequest.predicate = NSPredicate(format: "id == %d", movieID)
//		return Future<MovieDetail?, Error> { [weak self] promise in
//			guard let self = self else {
//				promise(.failure(CoreDataError.unknownError))
//				return
//			}
//			self.mainContext.perform {
//				do {
//					let movieDetailEntity = try self.mainContext.fetch(fetchRequest).first
//					let movieDetail = movieDetailEntity.map { self.movieDetail(from: $0) }
//					promise(.success(movieDetail))
//				} catch {
//					promise(.failure(CoreDataError.fetchError(error)))
//				}
//			}
//		}
//		.eraseToAnyPublisher()
//	}
//	func movieDetail(from movieDetailEntity: MovieDetailEntity) -> MovieDetail {
//		// Implement the conversion logic from MovieDetailEntity to MovieDetail
//		// For example:
//		return MovieDetail(
//			adult: movieDetailEntity.adult,
//			backdropPath: movieDetailEntity.backdropPath,
//			belongsToCollection: movieDetailEntity.belongsToCollection, // Assuming this is already converted to a struct
//			budget: movieDetailEntity.budget,
//			genres: movieDetailEntity.genres, // Assuming this is already converted to an array of structs
//			homepage: movieDetailEntity.homepage,
//			id: Int(movieDetailEntity.id),
//			imdbID: movieDetailEntity.imdbID ?? "",
//			originalLanguage: movieDetailEntity.originalLanguage ?? "",
//			originalTitle: movieDetailEntity.originalTitle ?? "",
//			overview: movieDetailEntity.overview ?? "",
//			popularity: movieDetailEntity.popularity,
//			posterPath: movieDetailEntity.posterPath,
//			productionCompanies: movieDetailEntity.productionCompanies, // Assuming this is already converted to an array of structs
//			productionCountries: movieDetailEntity.productionCountries, // Assuming this is already converted to an array of structs
//			releaseDate: movieDetailEntity.releaseDate ?? "",
//			revenue: Int(movieDetailEntity.revenue),
//			runtime: Int(movieDetailEntity.runtime),
//			spokenLanguages: convertSpokenLanguages(movieDetailEntity.spokenLanguages), // Assuming this is already converted to an array of structs
//			status: movieDetailEntity.status ?? "",
//			tagline: movieDetailEntity.tagline,
//			title: movieDetailEntity.title ?? "",
//			video: movieDetailEntity.video,
//			voteAverage: movieDetailEntity.voteAverage,
//			voteCount: Int(movieDetailEntity.voteCount)
//		)
//	}
//	func convertSpokenLanguages(_ spokenLanguages: Set<SpokenLanguageEntity>) -> Set<SpokenLanguage> {
//		var convertedSpokenLanguages: Set<SpokenLanguage> = []
//		
//		for spokenLanguageEntity in spokenLanguages {
//			let spokenLanguage = SpokenLanguage(
//				englishName: spokenLanguageEntity.englishName ?? "",
//				iso_639_1: spokenLanguageEntity.iso_639_1 ?? "",
//				name: spokenLanguageEntity.name ?? ""
//			)
//			convertedSpokenLanguages.insert(spokenLanguage)
//		}
//		
//		return convertedSpokenLanguages
//	}
//	
//	
//}
