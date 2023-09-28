//
//  LeagueTableViewCell.swift
//  LeagueStatistics
//
//  Created by Berkay Özbaba on 29.09.2023.
//

import UIKit

class LeagueTableViewCell: UITableViewCell {

    @IBOutlet var teamNameLabel: UILabel!
    
    @IBOutlet var playLabel: UILabel!
    
    @IBOutlet var winLabel: UILabel!
    
    @IBOutlet var lostLabel: UILabel!
    
    @IBOutlet var pointLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
