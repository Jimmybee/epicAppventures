//
//  AppventureDetailsView.swift
//  EA - Clues
//
//  Created by James Birtwell on 21/01/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import Foundation
import PureLayout

protocol AppventureDetailsViewDelegate: class {
    
    func playPressed()
}

class AppventureDetailsView: UIView {
    
    var appventure: Appventure!
    weak var delegate: AppventureDetailsViewDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup() {
        setupConstriaints() 
    }
    
    // MARK: - Property Accessors
    
    private(set) lazy var appventureImage: UIImageView = {
        let appventureImage = UIImageView()
        return appventureImage
    }()
    
    private(set) lazy var appventureName: UILabel = {
        let appventureName = UILabel()
        return appventureName
    }()
    
    private(set) lazy var descriptionTextView: UITextView = {
        let description = UITextView()
        return description
    }()
    
    private(set) lazy var leftButton: UIButton = {
        let leftButton = UIButton()
        return leftButton
    }()
    
    private(set) lazy var rightButton: UIButton = {
        let rightButton = UIButton()
        rightButton.backgroundColor = UIColor.green
        return rightButton
    }()
    
    private(set) lazy var buttonStackView: UIStackView = {
        let buttonStackView = UIStackView()
        buttonStackView.alignment = .fill
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 8
        return buttonStackView
    }()

    
}

extension AppventureDetailsView {
    
    func setupConstriaints() {
        self.addSubview(buttonStackView)
        
        buttonStackView.addSubview(leftButton)
        buttonStackView.addSubview(rightButton)
        
//        self.addSubview(appventureImage)
//        self.addSubview(appventureName)
//        self.addSubview(descriptionTextView)


    }
}
