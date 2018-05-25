//
//  Networking.swift
//  BSC
//
//  Created by Marek Pridal on 25.05.18.
//  Copyright © 2018 Marek Pridal. All rights reserved.
//

import Foundation
import RxSwift

struct Networkig {
    func getNotes() -> Observable<[NoteTO]> {
        return Observable<[NoteTO]>.create({
            observer in
            let url = URL(string: "https://private-anon-b8bab08cff-note10.apiary-mock.com/notes")!
            
            let request = URLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if (response as? HTTPURLResponse)?.statusCode == 200, let data = data {
                    do {
                        let responseObject = try JSONDecoder().decode([NoteTO].self, from: data)
                        observer.onNext(responseObject)
                    } catch let e {
                        observer.onError(e)
                    }
                } else if let error = error {
                    observer.onError(error)
                } else {
                    observer.onCompleted()
                }
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        })
    }
    
    func post(note:NoteTO) -> Observable<NoteTO> {
        return Observable<NoteTO>.create({
            observer in
            
            let url = URL(string: "https://private-anon-b8bab08cff-note10.apiary-mock.com/notes")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            do {
                request.httpBody = try JSONEncoder().encode(note)
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    if (response as? HTTPURLResponse)?.statusCode == 201, let data = data {
                        do {
                            let responseObject = try JSONDecoder().decode(NoteTO.self, from: data)
                            observer.onNext(responseObject)
                        } catch let e {
                            observer.onError(e)
                        }
                    } else if let error = error {
                        observer.onError(error)
                    } else {
                        observer.onCompleted()
                    }
                }
                task.resume()
                
                return Disposables.create {
                    task.cancel()
                }
            }catch let error {
                observer.onError(error)
            }
            return Disposables.create()
        })
    }
    
    func update(note:NoteTO) -> Observable<NoteTO> {
        return Observable<NoteTO>.create({
            observer in
            
            let url = URL(string: "https://private-anon-b8bab08cff-note10.apiary-mock.com/notes/\(note.id!)")!
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            do {
                request.httpBody = try JSONEncoder().encode(note)
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    if (response as? HTTPURLResponse)?.statusCode == 201, let data = data {
                        do {
                            let responseObject = try JSONDecoder().decode(NoteTO.self, from: data)
                            observer.onNext(responseObject)
                        } catch let e {
                            observer.onError(e)
                        }
                    } else if let error = error {
                        observer.onError(error)
                    } else {
                        observer.onCompleted()
                    }
                }
                task.resume()
                
                return Disposables.create {
                    task.cancel()
                }
            }catch let error {
                observer.onError(error)
            }
            return Disposables.create()
        })
    }
    
    func remove(note:NoteTO) -> Observable<Bool> {
        return Observable<Bool>.create({
            observer in
            
            let url = URL(string: "https://private-anon-b8bab08cff-note10.apiary-mock.com/notes/\(note.id!)")!
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            
            let task = URLSession.shared.dataTask(with: request) { _, response, error in
                if (response as? HTTPURLResponse)?.statusCode == 204 {
                    observer.onNext(true)
                } else if let error = error {
                    observer.onError(error)
                } else {
                    observer.onCompleted()
                }
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        })
    }
}
