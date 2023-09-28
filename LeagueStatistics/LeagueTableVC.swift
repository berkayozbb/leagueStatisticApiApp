//
//  LeagueTableVC.swift
//  LeagueStatistics
//
//  Created by Berkay Özbaba on 28.09.2023.
//

import UIKit

class LeagueTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LeagueTableViewCell
        cell.teamNameLabel.text = "\(rankList[indexPath.row]). \(teamList[indexPath.row])"
        cell.lostLabel.text = loseList[indexPath.row]
        cell.playLabel.text = playList[indexPath.row]
        cell.winLabel.text = winList[indexPath.row]
        cell.pointLabel.text = pointList[indexPath.row]
        return cell
    }
    
    
    var rankList = [String]()
    var playList = [String]()
    var winList = [String]()
    var loseList = [String]()
    var pointList = [String]()
    var teamList = [String]()
    
    @IBOutlet var tableView: UITableView!
    
    
    
    
    
    
    var leagueKey = ""
    var leagueName = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //test
//        teamList.append("FB")
//        teamList.append("GS")
//        teamList.append("ADS")
//        teamList.append("Jimnastik")
//        pointList.append("15")
//        pointList.append("13")
//        pointList.append("10")
//        pointList.append("9")
//        loseList.append("0")
//        loseList.append("1")
//        loseList.append("1")
//        loseList.append("2")
//        winList.append("5")
//        winList.append("4")
//        winList.append("3")
//        winList.append("3")
//        playList.append("5")
//        playList.append("5")
//        playList.append("5")
//        playList.append("5")
//        rankList.append("1")
//        rankList.append("2")
//        rankList.append("3")
//        rankList.append("4")
        
        //Sayfaya başlık ekleme
        if let navigationBar = self.navigationController?.navigationBar {
            let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: navigationBar.frame.size.width, height: navigationBar.frame.size.height))
            titleLabel.text = leagueName
            titleLabel.textAlignment = .center
            
            // Özelleştireceğiniz fontu ve diğer özellikleri ayarlayın
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "Helvetica-Bold", size: 18.0)!, // Font ve boyut
                .foregroundColor: UIColor.red, // Renk
            ]
            
            let attributedTitle = NSAttributedString(string: titleLabel.text ?? "", attributes: attributes)
            titleLabel.attributedText = attributedTitle
            
            // Başlık metnini Navigation Bar'a ekle
            navigationItem.titleView = titleLabel
        }
        
        
        
        
        getLeagueTableData()
        
        
        
    }
    
    func getLeagueTableData(){
        
        let headers = [
          "content-type": "application/json",
          "authorization": "apikey 2oZi3fUZNhPg9o71hJjaRG:4nbmKoToUS37HTJQaJLgUQ"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://api.collectapi.com/sport/league?data.league=\(leagueKey)")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
          if (error != nil) {
              print(error ?? "error")
          } else {
            let httpResponse = response as? HTTPURLResponse
              if let data = data {
                  // Yanıt verilerini JSON olarak çöz
                  do {
                      if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                          print(json)
                          if let resultsJSON = json["result"] as? [[String: Any]]{
//                              print(resultsJSON)
                              for item in resultsJSON {
                                  if let rank = item["rank"] as? String{
                                      self.rankList.append(rank)
                                  }
                                  if let  play = item["play"] as? String{
                                      self.playList.append(play)
                                  }
                                  if let point = item["point"] as? String{
                                      self.pointList.append(point)
                                  }
                                  if let lose = item["lose"] as? String{
                                      self.loseList.append(lose)
                                  }
                                  if let win = item["win"] as? String{
                                      self.winList.append(win)
                                  }
                                  if let team = item["team"] as? String{
                                      self.teamList.append(team)
                                  }
                              }
                              DispatchQueue.main.async {
                                     self.tableView.reloadData() // tableView'i güncelle
                                 }
                          }
                          print(self.rankList, self.playList, self.pointList, self.loseList, self.winList, self.teamList)
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
