//
//  ItemsViewController.swift
//  Atta2_app
//
//  Created by 松尾有紗 on 2021/11/27.
//

import UIKit

class ItemsViewController: UIViewController {
    @IBOutlet weak var itemsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemTableView.dataSource = self
    }
    
}

extension ViewController: UITableViewDataSource {
    //セクションの中に表示するセルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  items.count
    }
    //セルを生成(インスタンス化)して、そのLabelに検索結果の記事のタイトルを表示
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        print(type(of: categories))
        print(categories)
        var content = cell.defaultContentConfiguration()
        content.text = String(items[indexPath.row].id) + " | " + categories[indexPath.row].name + " | " + items[indexPath.row].lost_desc + " | " + items[indexPath.row].feature
        cell.contentConfiguration = content
        return cell
    }
    //セクションの数を設定
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
