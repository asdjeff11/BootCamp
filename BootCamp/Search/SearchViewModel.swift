//
//  SearchViewModel.swift
//  BootCamp
//
//  Created by esb23904 on 2023/10/12.
//

import Foundation
import UIKit
import Alamofire
class SearchViewModel {
    enum CustomError:Error {
        case urlError
        case responseError
    }
    var movies = [SearchModel]()
    var music = [SearchModel]()
//    private final let limit = 20 // 一次撈取的數量
//    private var movie_offset = 1 // movie 下次要撈取時起始位置
//    private var music_offset = 1 // music 下次要撈取時起始位置
    
    func fetch(_ keyword:String,callBack:@escaping ((_:String)->())) {
        DispatchQueue.global(qos: .background).async {
            var errorMsg = ""
            let group = DispatchGroup()
            // fetch
            var movieCondition = SearchITuneCondition(term:keyword,media: .電影)
            group.enter()
            self.fetchURLData(url_Str: movieCondition.getUrl(), finishCallBack:{ (result:Result<ITuneResult,Error>) in
                switch ( result ) {
                case .success(let datas) :
                    self.movies = datas.results.map({ SearchModel(detail: $0) })
                case .failure(let error) :
                    errorMsg += error.localizedDescription
                }
                group.leave()
            })
            
            movieCondition.media = .音樂
            group.enter()
            self.fetchURLData(url_Str: movieCondition.getUrl(), finishCallBack:{ (result:Result<ITuneResult,Error>) in
                switch ( result ) {
                case .success(let datas) :
                    self.music = datas.results.map({ SearchModel(detail: $0) })
                case .failure(let error) :
                    errorMsg += error.localizedDescription
                }
                group.leave()
            })
            
            group.wait()
            DispatchQueue.main.async {
                callBack(errorMsg)
            }
        }
    }
    
    func fetchURLData<T:Codable>(url_Str:String,finishCallBack: @escaping(Result<T,Error>)->Void) {
        AF.request(url_Str).responseDecodable(of: T.self) { response in
            switch ( response.result ) {
            case .success(let data):
                //guard let data = data as? T else { finishCallBack(.failure(CustomError.responseError)) ; return }
                finishCallBack(.success(data))
            case .failure(let error) :
                finishCallBack(.failure(error))
            }
        }
    }
}

extension SearchViewModel {
    func setFolder(indexPath:IndexPath) {
        if ( indexPath.section == 0 ) {
            self.movies[indexPath.row].isFolder = !self.movies[indexPath.row].isFolder
        }
        else {
            self.music[indexPath.row].isFolder = !self.music[indexPath.row].isFolder
        }
    }
    
    func setCollect(indexPath:IndexPath) {
        if ( indexPath.section == 0 ) {
            self.movies[indexPath.row].isCollect = !self.movies[indexPath.row].isCollect
        }
        else {
            self.music[indexPath.row].isCollect = !self.music[indexPath.row].isCollect
        }
    }
}

extension SearchViewModel {
    func getMusicSize()->Int {
        music.count
    }
    
    func getMovieSize()->Int {
        movies.count
    }
    
    func getData(indexPath:IndexPath)->SearchModel {
        if ( indexPath.section == 0 ) { // movie
            return movies[indexPath.row]
        }
        else { // music
            return music[indexPath.row]
        }
    }
}
