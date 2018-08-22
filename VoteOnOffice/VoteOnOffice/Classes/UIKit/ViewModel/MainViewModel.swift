//
//  MainViewModel.swift
//  VoteOnOffice
//
//  Created by New on 22.08.2018.
//  Copyright © 2018 Heads and Hands. All rights reserved.
//
import FirebaseFirestore
import FirebaseAuth
import RxSwift
import RxCocoa


class MainViewModel {
    
    var signOutBool = PublishSubject<Bool>()
    var adminStatus = PublishSubject<Bool>()
    var items = PublishSubject<[DataVoteCell]>()
    private let mainModel: MainModel = MainModel()
    private let emailString: String! = Auth.auth().currentUser?.email
    private var itemsDtc: [DataVoteCell] = []
    
    func signOut() {
        mainModel.deleteRealmData()
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            signOutBool.onNext(true)
        } catch let signOutError as NSError {
            signOutBool.onNext(false)
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func readDataBase() {
        let databaseFirestore = Firestore.firestore()
        databaseFirestore.collection("Votes").getDocuments { snapshot, error in
            guard error == nil else {
                print(error as Any)
                return
            }
            guard let requestSnapshot = snapshot?.documents else {
                fatalError("request snapshot Error")
            }
            for documents in requestSnapshot {
                var dtc: DataVoteCell = self.mainModel.dataVoteInit(documents: documents)
                let request = databaseFirestore.collection("Users").whereField("userEmail", isEqualTo: self.emailString)
                request.getDocuments { snapshot, error in
                    guard error == nil else {
                        print(error ?? Error.self)
                        return
                    }
                    guard let requestSnapshot = snapshot?.documents else {
                        fatalError("request snapshot Error")
                    }
                    for documents in requestSnapshot {
                        guard let status: Bool = documents.data()["userRole"] as? Bool else {
                            fatalError("Error admin status")
                        }
                        self.adminStatus.onNext(status)
                        guard let arrays: [[String: Any]] = documents.data()["userVotesList"] as?[[String: Any]] else {
                            fatalError("Error convert array")
                        }
                        let even = arrays.filter {
                            $0["voteUUID"] as? String == dtc.UUID
                        }
                        if !even.isEmpty {
                            dtc.status = true
                        }
                        self.itemsDtc.append(dtc)
                        self.items.onNext(self.itemsDtc)
                    }
                }
            }
        }
    }
    
    func itemsDeleteAll(){
        itemsDtc.removeAll()
        self.items.onNext(itemsDtc)
    }
    
    func itemsDelete(index: Int) {
        let databaseFirestore = Firestore.firestore()
        databaseFirestore.collection("Votes").document(itemsDtc[index].UUID).delete { error in
            guard error == nil else {
                print (error ?? Error.self)
                return
            }
            self.itemsDtc.remove(at: index)
            self.items.onNext(self.itemsDtc)
        }
    }
    
}
