//
//  MainView.swift
//  VoteOnOffice
//
//  Created by Admin on 27.06.2018.
//  Copyright © 2018 Heads and Hands. All rights reserved.
//

import FirebaseAuth
import FirebaseFirestore
import RealmSwift
import RxSwift
import RxCocoa
import UIKit

class MainView: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet private weak var btnSignOut: UIButton!
    @IBOutlet private weak var btnAdd: UIButton!
    @IBOutlet private weak var tableView: UITableView!

    var signOutBool = Variable<Bool>(false)
    var items = Variable<[DataVoteCell]>([])
    var adminStatus = Variable<Bool>(false)
    
    //var items: [DataVoteCell] = []
    var selectRow: String!
    
    let mainViewModel: MainViewModel = MainViewModel()
    let disposeBag = DisposeBag()

    @IBAction private func signOut(_ sender: Any) {
        mainViewModel.signOut()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        btnAdd.layer.cornerRadius = btnAdd.frame.size.height/2
        btnSignOut.layer.cornerRadius = btnSignOut.frame.size.height/2
        signOutBool.asObservable().subscribe() { _ in
            if self.signOutBool.value {
                self.performSegue(withIdentifier: "ReturnOnFirstView", sender: self)
            }
            }.disposed(by: disposeBag)
        mainViewModel.signOutBool.asObservable().bind(to: signOutBool).disposed(by: disposeBag)
        
        items.asObservable().subscribe() { _ in
            self.tableView.reloadData()
            }.disposed(by: disposeBag)
        mainViewModel.items.asObservable().bind(to: items).disposed(by: disposeBag)
        
        adminStatus.asObservable().subscribe() { _ in
            if self.adminStatus.value {
                self.btnAdd.isHidden = false
            } else {
                self.btnAdd.isHidden = true
            }
            }.disposed(by: disposeBag)
        mainViewModel.adminStatus.asObservable().bind(to: adminStatus).disposed(by: disposeBag)
        
        mainViewModel.readDataBase()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        mainViewModel.itemsDeleteAll()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.value.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: MyCell = tableView.dequeueReusableCell(withIdentifier: "cell") as? MyCell else {
            fatalError("Error Cell convert")
        }
        if items.value[indexPath.row].status {
            cell.statusSet(value: "V", color: UIColor.green)
        } else {
            cell.statusSet(value: "X", color: UIColor.red)
        }
        cell.timeSet(value: items.value[indexPath.row].time)
        cell.titleSet(value: items.value[indexPath.row].title)
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if adminStatus.value {
            if editingStyle == .delete {
                self.mainViewModel.itemsDelete(index: indexPath.row)
                tableView.reloadData()
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectRow = self.items.value[indexPath.row].UUID
        performSegue(withIdentifier: "VoteView", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? VoteView {
            viewController.UUID = selectRow
            print( viewController.UUID)
        }
    }
}
