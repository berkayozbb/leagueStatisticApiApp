//
//  GoalKingVC.swift
//  LeagueStatistics
//
//  Created by Berkay Özbaba on 29.09.2023.
//

import UIKit

class GoalKingVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "goalKingCell", for: indexPath) as! GoalKingTableViewCell
        cell.goalsLabel.text = goalsList[indexPath.row]
        cell.nameLabel.text = nameList[indexPath.row]
        return cell
    }
    
    var leagueKey = ""
    var leagueName = ""
    

    var playsList = [String]()
    var nameList = [String]()
    var goalsList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let navigationBar = self.navigationController?.navigationBar {
            let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: navigationBar.frame.size.width, height: navigationBar.frame.size.height))
            titleLabel.text = leagueName
            titleLabel.textAlignment = .center
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "Helvetica-Bold", size: 18.0)!, // Font ve boyut
                .foregroundColor: UIColor.red, // Renk
            ]
            
            let attributedTitle = NSAttributedString(string: titleLabel.text ?? "", attributes: attributes)
            titleLabel.attributedText = attributedTitle
            
            navigationItem.titleView = titleLabel
        }
        
        getGoalKingData()
        
    }
  
    
    func getGoalKingData(){
        
        let headers = [
          "content-type": "application/json",
          "authorization": "apikey 2oZi3fUZNhPg9o71hJjaRG:4nbmKoToUS37HTJQaJLgUQ"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://api.collectapi.com/sport/goalKings?data.league=\(leagueKey)")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
          if (error != nil) {
              print(error as Any)
          } else {
            let httpResponse = response as? HTTPURLResponse
              if let data = data {
                  do {
                      if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                          if let resultsJSON = json["result"] as? [[String: Any]]{
                              for item in resultsJSON {
                                  if let play = item["play"] as? String{
                                      self.playsList.append(play)
                                  }
                                  if let goals = item["goals"] as? String{
                                      self.goalsList.append(goals)
                                  }
                                  if let name = item["name"] as? String{
                                      self.nameList.append(name)
                                  }
                              }
                              DispatchQueue.main.async {
                                     self.tableView.reloadData()
                                 }
                          }
                          print(self.nameList)
                      }
                  } catch {
                      print("JSON çevrim hatası: \(error)")
                  }
              }
          }
        })

        dataTask.resume()
    }
    
}
