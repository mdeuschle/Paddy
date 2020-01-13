//
//  ShadowCell.swift
//  Paddy
//
//  Created by Matt Deuschle on 1/5/20.
//  Copyright © 2020 Matt Deuschle. All rights reserved.
//

import UIKit

class ShadowCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func configure(tableData: [[TableData]], at section: Int) {
        let title: String
        let detail: NSMutableAttributedString
        switch section {
        case 0:
            let tableData = tableData[0][0]
            title = "Date"
            detail = attributedString(for: tableData.type.rawValue,
                                      detail: tableData.detail ?? "") ?? NSMutableAttributedString()
        case 1:
            let typeTableData = tableData[1][0]
            title = "Attributes"
            let tempAttributedString = NSMutableAttributedString()
            let space = NSAttributedString(string: "\n \n")
            let type = attributedString(for: typeTableData.type.rawValue,
                                        detail: typeTableData.detail ?? "") ?? NSMutableAttributedString()
            tempAttributedString.append(type)
            tempAttributedString.append(space)
            let addressTableData = tableData[1][1]
            let address = attributedString(for: addressTableData.type.rawValue,
                                           detail: addressTableData.detail ?? "") ?? NSMutableAttributedString()
            tempAttributedString.append(address)
            tempAttributedString.append(space)
            let districtTableData = tableData[1][2]
            let district = attributedString(for: districtTableData.type.rawValue,
                                            detail: districtTableData.detail ?? "") ?? NSMutableAttributedString()
            tempAttributedString.append(district)
            tempAttributedString.append(space)
            let apnTableData = tableData[1][3]
            let apn = attributedString(for: apnTableData.type.rawValue,
                                       detail: apnTableData.detail ?? "") ?? NSMutableAttributedString()
            tempAttributedString.append(apn)
            detail = tempAttributedString
        case 2:
            let lenderTableData = tableData[2][0]
            title = "Lender"
            let tempAttributedString = NSMutableAttributedString()
            let space = NSAttributedString(string: "\n \n")
            let lender = attributedString(for: lenderTableData.type.rawValue,
                                        detail: lenderTableData.detail ?? "") ?? NSMutableAttributedString()
            tempAttributedString.append(lender)
            tempAttributedString.append(space)
            let lenderContactTableData = tableData[2][1]
            let lenderContact = attributedString(for: lenderContactTableData.type.rawValue,
                                           detail: lenderContactTableData.detail ?? "") ?? NSMutableAttributedString()
            tempAttributedString.append(lenderContact)
            tempAttributedString.append(space)
            
            let lenderPhoneTableData = tableData[2][2]
            let lenderPhone = attributedString(for: lenderPhoneTableData.type.rawValue,
                                       detail: lenderPhoneTableData.detail ?? "") ?? NSMutableAttributedString()
            tempAttributedString.append(lenderPhone)
            detail = tempAttributedString
        case 3:
            let propertyManagementTableData = tableData[3][0]
            title = "Management"
            let tempAttributedString = NSMutableAttributedString()
            let space = NSAttributedString(string: "\n \n")
            let propertyManagement = attributedString(for: propertyManagementTableData.type.rawValue,
                                          detail: propertyManagementTableData.detail ?? "") ?? NSMutableAttributedString()
            tempAttributedString.append(propertyManagement)
            tempAttributedString.append(space)
            let propertyManagementContactTableData = tableData[3][1]
            let propertyManagementContact = attributedString(for: propertyManagementContactTableData.type.rawValue,
                                                 detail: propertyManagementContactTableData.detail ?? "") ?? NSMutableAttributedString()
            tempAttributedString.append(propertyManagementContact)
            tempAttributedString.append(space)
            let propertyManagementAddressTableData = tableData[3][2]
            let propertyManagementAddress = attributedString(for: propertyManagementAddressTableData.type.rawValue,
                                                 detail: propertyManagementAddressTableData.detail ?? "") ?? NSMutableAttributedString()
            tempAttributedString.append(propertyManagementAddress)
            tempAttributedString.append(space)
            let propertyManagementPhoneTableData = tableData[3][3]
            let propertyManagementPhone = attributedString(for: propertyManagementPhoneTableData.type.rawValue,
                                                 detail: propertyManagementPhoneTableData.detail ?? "") ?? NSMutableAttributedString()
            tempAttributedString.append(propertyManagementPhone)
            detail = tempAttributedString
        default:
            title = ""
            detail = NSMutableAttributedString()
        }
        titleLabel.text = title
        detailTextView.attributedText = detail
    }
    
    private func attributedString(for title: String, detail: String) -> NSMutableAttributedString? {
        let attributedString = NSMutableAttributedString()
        let titleAttribute = [NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: .headline),
                              .foregroundColor: UIColor.customFont]
        let titleString = NSMutableAttributedString(string: title,
                                                    attributes: titleAttribute)
        let detailAttribute = [NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: .body),
                               .foregroundColor: UIColor.customFont]
        let detailString = NSMutableAttributedString(string: detail,
                                                     attributes: detailAttribute)
        let space = NSAttributedString(string: "\n")
        attributedString.append(titleString)
        attributedString.append(space)
        attributedString.append(detailString)
        return attributedString
    }
}
