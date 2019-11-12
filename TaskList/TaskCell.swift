//
//  TaskCell.swift
//  TaskList
//
//  Created by Kevin Grzela on 2019-10-12.
//  Copyright © 2019 KG. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblSubtitle: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
