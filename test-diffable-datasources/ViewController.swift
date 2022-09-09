//
//  ViewController.swift
//  test-diffable-datasources
//
//  Created by Athipat Nampetch on 9/9/2565 BE.
//

import UIKit
import DiffableDataSources

class ViewController: UIViewController {
    var tableViewDataSource: TableViewGroupDiffableDataSource!
    @IBOutlet weak var btUpdate: UIButton!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableViewDataSource = TableViewGroupDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, cellData in
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell
                cell.label.text = "\(cellData.id): \(cellData.name)"
                return cell
            })
        }
    }
    
    @IBAction func onTapped(_ sender: Any) {
        tableViewDataSource.applyNewSnapshot(sections: [
            [
                CellData(id: "A", name: "AB"),
                CellData(id: "B", name: "BA")
            ],
            [
                CellData(id: "C", name: "CC"),
                CellData(id: "D", name: "DD")
            ],
        ], hasMore: false, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewDataSource.applyNewSnapshot(sections: [
            [
                CellData(id: "A", name: "AA"),
                CellData(id: "B", name: "BB")
            ],
            [
                CellData(id: "C", name: "CC"),
                CellData(id: "D", name: "DD")
            ],
        ], hasMore: false, completion: nil)
    }


}

class Cell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
}

struct CellData: Hashable {
    let id: String
    let name: String
}

extension CellData {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

class TableViewGroupDiffableDataSource: TableViewDiffableDataSource<Int, CellData> {
    override init(
        tableView: UITableView,
        cellProvider: @escaping (UITableView, IndexPath, CellData) -> UITableViewCell?) {
        super.init(
            tableView: tableView,
            cellProvider: cellProvider)
    }
    
    func applyNewSnapshot(sections: [[CellData]], hasMore: Bool, completion: (() -> Void)?) {
        var newSnapshot = DiffableDataSourceSnapshot<Int, CellData>()
        
        newSnapshot.appendSections(Array(0..<sections.count))
        
        sections.enumerated().forEach() { idx, section in
            newSnapshot.appendItems(section, toSection: idx)
        }
        apply(newSnapshot, animatingDifferences: false, completion: completion)
    }
}


