//
//  ResultTableViewCell.swift
//  LeagueStatistics
//
//  Created by Berkay Özbaba on 28.09.2023.
//

import UIKit

class ResultTableViewCell: UITableViewCell {

    @IBOutlet var homeTeamNameLabel: UILabel!
    
    @IBOutlet var matchResultLabel: UILabel!
    
    @IBOutlet var awayTeamNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
