//
//  ResultVC.swift
//  LeagueStatistics
//
//  Created by Berkay Özbaba on 28.09.2023.
//

import UIKit

class ResultVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var homeTeamNameLabel: UILabel!
    
    @IBOutlet var awayTeamNameLabel: UILabel!
    
    @IBOutlet var matchResultLabel: UILabel!
    
    @IBOutlet var resultTableView: UITableView!
    
    var leagueKey = ""
    var leagueName = ""
    
    var scoreList = [String]()
    var homeList = [String]()
    var awayList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //test
//        homeList.append("Konyaspor")
//        homeList.append("FB")
//        homeList.append("GS")
//        homeList.append("BJK")
//        awayList.append("Başakşehir")
//        awayList.append("Samsunspor")
//        awayList.append("Kayseri")
//        awayList.append("Pendikspor")
//        scoreList.append("0-0")
//        scoreList.append("0-0")
//        scoreList.append("0-0")
//        scoreList.append("0-0")
        
        if let navigationBar = self.navigationController?.navigationBar {
            let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: navigationBar.frame.size.width, height: navigationBar.frame.size.height))
            titleLabel.text = leagueName
            titleLabel.textAlignment = .center
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "Helvetica-Bold", size: 18.0)!,
                .foregroundColor: UIColor.red, // Renk
            ]
            
            let attributedTitle = NSAttributedString(string: titleLabel.text ?? "", attributes: attributes)
            titleLabel.attributedText = attributedTitle
            navigationItem.titleView = titleLabel
        }
        
        
        getResultData()
        
    }
    
    func getResultData(){
        
        let headers = [
          "content-type": "application/json",
          "authorization": "apikey 2oZi3fUZNhPg9o71hJjaRG:4nbmKoToUS37HTJQaJLgUQ"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://api.collectapi.com/sport/results?data.league=\(leagueKey)")! as URL,
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
                                  if let result = item["score"] as? String{
                                      self.scoreList.append(result)
                                  }
                                  if let home = item["home"] as? String{
                                      self.homeList.append(home)
                                  }
                                  if let away = item["away"] as? String{
                                      self.awayList.append(away)
                                  }
                              }
                              DispatchQueue.main.async {
                                     self.resultTableView.reloadData() // TableView'ı güncelle
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
        return homeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as! ResultTableViewCell
            cell.homeTeamNameLabel.text = homeList[indexPath.row]
            cell.awayTeamNameLabel.text = awayList[indexPath.row]
//            cell.matchResultLabel.text = scoreList[indexPath.row]
        
            cell.homeTeamNameLabel.textColor = UIColor.darkGray
            cell.awayTeamNameLabel.textColor = UIColor.darkGray
            cell.matchResultLabel.textColor = UIColor.lightGray
        
            return cell
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
    }
    
    

  

}
