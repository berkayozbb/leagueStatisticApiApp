//
//  GoalKingTableViewCell.swift
//  LeagueStatistics
//
//  Created by Berkay Özbaba on 29.09.2023.
//

import UIKit

class GoalKingTableViewCell: UITableViewCell {
    
    @IBOutlet var goalsLabel: UILabel!
    
    @IBOutlet var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
