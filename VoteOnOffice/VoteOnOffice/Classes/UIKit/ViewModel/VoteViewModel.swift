//
//  VoteViewModel.swift
//  VoteOnOffice
//
//  Created by New on 27.08.2018.
//  Copyright © 2018 Heads and Hands. All rights reserved.
//

import FirebaseFirestore
import FirebaseAuth
import RxSwift
import RxCocoa

class VoteViewModel {
    
    var emailString: String! = Auth.auth().currentUser?.email
    var arr = PublishSubject<[[String: Any]]>()
    var selectRow = PublishSubject<Int>()
    var titleString = PublishSubject<String>()
    var descriptionString = PublishSubject<String>()
    
    
    func reloadViewData(UUID: String) {
        let databaseFirestore = Firestore.firestore()
        databaseFirestore.collection("Votes").whereField("voteUUID", isEqualTo: UUID).getDocuments { snapshot, error in
            guard error == nil else {
                print(error as Any)
                return
            }
            guard let requestSnapshot = snapshot?.documents else {
                fatalError("request snapshot Error")
            }
            for documents in requestSnapshot {
                databaseFirestore.collection("Users").whereField("userEmail", isEqualTo: self.emailString).getDocuments { snapshot, error in
                    if let error = error {
                        print(error)
                        return
                    }
                    guard let requestSnapshot = snapshot?.documents else {
                        fatalError("request snapshot Error")
                    }
                    for documents in requestSnapshot {
                        guard let arrays: [[String: Any]] = documents.data()["userVotesList"] as? [[String: Any]] else {
                            fatalError("Error in a reload data")
                        }
                        let even = arrays.filter { $0["voteUUID"] as? String == UUID
                        }
                        if !even.isEmpty {
                            guard let evenFirst = even.first?["voteVariantID"] as? Int else {
                                fatalError("Even first is not be")
                            }
                            self.selectRow.onNext(evenFirst)
                        }
                    }
                }
                var str: String! = documents.data()["voteTitle"]as?String
                self.titleString.onNext(str)
                str = documents.data()["voteDescription"]as?String
                self.descriptionString.onNext(str)
                guard let arrVariants: [[String: Any]] = documents.data()["voteVariants"]as?[[String: Any]] else {
                    fatalError("Error in a reload data")
                }
                self.arr.onNext(arrVariants)
            }
        }
    }
    
    func voteFirst(arrays: [[String: Any]], index: Int, UUID: String) {
        let databaseFirestore = Firestore.firestore()
        var arraysDB = arrays
        arraysDB.append(["voteUUID": UUID, "voteVariantID": index])
        databaseFirestore.collection("Users").document(self.emailString).updateData(["userVotesList": arraysDB])
        databaseFirestore.collection("Votes").whereField("voteUUID", isEqualTo: UUID).getDocuments { snapshot, error in
            guard error == nil else {
                print(error ?? Error.self)
                return
            }
            guard let requestSnapshot = snapshot?.documents else {
                fatalError("request snapshot Error")
            }
            for documents in requestSnapshot {
                guard var array: [[String: Any]] = documents.data()["voteVariants"]as?[[String: Any]] else {
                    fatalError("VoteFirst Error")
                }
                guard let mutationValue: Int = array[index]["variantVoteStatus"] as? Int else {
                    fatalError("Error covernant voteFirst value")
                }
                array[index]["variantVoteStatus"] = mutationValue + 1
                databaseFirestore.collection("Votes").document(UUID).updateData(["voteVariants": array])
            }
            self.selectRow.onNext(index)
        }
    }
    
    func voteSecond(arrays: [[String: Any]], index: Int, extraIndex: Int, UUID: String) {
        let databaseFirestore = Firestore.firestore()
        databaseFirestore.collection("Votes").whereField("voteUUID", isEqualTo: UUID).getDocuments { snapshot, error in
            guard error == nil else {
                print(error ?? Error.self)
                return
            }
            guard let requestSnapshot = snapshot?.documents else {
                fatalError("request snapshot Error")
            }
            for documents in requestSnapshot {
                guard var array: [[String: Any]] = documents.data()["voteVariants"]as?[[String: Any]] else {
                    fatalError("Error in a voteSecond")
                }
                guard let mutationValue1: Int = array[extraIndex]["variantVoteStatus"] as? Int else {
                    fatalError("Error covernant voteSecond value")
                }
                array[extraIndex]["variantVoteStatus"] = mutationValue1 - 1
                guard let mutationValue2: Int = array[extraIndex]["variantVoteStatus"] as? Int else {
                    fatalError("Error covernant voteSecond value")
                }
                array[index]["variantVoteStatus"] = mutationValue2 + 1
                var even = arrays.filter {
                    $0["voteUUID"] as? String != UUID
                }
                even.append(["voteUUID": UUID, "voteVariantID": index])
                databaseFirestore.collection("Votes").document(UUID).updateData(["voteVariants": array])
                databaseFirestore.collection("Users").document(self.emailString).updateData(["userVotesList": even])
            }
            self.selectRow.onNext(index)
        }
    }
    
    func tabOnCell(index: Int, UUID: String){
        let databaseFirestore = Firestore.firestore()
        databaseFirestore.collection("Users").whereField("userEmail", isEqualTo: emailString).getDocuments { snapshot, error in
            guard error == nil else {
                print("Error: ", error as Any)
                return
            }
            guard let requestSnapshot = snapshot?.documents else {
                fatalError("request snapshot Error")
            }
            for documents in requestSnapshot {
                guard let arrays: [[String: Any]] = documents.data()["userVotesList"] as? [[String: Any]] else {
                    fatalError("Error covernant array")
                }
                let even = arrays.filter { $0["voteUUID"] as? String == UUID }
                if even.isEmpty {
                    self.voteFirst(arrays: arrays, index: index, UUID: UUID)
                } else {
                    guard let evenFirst = even.first else {
                        fatalError("Even first is not be")
                    }
                    guard let select: Int = evenFirst["voteVariantID"] as? Int else {
                        fatalError("Error select row")
                    }
                    self.voteSecond(arrays: arrays, index: index, extraIndex: select, UUID: UUID)
                }
            }
        }
    }
}
