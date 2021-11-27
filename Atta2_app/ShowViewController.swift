//
//  ShowViewController.swift
//  Atta2_app
//
//  Created by 松尾有紗 on 2021/11/27.
//

import UIKit
import Alamofire
import SwiftyJSON

class ShowViewController: UIViewController {
    
    let consts = Constants.shared
    var user: User!
    let headers: HTTPHeaders = [
        "Content-Type": "application/json",
        "ACCEPT": "application/json"
    ]
    var user_id: Int!

    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var telLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUsers()
       
    }
    
    func loadUsers() {
        let userStr = "\(consts.baseUrl)/api/users/\(user_id!)"
        print(userStr)
        let userUrl = URL(string: userStr)!
        
        
        AF.request(userUrl, method: .get, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
//                self.users = []
                let json = JSON(value)
                print(json)
                self.user = User(name: json["name"].string!, tel: json["tel"].string!)
//                for user in json {
//                    let user = User(id: users["id"].int!, name: users["name"].string!, tel: users["tel"].string!)
//                    self.users.append(user)
//                    print(self.users)
//                }
                DispatchQueue.main.async {
                    self.placeLabel.text = self.user.name
                    self.telLabel.text = self.user.tel
                }
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
       
    }
    
    
    

}
