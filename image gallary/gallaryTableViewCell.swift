//
//  gallaryTableViewCell.swift
//  image gallary
//
//  Created by Moutaz_Hegazy on 6/7/20.
//  Copyright © 2020 Moutaz_Hegazy. All rights reserved.
//

import UIKit

class gallaryTableViewCell: UITableViewCell , UITextFieldDelegate
{

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func editCellTitle(_ tap : UITapGestureRecognizer){
        
        switch tap.state{
        case .ended :
            titleLabel.isHidden = true
            textField.isHidden = false
            print("wezza : iam tapped")
            textField.becomeFirstResponder()
            print("wezza : iam first responder")
        default : break
        }
        
    }
    
    var editTitle : (( _ cell : gallaryTableViewCell) -> Void)?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var textField: UITextField!{
        didSet{
            textField.delegate = self
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        editTitle?(self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    
}
