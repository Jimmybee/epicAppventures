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

class AppventureDetailsView: UIView, UIScrollViewDelegate{
    
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
        setupModel()
    }
    
    // MARK: - Property Accessors
    
    private(set) lazy var topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.backgroundColor = UIColor.gray
        
        return stackView
    }()
    
    private(set) lazy var durationStack: horizontalTwoPartStackview = {
        let stackView = horizontalTwoPartStackview()
        return stackView
    }()
    
    private(set) lazy var distanceSV: horizontalTwoPartStackview = {
        let stackView = horizontalTwoPartStackview()
        return stackView
    }()
    
    private(set) lazy var proximitySV: horizontalTwoPartStackview = {
        let stackView = horizontalTwoPartStackview()
        return stackView
    }()
    
    private(set) lazy var cluesSV: horizontalTwoPartStackview = {
        let stackView = horizontalTwoPartStackview()
        return stackView
    }()
    
    private(set) lazy var spacerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private(set) lazy var appventureImage: UIImageView = {
        let appventureImage = UIImageView()
        appventureImage.contentMode = .scaleToFill
        return appventureImage
    }()
    
    private(set) lazy var detailsSV: FillVerticalSV = {
        let mainStackView = FillVerticalSV()
        mainStackView.alignment = .top
        return mainStackView
    }()
    
    private(set) lazy var appventureName: UILabel = {
        let appventureName = UILabel()
        appventureName.textAlignment = .center
        return appventureName
    }()
    
    private(set) lazy var descriptionTitle: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.font = UIFont.systemFont(ofSize: 22, weight: UIFontWeightSemibold)
        label.textAlignment = .center
        return label
    }()
    
    private(set) lazy var descriptionLabel: UILabel = {
        let description = UILabel()
        description.numberOfLines = 0
        return description
    }()
    
    private(set) lazy var mainStackView: FillVerticalSV = {
        let mainStackView = FillVerticalSV()
        return mainStackView
    }()
    
    private(set) lazy var secondaryStackView: FillVerticalSV = {
        let mainStackView = FillVerticalSV()
        return mainStackView
    }()
    
    private(set) lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = self.bounds
        scrollView.delegate = self
        scrollView.bounces = false
        scrollView.contentSize = CGSize(width:self.frame.size.width, height:1000)
        scrollView.backgroundColor = UIColor.white
        return scrollView
    }()
    
    private(set) lazy var containerView: UIView = {
        let containerView = UIView()
        return containerView
    }()
    
    private(set) lazy var bottomContainerView: UIView = {
        let containerView = UIView()
        return containerView
    }()
    
    private(set) lazy var greyLine1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    private(set) lazy var greyLine2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    private(set) lazy var greyLine3: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
}

extension AppventureDetailsView {
    
    func setupConstriaints() {
        
        self.addSubview(scrollView)
        scrollView.autoPinEdgesToSuperviewEdges()
        scrollView.addSubview(containerView)
        containerView.autoPinEdgesToSuperviewEdges()
        containerView.addSubview(mainStackView)
        
        mainStackView.autoPinEdgesToSuperviewEdges()
        
        //        mainStackView.autoPinEdge(toSuperviewEdge: .top, withInset: 8)
        //        mainStackView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 8)
        //        mainStackView.autoPinEdge(toSuperviewEdge: .right, withInset: 8)
        //        mainStackView.autoPinEdge(toSuperviewEdge: .left, withInset: 8)
        mainStackView.backgroundColor = UIColor.gray
        
        //        mainStackView.addArrangedSubview(topStackView)
        //        topStackView.addArrangedSubview(appventureImage)
        //        topStackView.addArrangedSubview(detailsSV)
        
        //        detailsSV.addArrangedSubview(durationStack)
        //        detailsSV.addArrangedSubview(distanceSV)
        //        detailsSV.addArrangedSubview(cluesSV)
        //        detailsSV.addArrangedSubview(proximitySV)
        //        detailsSV.addArrangedSubview(spacerView)
        
        NSLayoutConstraint.autoSetPriority(800) {
            durationStack.autoSetContentHuggingPriority(for: .vertical)
            distanceSV.autoSetContentHuggingPriority(for: .vertical)
            cluesSV.autoSetContentHuggingPriority(for: .vertical)
            proximitySV.autoSetContentHuggingPriority(for: .vertical)
            
        }
        
        appventureImage.autoSetDimension(.height, toSize: 150)
        appventureImage.autoSetDimension(.width, toSize: self.frame.size.width)
        
        //        appventureImage.autoSetDimension(.width, toSize: UIScreen.main.bounds.size.width)
        
        mainStackView.addArrangedSubview(appventureImage)
        mainStackView.addArrangedSubview(bottomContainerView)
        bottomContainerView.autoMatch(.width, to: .width, of: appventureImage, withMultiplier: 0.9)
        bottomContainerView.addSubview(secondaryStackView)
        secondaryStackView.autoPinEdgesToSuperviewEdges()
        
        secondaryStackView.addArrangedSubview(greyLine1)
        secondaryStackView.addArrangedSubview(appventureName)
        secondaryStackView.addArrangedSubview(greyLine2)
        secondaryStackView.addArrangedSubview(descriptionTitle)
        secondaryStackView.addArrangedSubview(descriptionLabel)
        
        greyLine1.autoSetDimension(.height, toSize: 1)
        greyLine2.autoSetDimension(.height, toSize: 1)
        
        
        descriptionLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam a sem sed nunc elementum dapibus. Nam dignissim condimentum diam in pellentesque. Integer posuere ligula eu leo efficitur consequat. Fusce fermentum et leo quis vulputate. Aenean aliquet ante eu nunc eleifend pharetra. Vestibulum sit amet nisi lacinia nisl dapibus ultrices. Aenean bibendum augue in diam vestibulum suscipit. Praesent neque ipsum, imperdiet in mauris a, dictum luctus magna."
        
        
    }
    
    func setupModel() {
        appventureImage.image = appventure.image
        appventureName.text = appventure.title
        durationStack.leftLabel.text = "Time:"
        durationStack.rightLabel.text = "60mins"
        distanceSV.leftLabel.text = "Distance:"
        distanceSV.rightLabel.text = "0.5km"
        cluesSV.leftLabel.text = "Clues:"
        cluesSV.rightLabel.text = "15"
        proximitySV.leftLabel.text = "Proximity:"
        proximitySV.rightLabel.text = "1.2km"
    }
}


class FillVerticalSV: UIStackView {
    
    override init(frame:CGRect) {
        super.init(frame:frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: CGRect.zero)
        self.alignment = .fill
        self.distribution = .fill
        self.axis = .vertical
        self.spacing = 12
    }
}

class horizontalTwoPartStackview : UIStackView {
    
    override init(frame:CGRect) {
        super.init(frame:frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: CGRect.zero)
        self.alignment = .leading
        self.distribution = .fill
        self.axis = .horizontal
        self.spacing = 12
        setup()
    }
    
    private(set) lazy var leftLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        //        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private(set) lazy var rightLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.backgroundColor = UIColor.blue
        //        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    private(set) lazy var spacerView: UIView = {
        let view = UIView()
        return view
    }()
    
    func setup() {
        self.addArrangedSubview(leftLabel)
        self.addArrangedSubview(spacerView)
        self.addArrangedSubview(rightLabel)
        NSLayoutConstraint.autoSetPriority(800) {
            leftLabel.autoSetContentHuggingPriority(for: .vertical)
            rightLabel.autoSetContentHuggingPriority(for: .vertical)
        }
    }
}
