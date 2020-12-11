//
//  FirestoreService+Benches.swift
//  iBench
//
//  Created by Андрей Журавлев on 04.12.2020.
//  Copyright © 2020 Андрей Журавлев. All rights reserved.
//

import Foundation
import Firebase

typealias BenchResultResposne = (Result<[BenchObject], NSError>) -> Void

protocol FirestoreBenchesServiceable {
//    var benches: Emitter<[BenchObject]> { get }
    func getBenchesListener(_ completion: @escaping BenchResultResposne) -> ListenerRegistration
}

extension FirestoreService: FirestoreBenchesServiceable {
    private var benchesReference: CollectionReference {
        firestore.collection(FirestorePathKeys.benches)
    }
    
    func getBenchesListener(_ completion: @escaping BenchResultResposne) -> ListenerRegistration {
        return benchesReference.addSnapshotListener { (snapshot, error) in
            if let error = error {
                completion(.failure(error as NSError))
                return
            }
            guard let snapshot = snapshot else {
                return
            }
            snapshot.documentChanges.forEach { (diff) in
                switch diff.type {
                    case .added:
                        print("ADDED BENCH")
                        let bench = BenchObject(document: diff.document)
                        print(bench ?? "Unable to parse")
                    case .modified:
                        print("MODIFIED BENCH")
                        let bench = BenchObject(document: diff.document)
                        print(bench ?? "Unable to parse")
                    case .removed:
                        print("REMOVED BENCH")
                        let bench = BenchObject(document: diff.document)
                        print(bench ?? "Unable to parse")
                }
            }
            let newBenches = snapshot.documents.compactMap(BenchObject.init(document:))
            completion(.success(newBenches))
        }
    }
    
    func addBench(_ bench: BenchObject, compleiton: @escaping ((NSError?) -> Void)) {
        benchesReference.addDocument(data: bench.dictionaryRepresentation) { (error) in
            if let error = error {
                compleiton(error as NSError?)
                return
            }
            compleiton(nil)
        }
    }
    
    func removeBench(_ bench: BenchObject, completion: @escaping ((NSError?) -> Void)) {
        let query = benchesReference.whereField("id", isEqualTo: bench.id)
        query.getDocuments { (snapshot, error) in
            if let error = error {
                completion(error as NSError?)
                return
            }
            guard let snapshot = snapshot else {
                completion(FirestoreError.benchNotFound("Could not find bench") as NSError)
                return
            }
            snapshot.documents.forEach { $0.reference.delete() }
        }
    }
    
    func updateBench(_ bench: BenchObject, completion: @escaping ((NSError?) -> Void)) {
        let query = benchesReference.whereField("id", isEqualTo: bench.id)
        query.getDocuments { (snapshot, error) in
            if let error = error {
                completion(error as NSError?)
                return
            }
            guard let snapshot = snapshot,
                  !snapshot.documents.isEmpty else {
                completion(FirestoreError.benchNotFound(bench.id) as NSError)
                return
            }
            guard snapshot.documents.count == 1,
                  let benchDocument = snapshot.documents.first else {
                completion(FirestoreError.tooManyBenches(bench.id) as NSError?)
            }
            benchDocument.reference.setData(bench.dictionaryRepresentation)
        }
    }
}
