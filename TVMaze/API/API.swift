import Foundation

class API {
    static func topSerieIds(completion: @escaping ([Serie], Error?)->()) -> URLSessionDataTask {
        let url = URL(string: "https://api.tvmaze.com/shows")!
        return URLSession.shared.dataTask(with: url) { (data, response, error) in
            let decoder = JSONDecoder()
            
            if let data = data ,
                let serie = try? decoder.decode([Serie].self, from: data){
                completion(serie, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    static func serie(id: Int, completion: @escaping (Serie?, Error?)->()) -> URLSessionDataTask {
        let url = URL(string: "https://api.tvmaze.com/shows/\(id)")!
        return URLSession.shared.dataTask(with: url) { (data, response, error) in
            let decoder = JSONDecoder()
            
            if let data = data {
                let serie = try? decoder.decode(Serie.self, from: data)
                completion(serie, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    static func topSeries(completion: @escaping ([Serie], Error?)->()) -> URLSessionDataTask {
        return topSerieIds { (series, error) in
            if let error = error {
                completion([], error)
                return
            }

            let ids = series.map({ (serie: Serie) -> Int in
                return serie.id
            })
            
            var tasks: [URLSessionDataTask]!
            var results = [Int: Serie?]()
            
            let areTasksRunning = { () -> Bool in
                return tasks.contains(where: { (task) -> Bool in
                    task.state == URLSessionTask.State.running
                })
            }
            
            let successFetchingStory = { (id: Int, serie: Serie) in
                results[id] = serie
                
                if !areTasksRunning() {
                    let result = ids.compactMap({ (id: Int) -> Serie? in
                        return results[id] ?? nil
                    })
                    
                    completion(result, nil)
                }
            }
            
            let errorFetchingStory = { (error: Error) in
                print(error)
            }
            
            tasks = ids.map({ (serieId) -> URLSessionDataTask in
                serie(id: serieId, completion: { (serie, error) in
                    if let error = error {
                        errorFetchingStory(error)
                    }
                    
                    if let serie = serie {
                        successFetchingStory(serieId, serie)
                    }
                })
            })
            
            tasks.forEach { $0.resume() }
            
        }
    }
    
    static func episode(id: Int, completion: @escaping ([Episode]?, Error?)->()) -> URLSessionDataTask {
        let url = URL(string:"https://api.tvmaze.com/shows/\(id)/episodes")!
        return URLSession.shared.dataTask(with: url) { (data, response, error) in
            let decoder = JSONDecoder()
            
            if let data = data {
                let episode = try? decoder.decode([Episode].self, from: data)
                completion(episode, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    static func casting(id: Int, completion: @escaping ([Casting]?, Error?)->()) -> URLSessionDataTask {
        let url = URL(string:"https://api.tvmaze.com/shows/\(id)/cast")!
        return URLSession.shared.dataTask(with: url) { (data, response, error) in
            let decoder = JSONDecoder()
            
            if let data = data {
                let casting = try? decoder.decode([Casting].self, from: data)
                completion(casting, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
}


