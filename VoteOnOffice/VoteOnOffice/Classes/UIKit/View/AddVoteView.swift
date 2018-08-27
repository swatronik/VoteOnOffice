//
//  AddVoteView.swift
//  VoteOnOffice
//
//  Created by Admin on 03.07.2018.
//  Copyright © 2018 Heads and Hands. All rights reserved.
//

import FirebaseFirestore
import RxSwift
import RxCocoa
import UIKit

class AddVoteView: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet private weak var btnAdd: UIButton!
    @IBOutlet private weak var descriptionLabel: UITextView!
    @IBOutlet private weak var tableViewApp: UITableView!
    @IBOutlet private weak var titleLabel: UITextField!
    
    let addVoteViewModel: AddVoteViewModel = AddVoteViewModel()
    let disposeBag = DisposeBag()
    var items = Variable<[Int]>([])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnAdd.layer.cornerRadius = btnAdd.frame.size.height/2
        items.asObservable().subscribe() { _ in
            self.tableViewApp.reloadData()
            }.disposed(by: disposeBag)
        addVoteViewModel.itemsObs.asObservable().bind(to: items).disposed(by: disposeBag)
        //self.tableViewApp.register(AddVoteCell.self, forCellReuseIdentifier: "voteCell")
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction private func addNewVarible(_ sender: Any) {
        addVoteViewModel.addNewVarible()
        tableViewApp.reloadData()
    }



    @IBAction private func addNewVote(_ sender: Any) {
        guard let title = titleLabel.text else {
            print ("Title is not fill")
            return
        }
        addVoteViewModel.addNewVote(title: title, description: descriptionLabel.text, table: tableViewApp)
        navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableViewApp: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.value.count
    }

    public func tableView(_ tableViewApp: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: AddVoteCell = (tableViewApp.dequeueReusableCell(withIdentifier: "voteCell") as? AddVoteCell) else {
            fatalError("Error Cell convert")
        }
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            addVoteViewModel.deleteRow(index: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .middle)
            tableView.endUpdates()
        }
    }

    func tableView(_ tableViewApp: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
