//
//  Networking.swift
//  BSC
//
//  Created by Marek Pridal on 25.05.18.
//  Copyright © 2018 Marek Pridal. All rights reserved.
//

import Foundation
import RxSwift

final class Networking {
    private let endpoint = URL(string: "http://private-9aad-note10.apiary-mock.com/notes")!

    func getNotes() -> Observable<[Note]> {
        return Observable<[Note]>.create({ [weak self] observer in
            guard let self = self else {
                observer.onError(GeneralError())
                return Disposables.create()
            }

            let request = URLRequest(url: self.endpoint)

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if (response as? HTTPURLResponse)?.statusCode == 200, let data = data {
                    do {
                        let responseObject = try JSONDecoder().decode([Note].self, from: data)
                        observer.onNext(responseObject)
                    } catch let e {
                        observer.onError(e)
                    }
                } else if let error = error {
                    observer.onError(error)
                } else {
                    observer.onError(GeneralError())
                }
            }
            task.resume()

            return Disposables.create { task.cancel() }
        })
    }

    func post(note: Note) -> Observable<Note> {
        return Observable<Note>.create({ [weak self] observer in
            guard let self = self else {
                observer.onError(GeneralError())
                return Disposables.create()
            }

            var request = URLRequest(url: self.endpoint)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            do {
                request.httpBody = try JSONEncoder().encode(note)
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    if (response as? HTTPURLResponse)?.statusCode == 201, let data = data {
                        do {
                            let responseObject = try JSONDecoder().decode(Note.self, from: data)
                            observer.onNext(responseObject)
                        } catch let e {
                            observer.onError(e)
                        }
                    } else if let error = error {
                        observer.onError(error)
                    } else {
                        observer.onError(GeneralError())
                    }
                }
                task.resume()

                return Disposables.create {
                    task.cancel()
                }
            } catch let error {
                observer.onError(error)
            }
            return Disposables.create()
        })
    }

    func update(note: Note) -> Observable<Note> {
        return Observable<Note>.create({ [weak self] observer in
            guard let self = self, let noteId = note.id else {
                observer.onError(GeneralError())
                return Disposables.create()
            }

            var request = URLRequest(url: self.endpoint.appendingPathComponent("\(noteId)"))
            request.httpMethod = "PUT"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            do {
                request.httpBody = try JSONEncoder().encode(note)
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    if (response as? HTTPURLResponse)?.statusCode == 201, let data = data {
                        do {
                            let responseObject = try JSONDecoder().decode(Note.self, from: data)
                            observer.onNext(responseObject)
                        } catch let e {
                            observer.onError(e)
                        }
                    } else if let error = error {
                        observer.onError(error)
                    } else {
                        observer.onError(GeneralError())
                    }
                }
                task.resume()

                return Disposables.create {
                    task.cancel()
                }
            } catch let error {
                observer.onError(error)
            }
            return Disposables.create()
        })
    }

    func remove(note: Note) -> Observable<Bool> {
        return Observable<Bool>.create({ [weak self] observer in
            guard let self = self, let noteId = note.id else {
                observer.onError(GeneralError())
                return Disposables.create()
            }

            var request = URLRequest(url: self.endpoint.appendingPathComponent("\(noteId)"))
            request.httpMethod = "DELETE"

            let task = URLSession.shared.dataTask(with: request) { _, response, error in
                if (response as? HTTPURLResponse)?.statusCode == 204 {
                    observer.onNext(true)
                } else if let error = error {
                    observer.onError(error)
                } else {
                    observer.onError(GeneralError())
                }
            }
            task.resume()

            return Disposables.create {
                task.cancel()
            }
        })
    }
}
