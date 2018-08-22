//
//  AddVoteViewModel.swift
//  VoteOnOffice
//
//  Created by New on 22.08.2018.
//  Copyright © 2018 Heads and Hands. All rights reserved.
//

import FirebaseFirestore
import RxSwift
import RxCocoa

class AddVoteViewModel {
    
    private let addVoteModel: AddVoteModel = AddVoteModel()
    var itemsObs = PublishSubject<[Int]>()
    var items: [Int] = []
    
    func addNewVote(title: String, description: String, table: UITableView){
        let databaseFirestore = Firestore.firestore()
        let uuid = UUID().uuidString
        let docData: [String: Any] = [
            "voteDate": addVoteModel.nowTime(),
            "voteDescription": description,
            "voteStatus": false,
            "voteTitle": title,
            "voteUUID": uuid,
            "voteVariants": variantsArray(table: table)
        ]
        databaseFirestore.collection("Votes").document(uuid).setData(docData) { error in
            guard error == nil else {
                print(error ?? Error.self)
                return
            }
        }
        
    }
    
    func variantsArray(table: UITableView) -> [[String: Any]] {
        var ind = items.count - 1
        for _ in items {
            items[ind] = ind + 1
            ind -= 1
        }
        itemsObs.onNext(items)
        var array: [[String: Any]] = []
        for index in items {
            let indx = IndexPath(row: index - 1, section: 0)
            guard let cell: AddVoteCell = (table.cellForRow(at: indx) as? AddVoteCell) else {
                fatalError("Error Cell convert")
            }
            let variants: [String: Any] = [
                "variantId": items[index - 1],
                "variantImgURL": "",
                "variantName": cell.getText(),
                "variantVoteStatus": 0
            ]
            array.append(variants)
        }
        return array
    }
    
    func addNewVarible(){
        items.append(items.count + 1)
        itemsObs.onNext(items)
    }
    
    func deleteRow(index: Int){
        items.remove(at: index)
        itemsObs.onNext(items)
    }
    
}
