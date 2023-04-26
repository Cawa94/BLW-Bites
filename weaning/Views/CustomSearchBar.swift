//
//  CustomSearchBar.swift
//  weaning
//
//  Created by Yuri Cavallin on 18/2/23.
//

import UIKit

final class CustomSearchBar: UISearchBar {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configureAppearance()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureAppearance()
    }

    func configureAppearance() {
        self.searchTextField.backgroundColor = .clear
        self.searchTextField.font = .regularFontOf(size: 16)
        roundCornersSimplified(cornerRadius: frame.height/2, borderWidth: 0.5, borderColor: .lightGray)
    }

}
