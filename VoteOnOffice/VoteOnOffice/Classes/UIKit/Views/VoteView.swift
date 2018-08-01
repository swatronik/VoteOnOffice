//
//  VoteView.swift
//  VoteOnOffice
//
//  Created by Admin on 09.07.2018.
//  Copyright © 2018 Heads and Hands. All rights reserved.
//

import Charts
import FirebaseAuth
import FirebaseFirestore
import UIKit

class VoteView: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UITextView!
    @IBOutlet private weak var pieChart: PieChartView!

    var UUID: String!
    var arr: [[String: Any]] = []
    var selectRow: Int = -1
    var emailString: String! = Auth.auth().currentUser?.email

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadViewData()
    }

    func reloadViewData() {
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
                        let even = arrays.filter { $0["voteUUID"] as? String == self.UUID
                        }
                        if !even.isEmpty {
                            guard let evenFirst = even.first?["voteVariantID"] as? Int else {
                                fatalError("Even first is not be")
                            }
                            self.selectRow = evenFirst
                        }
                        self.tableView.reloadData()
                        self.pieChartUpdate()
                    }
                }
                self.titleLabel?.text = documents.data()["voteTitle"]as?String
                self.descriptionLabel?.text = documents.data()["voteDescription"]as?String
                guard let arrVariants: [[String: Any]] = documents.data()["voteVariants"]as?[[String: Any]] else {
                    fatalError("Error in a reload data")
                }
                self.arr = arrVariants
                self.tableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func pieChartUpdate() {
        var arrEntry: [PieChartDataEntry] = []
        for ind in 0..<arr.count {
            if let valueChartData: Double = arr[ind]["variantVoteStatus"] as? Double {
                let entry = PieChartDataEntry(value: valueChartData, label: "#"+String(ind + 1))
                arrEntry.append(entry)
            }
        }
        let dataSet = PieChartDataSet(values: arrEntry, label: "")
        dataSet.colors = ChartColorTemplates.joyful()
        dataSet.entryLabelColor = UIColor.black
        dataSet.valueTextColor = UIColor.black
        let data = PieChartData(dataSet: dataSet)
        pieChart.data = data
        pieChart.chartDescription?.text = ""
        pieChart.notifyDataSetChanged()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: VoteCell = (tableView.dequeueReusableCell(withIdentifier: "cell") as? VoteCell) else {
            fatalError("Error Cell convert")
        }
        guard let titleCell: String = arr[indexPath.row]["variantName"] as? String else {
            fatalError("Error title convert")
        }
        cell.titleSet(value: titleCell)
        if indexPath.row == selectRow {
            cell.backgroundColor = UIColor.green
            } else {
            cell.backgroundColor = UIColor.gray
        }
        return cell
    }

    func voteFirst(arrays: [[String: Any]], index: Int) {
        let databaseFirestore = Firestore.firestore()
        var arraysDB = arrays
        arraysDB.append(["voteUUID": self.UUID, "voteVariantID": index])
        databaseFirestore.collection("Users").document(self.emailString).updateData(["userVotesList": arrays])
        self.viewWillAppear(true)
        databaseFirestore.collection("Votes").whereField("voteUUID", isEqualTo: self.UUID).getDocuments { snapshot, error in
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
                databaseFirestore.collection("Votes").document(self.UUID).updateData(["voteVariants": array])
                self.reloadViewData()
            }
        }
    }

    func voteSecond(arrays: [[String: Any]], index: Int, extraIndex: Int) {
        let databaseFirestore = Firestore.firestore()
        databaseFirestore.collection("Votes").whereField("voteUUID", isEqualTo: self.UUID).getDocuments { snapshot, error in
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
                    $0["voteUUID"] as? String != self.UUID
                }
                even.append(["voteUUID": self.UUID, "voteVariantID": index])
                databaseFirestore.collection("Votes").document(self.UUID).updateData(["voteVariants": array])
                databaseFirestore.collection("Users").document(self.emailString).updateData(["userVotesList": even])
            }
            self.reloadViewData()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
                let even = arrays.filter { $0["voteUUID"] as? String == self.UUID }
                if even.isEmpty {
                    self.voteFirst(arrays: arrays, index: indexPath.row)
                } else {
                    guard let evenFirst = even.first else {
                        fatalError("Even first is not be")
                    }
                    guard let select: Int = evenFirst["voteVariantID"] as? Int else {
                        fatalError("Error select row")
                    }
                    self.voteSecond(arrays: arrays, index: indexPath.row, extraIndex: select)
                }
            }
        }
    }
}
