//
//  CardViewer.swift
//  ImagiNet
//
//  Created by Michael Kennedy on 7/25/23.
//

import Foundation
import UIKit

class CardViewer: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    
    public static var businessCard: BusinessCard?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = CardViewer.businessCard!.firstname + " " + CardViewer.businessCard!.lastname
        jobLabel.text = CardViewer.businessCard!.jobtitle
    }

}
