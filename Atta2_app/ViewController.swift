//
//  ViewController.swift
//  Atta2_app
//
//  Created by 松尾有紗 on 2021/11/25.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    let consts = Constants.shared
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var lostField: UITextField!
    @IBOutlet weak var featureField: UITextField!
    
    var categories: [Category] = []
    var items: [Item] = []
    var searches: [Search] = []
    var selectedId: Int!
    
    let headers: HTTPHeaders = [
        "Content-Type": "application/json",
        "ACCEPT": "application/json"
    ]
    
    // UIPickerViewの列の数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // UIPickerViewの行数、要素の全数
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    // UIPickerViewに表示する配列
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        
        return categories[row].name
    }
    
    // UIPickerViewのRowが選択された時の挙動
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        selectedId = categories[row].id
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        loadCategories()
//        loadItems(id: 35, category_id: 1, lost_desc: "盛岡駅", feature: "黒")
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toItems" {
//            let vc = segue.destination as! ItemsViewController
//            vc.results2 = searches
//        }
//        print(searches)
//    }
    
    @IBAction func searchBtn(_ sender: Any) {
        //        searchItems(category_id: 1, lost_desc: "盛岡駅", feature: "黒")
        searchItems(category_id: self.selectedId, lost_desc: (lostField.text)!, feature: (featureField.text)!)
        
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
                self.pickerView.reloadAllComponents()
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
        func loadItems(id: Int, category_id: Int, lost_desc: String, feature: String) {
            let itemStr = "\(consts.baseUrl)/api/items"
            let itemUrl = URL(string: itemStr)!
    
            AF.request(itemUrl, method: .get, headers: headers).responseJSON { response in
                switch response.result {
                case .success(let value):
                    self.items = []
                    let json = JSON(value).arrayValue
                    for items in json {
                        let item = Item(
                            id: items["id"].int!,
                            user_id: items["user_id"].int!,
                            category_id: items["category_id"].int!,
                            lost_desc: items["lost_desc"].string!,
                            feature: items["feature"].string!
                        )
                        print(item)
                        self.items.append(item)
                    }
//                    self.itemTableView.reloadData()
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }
        }
    
    func searchItems(category_id: Int, lost_desc: String, feature: String) {
        let searchStr = "\(consts.baseUrl)/api/items"
        
        let parameters: Parameters = [
            "category": category_id,
            "lost_desc": lost_desc,
            "feature": feature
        ]
        let searchUrl = URL(string: searchStr)!
        AF.request(searchUrl, method: .get,parameters: parameters, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                self.searches = []
                let json = JSON(value).arrayValue
                print(value)
                for searches in json {
                    let search = Search(
                        user_id: searches["user_id"].int!,
                        category_id: searches["category_id"].int!,
                        lost_desc: searches["lost_desc"].string!,
                        feature: searches["feature"].string!
                    )
                    self.searches.append(search)
                    
                }
                print("searches:",self.searches)
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ItemsVC") as! ItemsViewController
                vc.results2 = self.searches
                vc.categories = self.categories
                self.present(vc,animated: true)
//                                self.itemTableView.reloadData()
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    
}


//extension ViewController: UITableViewDataSource {
//    //セクションの中に表示するセルの数
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return  items.count
//    }
//    //セルを生成(インスタンス化)して、そのLabelに検索結果の記事のタイトルを表示
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
//        print(type(of: categories))
//        print(categories)
//        var content = cell.defaultContentConfiguration()
//        content.text = String(items[indexPath.row].id) + " | " + categories[indexPath.row].name + " | " + items[indexPath.row].lost_desc + " | " + items[indexPath.row].feature
//        cell.contentConfiguration = content
//        return cell
//    }
//    //セクションの数を設定
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//}





