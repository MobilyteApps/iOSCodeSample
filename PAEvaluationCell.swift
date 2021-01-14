//
//  PAEvaluationTableCell.swift
//  Projectart
//
//  Created by Infostride on 21/08/19.
//  Copyright © 2019 Infostride. All rights reserved.
//


import UIKit
protocol PAEvaluationCellDelegate {
    func delete(id:Int)
}
class PAEvaluationCell: UITableViewCell {
    @IBOutlet var evaluationNameLbl: UILabel!
    @IBOutlet var evaluationTimeLbl: UILabel!
    @IBOutlet var editEvaluationBtn: UIButton!
    @IBOutlet var deleteEvaluationBtn: UIButton!
    var delegate:PAEvaluationCellDelegate?
    var obj:PAEvaluation?{
        didSet{
            evaluationNameLbl.text = obj?.name ?? ""
            let string = "\(obj?.startDate ?? "")  to  \(obj?.endDate ?? "")"
            evaluationTimeLbl.text = string
           
        }
    }
    
    var row:Int=0{
        didSet{
             editEvaluationBtn.tag = row
             deleteEvaluationBtn.tag  = row
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func deleteEvaluationBtn(_ sender: UIButton) {
        self.delegate?.delete(id: obj?.id ?? 0)

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
