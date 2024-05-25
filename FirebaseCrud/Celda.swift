//
//  Celda.swift
//  FirebaseCrud
//
//  Created by Jorge Maldonado Borbón on 09/10/17.
//  Copyright © 2017 Jorge Maldonado Borbón. All rights reserved.
//

import UIKit

class Celda: UITableViewCell {

    @IBOutlet weak var generoFirebase: UILabel!
    @IBOutlet weak var nombreFirebase: UILabel!
    @IBOutlet weak var imagenFirebase: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
