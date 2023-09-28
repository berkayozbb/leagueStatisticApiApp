//
//  ViewController.swift
//  LeagueStatistics
//
//  Created by Berkay Özbaba on 27.09.2023.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var leagueList = [String]()
    var leagueKeyList = [String]()
    
    //açılış ekranı leagueList tableview
    @IBOutlet var leagueListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()   
        //test
//        leagueList.append("Trendyol Süper Lig")
//        leagueList.append("Trendyol 1. Lig")
//        leagueList.append("İngiltere Premier Ligi")
//        leagueList.append("UEFA Konferans Ligi")
//        leagueKeyList.append("super-lig")
//        leagueKeyList.append("tff-1-lig")
//        leagueKeyList.append("igiltere-premier-ligi")
//        leagueKeyList.append("uefa-konferans-ligi")
        
        //Sayfaya başlık ekleme
        if let navigationBar = self.navigationController?.navigationBar {
            let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: navigationBar.frame.size.width, height: navigationBar.frame.size.height))
            titleLabel.text = "berkaykolik"
            titleLabel.textAlignment = .center
            
            // Özelleştireceğiniz fontu ve diğer özellikleri ayarlayın
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "Helvetica-Bold", size: 20.0)!, // Font ve boyut
                .foregroundColor: UIColor.red, // Renk
            ]
            
            let attributedTitle = NSAttributedString(string: titleLabel.text ?? "", attributes: attributes)
            titleLabel.attributedText = attributedTitle
            
            // Başlık metnini Navigation Bar'a ekle
            navigationItem.titleView = titleLabel
        }
        
        
        
        
            //Lig isimleri çekme
            getLeagueListData()
    }
    
    
    
    
    
    func getLeagueListData(){
        let headers = [
          "content-type": "application/json",
          "authorization": "apikey 2oZi3fUZNhPg9o71hJjaRG:4nbmKoToUS37HTJQaJLgUQ"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://api.collectapi.com/sport/leaguesList")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
          if (error != nil) {
              print(error ?? "veriler gelirken sıkıntı oldu")
          } else {
            let httpResponse = response as? HTTPURLResponse
              if let data = data {
                  // Yanıt verilerini JSON olarak çöz
                  do {
                      if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                          print(json)
                          if let leaguesJSON = json["result"] as? [[String: Any]]{
//                              print(leaguesJSON)
                              for leagues in leaguesJSON {
                                  if let leagueName = leagues["league"] as? String{
                                      self.leagueList.append(leagueName)
                                  }
                                  if let leagueKey = leagues["key"] as? String{
                                      self.leagueKeyList.append(leagueKey)
                                  }
                              }
                              DispatchQueue.main.async {
                                     self.leagueListTableView.reloadData() // TableView'ı güncelle
                                 }
                          }
                      }
                  } catch {
                      print("JSON çevrim hatası: \(error)")
                  }
              }

          }
        })

        dataTask.resume()
    }
    
    
    
   
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leagueList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "leagueListCell", for: indexPath)
        cell.textLabel?.text = leagueList[indexPath.row]
        cell.textLabel?.textColor = UIColor.darkGray
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let leagueKey = leagueKeyList[indexPath.row]
        let leagueName = leagueList[indexPath.row]
        performSegue(withIdentifier: "goToResultVC", sender: (leagueKey, leagueName))
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResultVC"{
           if let destinationVC = segue.destination as? ResultVC{
                if let data = sender as? (String, String){
                    destinationVC.leagueKey = data.0
                    destinationVC.leagueName = data.1
                }
            }
        }
        if segue.identifier == "goToLeagueTable"{
           if let destinationVC = segue.destination as? LeagueTableVC{
                if let data = sender as? (String, String){
                    destinationVC.leagueKey = data.0
                    destinationVC.leagueName = data.1
                }
            }
        }
        if segue.identifier == "goToGoalKing"{
           if let destinationVC = segue.destination as? GoalKingVC{
                if let data = sender as? (String, String){
                    destinationVC.leagueKey = data.0
                    destinationVC.leagueName = data.1
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
                let leagueTable = UITableViewRowAction(style: .normal, title: "League Table") { (action, indexPath) in
                    let leagueKey = self.leagueKeyList[indexPath.row]
                    let leagueName = self.leagueList[indexPath.row]
                    self.performSegue(withIdentifier: "goToLeagueTable", sender: (leagueKey, leagueName))
                    }
        
                let goalKings = UITableViewRowAction(style: .default, title: "Goal Kings") { (action, indexPath) in
                        let leagueKey = self.leagueKeyList[indexPath.row]
                        let leagueName = self.leagueList[indexPath.row]
                        self.performSegue(withIdentifier: "goToGoalKing", sender: (leagueKey, leagueName))
                    }
                    return[leagueTable, goalKings]
    }
    
    
    
    
   

}

