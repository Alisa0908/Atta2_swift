//
//  ItemsViewController.swift
//  Atta2_app
//
//  Created by 松尾有紗 on 2021/11/27.
//

import UIKit
import Alamofire
import SwiftyJSON

class ItemsViewController: UIViewController {
    let consts = Constants.shared
    @IBOutlet weak var itemsTable: UITableView!
    var searches: [Search] = []
    var categories: [Category] = []
    let headers: HTTPHeaders = [
        "Content-Type": "application/json",
        "ACCEPT": "application/json"
    ]
    var results2: [Search] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemsTable.dataSource = self
        itemsTable.delegate = self
        loadCategories()
    }
    
    func loadCategories() {
        let catStr = "\(consts.baseUrl)/api/categories"
        let catUrl = URL(string: catStr)!
        AF.request(catUrl, method: .get, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                self.categories = []
                let json = JSON(value).arrayValue
                
                for categories in json {
                    let category = Category(id: categories["id"].int!, name: categories["name"].string!)
                    self.categories.append(category)
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
        itemsTable.reloadData()
    }
    
}

extension ItemsViewController: UITableViewDataSource {
    
     //セクションの中に表示するセルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  results2.count
    }
    //セルを生成(インスタンス化)して、そのLabelに検索結果の記事のタイトルを表示
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemsCell", for: indexPath)
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension

        let label1 = cell.viewWithTag(1) as! UILabel
        let label2 = cell.viewWithTag(2) as! UILabel
        let label3 = cell.viewWithTag(3) as! UILabel
        
        label1.text = categories[results2[indexPath.row].category_id].name
        label2.text = results2[indexPath.row].lost_desc
        label3.text = results2[indexPath.row].feature

        return cell
    }
    //セクションの数を設定
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}

extension ItemsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let showVC = self.storyboard?.instantiateViewController(withIdentifier: "showVC") as! ShowViewController
        showVC.user_id = results2[indexPath.row].user_id
        
        self.present(showVC,animated: true)
    }
}
