//
//  VoteView.swift
//  VoteOnOffice
//
//  Created by Admin on 09.07.2018.
//  Copyright © 2018 Heads and Hands. All rights reserved.
//

import Charts
import RxSwift
import RxCocoa
import UIKit

class VoteView: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UITextView!
    @IBOutlet private weak var pieChart: PieChartView!

    var UUID: String!
    
    let disposeBag = DisposeBag()
    let voteViewModel: VoteViewModel = VoteViewModel()
    var selectRow = Variable<Int>(-1)
    var arr = Variable<[[String: Any]]>([])

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        voteViewModel.titleString.asObservable().bind(to: titleLabel.rx.text).disposed(by: disposeBag)
        voteViewModel.descriptionString.asObservable().bind(to: descriptionLabel.rx.text).disposed(by: disposeBag)
        selectRow.asObservable().subscribe() { _ in
            self.voteViewModel.reloadViewData(UUID: self.UUID)
            self.tableView.reloadData()
            self.pieChartUpdate()
            }.disposed(by: disposeBag)
        voteViewModel.selectRow.asObservable().bind(to: selectRow).disposed(by: disposeBag)
        
        arr.asObservable().subscribe() { _ in
            self.tableView.reloadData()
            self.pieChartUpdate()
            }.disposed(by: disposeBag)
        voteViewModel.arr.asObservable().bind(to: arr).disposed(by: disposeBag)
        
        voteViewModel.reloadViewData(UUID: UUID)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func pieChartUpdate() {
        var arrEntry: [PieChartDataEntry] = []
        for ind in 0..<arr.value.count {
            if let valueChartData: Double = arr.value[ind]["variantVoteStatus"] as? Double {
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
        return self.arr.value.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: VoteCell = (tableView.dequeueReusableCell(withIdentifier: "cell") as? VoteCell) else {
            fatalError("Error Cell convert")
        }
        guard let titleCell: String = arr.value[indexPath.row]["variantName"] as? String else {
            fatalError("Error title convert")
        }
        cell.titleSet(value: titleCell)
        if indexPath.row == selectRow.value {
            cell.backgroundColor = UIColor.green
            } else {
            cell.backgroundColor = UIColor.gray
        }
        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        voteViewModel.tabOnCell(index: indexPath.row, UUID: UUID)
        tableView.reloadData()
        pieChartUpdate()
    }
}
