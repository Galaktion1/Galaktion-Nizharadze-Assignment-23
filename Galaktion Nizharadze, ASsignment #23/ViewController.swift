//
//  ViewController.swift
//  Galaktion Nizharadze, ASsignment #23
//
//  Created by Gaga Nizharadze on 16.08.22.
//


import UIKit

class ViewController: UIViewController {
    
    
    var semaphore = DispatchSemaphore(value: 1)
    let tvShowFetch = TVShowFetch()
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        way1()
        way2()
  
    }
    
    var show: Show?
    var tvShows: TVShows?
    var tvShowDetails: TVShowDetails?
    
    let queue = DispatchQueue(label: "firstQueue",qos: .background)
    
    func way2() {
        
        queue.async {
            self.semaphore.wait()
            self.tvShowFetch.fetchMovies(from: .topRated, afterID: nil) { (result: Result<TVShows, Error>) in
                switch result {
                case .success(let topRatedShows):
                    self.show = topRatedShows.results.randomElement()
//                    print(topRatedShows)
                    print("1 - top rated films fetched")
                    self.semaphore.signal()
                case .failure(let err):
                    print(err)
                }
            }
        }
        
        
        queue.async {
            self.semaphore.wait()
            self.tvShowFetch.fetchMovies(from: .id("\(self.show!.id)"), afterID: "/similar") { (similarShowsResult: Result<TVShows, Error>) in
                switch similarShowsResult {
                case .success(let similars):
                    self.tvShows = similars
//                    print(similars)
                    print("2 - fetched silimar of random top rated film ")
                    self.semaphore.signal()
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        
        
        queue.async {
            self.semaphore.wait()
            self.tvShowFetch.fetchMovies(from: .id("\(self.tvShows!.results.randomElement()!.id)"), afterID: nil) { (detailsResponse: Result<TVShowDetails, Error>) in
                switch detailsResponse {
                case .success(let details):
                    print("3 - details of random tvshow from top rated film similars ")
//                    print(details)
                    self.semaphore.signal()
                case .failure(let err):
                    print(err)
                }
            }
        }
        
        
        
    }
    
    
    // nasted completions
//    func way1() {
//        queue.async {
//            TVShowFetch.shared.fetchMovies(from: .topRated, afterID: nil) { (result: Result<TVShows, Error>) in
//                switch result {
//                case .success(let success):
//                    let topRatedShow = success.results.randomElement()
//                    if let topRatedShow = topRatedShow {
////                        print(topRatedShow)
//
//                        TVShowFetch.shared.fetchMovies(from: .id("\(topRatedShow.id)"), afterID: "/similar") { (similarShowsResult: Result<TVShows, Error>) in
//                            switch similarShowsResult {
//                            case .success(let similars):
////                                print(similars)
//                                TVShowFetch.shared.fetchMovies(from: .id("\(similars.results.randomElement()!.id)"), afterID: nil) { (detailsResponse: Result<TVShowDetails, Error>) in
//                                    switch detailsResponse {
//                                    case .success(let success):
//                                        print(success)
//                                    case .failure(let err):
//                                        print(err)
//                                    }
//                                }
//
//                            case .failure(let failure):
//                                print(failure)
//                            }
//                        }
//                    }
//                case .failure(let failure):
//                    print(failure)
//                }
//            }
//        }
//    }
    
    
    
    
   
    
    
    
}

