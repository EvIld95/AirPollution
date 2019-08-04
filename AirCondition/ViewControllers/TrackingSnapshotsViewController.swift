//
//  SnapshotsViewController.swift
//  AirCondition
//
//  Created by Paweł Szudrowicz on 23/06/2019.
//  Copyright © 2019 Paweł Szudrowicz. All rights reserved.
//

import UIKit
import RxSwift

class TrackingSnapshotsTableViewController: UITableViewController {
    
    var viewModel: TrackingHistoryViewModel!
    let disposeBag = DisposeBag()
    
    let cellId = "cellId"
    
    override func viewDidAppear(_ animated: Bool) {
        self.viewModel.getAllTrackingSnapshots(onError: {
            let alertController = UIAlertController(title: "Error", message: "Can't load tracking history, check internet connection", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tracking"
        self.tableView.register(SnapshotTableViewCell.self, forCellReuseIdentifier: cellId)
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundView = UIView.getGradientLayer(view: self.tableView)
        self.setupRx()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.output.trackingSnapshots.value.keys.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellId) as! SnapshotTableViewCell
        cell.backgroundColor = .clear
        let sortedKeys = self.viewModel.output.trackingSnapshots.value.keys.sorted()
        let id = sortedKeys[indexPath.row]
        cell.tag = id
        if let data = self.viewModel.output.trackingSnapshots.value[id]!.first {
            cell.data = data
            cell.dateLabel.text = String(data.createdOn!.split(separator: " ").first!)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: false)
        let cellAtIndexPath = self.tableView.cellForRow(at: indexPath) as! SnapshotTableViewCell
        self.viewModel.input.selectedSnapshots.value = self.viewModel.output.trackingSnapshots.value[cellAtIndexPath.tag]!
    }
    
    func setupRx() {
        self.viewModel.output.trackingSnapshots.asObservable().observeOn(MainScheduler.instance).subscribe(onNext: { _ in
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
    }
}
