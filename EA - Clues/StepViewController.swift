//
//  ViewController.swift
//  AnimationPlay
//
//  Created by James Birtwell on 08/02/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import UIKit
import CoreGraphics
import GoogleMaps
import PureLayout

class StepViewController: UIViewController {
    
    struct Constants {
        static let segueCompletion = "Segue Completion"
        static let CompletionVC = "Step Complete"
        static let AppventureComplete = "Appventure Complete VC"
        static let AppventureTimerFunc = "updateAppventureTimer"
        static let PresentInstructions = "PresentInstructions"
    }
    
    //MARK: IB Outlets

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var timerLabel: UILabel!

    @IBOutlet weak var clueSelectionContainer: UIView!
    
    //MARK: Model
    var appventure: Appventure!
    lazy var completedAppventures = [CompletedAppventure]()
    var step: AppventureStep!
    var stepNumber = 0 { didSet {
        step = appventure.appventureSteps[stepNumber]
        }}
    var timer : Timer?
    var ms = 0.0
    
    //ViewVariable
    var activeViews = [UIView]()
    var activeBttns = [UIButton]()
    
    //Child View Controllers
    let textClueView : TextClueViewController = TextClueViewController(nibName: "TextClueViewController", bundle: nil)
    let pictureClueView : PictureClueViewController = PictureClueViewController(nibName: "PictureClueViewController", bundle: nil)
    let soundClueView : SoundClueViewController = SoundClueViewController(nibName: "SoundClueViewController", bundle: nil)
    let mapComapassView : MapCompassViewController = MapCompassViewController(nibName: "MapCompassViewController", bundle: nil)
    
    private(set) var clueTypeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    private(set) var textClueBttn: UIButton = {
        let bttn = UIButton(frame: .zero)
        bttn.setImage(UIImage(named: ImageNames.VcStep.file), for: .normal)
        bttn.setImage(UIImage(named: ImageNames.VcStep.fileSelected), for: .selected)
        bttn.addTarget(self, action: #selector(clueBttnTapped(sender:)), for: .touchUpInside)
        return bttn
    }()
    
    private(set) var imageClueBttn: UIButton = {
        let bttn = UIButton(frame: .zero)
        bttn.setImage(UIImage(named: ImageNames.VcStep.camera), for: .normal)
        bttn.setImage(UIImage(named: ImageNames.VcStep.cameraSelected), for: .selected)
        bttn.addTarget(self, action: #selector(clueBttnTapped(sender:)), for: .touchUpInside)
        return bttn
    }()
    
    private(set)  var mapClueBttn: UIButton = {
        let bttn = UIButton(frame: .zero)
        bttn.setImage(UIImage(named: ImageNames.VcStep.map), for: .normal)
        bttn.setImage(UIImage(named: ImageNames.VcStep.mapSelected), for: .selected)
        bttn.addTarget(self, action: #selector(clueBttnTapped(sender:)), for: .touchUpInside)
        return bttn
    }()
    
    private(set)  var purpleLine: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = Colors.purple
        return view
    }()
    
    private(set)  var separatorLine1: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    private(set)  var separatorLine2: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    private(set)  var separatorLine3: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    private(set)  var answerBttn: UIButton = {
        let bttn = UIButton(frame: .zero)
        return bttn
    }()
    
    var purpleLineVertical : NSLayoutConstraint?
    var purpleLineWidth : NSLayoutConstraint?

    
    //MARK: Lifecycle
    override func viewDidLoad() {
        stepNumber = 0
        timerLabel.text = HelperFunctions.formatTime(0, nano: false)
        step = appventure.appventureSteps[0]
        loadControllers()
        setupConstraints()
        setupViews()
        setupBttnConstraints()

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(StepViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if timer == nil {
            self.startTimer()
        }
    }

}

//MARK: Constraints & Setup of views

extension StepViewController {
    
    //MARK: Constraints
    
    func setupConstraints() {
        clueSelectionContainer.addSubview(clueTypeStackView)
        
        clueTypeStackView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) // Causing error
        
        clueSelectionContainer.addSubview(separatorLine1)
        
        separatorLine1.autoMatch(.width, to: .width, of: clueSelectionContainer)
        separatorLine1.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
        separatorLine1.autoAlignAxis(toSuperviewAxis: .vertical)
        separatorLine1.autoSetDimension(.height, toSize: 2)
        
        clueSelectionContainer.addSubview(purpleLine)
        purpleLine.autoSetDimension(.height, toSize: 5)
        purpleLine.autoPinEdge(toSuperviewEdge: .bottom)
        
    
    }
    
    
    
    //MARK: Setup
    
    func setupAnswerBttn() {
        answerBttn.setImage(UIImage(named: ImageNames.VcStep.map), for: .normal)
        answerBttn.setImage(UIImage(named: ImageNames.VcStep.mapSelected), for: .selected)
    }
    
    func loadControllers() {
        func addController (_ vc: UIViewController) {
            self.addChildViewController(vc)
            self.containerView.insertSubview(vc.view, at: 0)
            vc.view.frame = containerView.bounds
            vc.didMove(toParentViewController: self)
        }
        
        addController(soundClueView)
        addController(textClueView)
        addController(pictureClueView)
        addController(mapComapassView)
        
    }
    
    func setupViews() {
        activeViews.removeAll()
        activeBttns.removeAll()
        
        for view in clueTypeStackView.arrangedSubviews {
            clueTypeStackView.removeArrangedSubview(view)
        }
        
        //Text
        if  step.setup.textClue {
            textClueView.clueText = step.initialText
            textClueView.setup()
            activeViews.append(textClueView.view)
            activeBttns.append(textClueBttn)
        }
        
        //Sound
        if  step.setup.soundClue {
            if let isSound = step.sound as Data! {
                soundClueView.sound = isSound
                soundClueView.setupAP()
                activeViews.append(soundClueView.view)
//                activeBttns.append(textClueBttn)
            }
        }
        
        //Image
        if  step.setup.pictureClue {
            if let isImage = step.image as UIImage! {
                pictureClueView.clueImage = isImage
                pictureClueView.setup()
                activeViews.append(pictureClueView.view)
                activeBttns.append(imageClueBttn)
            }
        }
        
        //Map
        mapComapassView.stepCoordinate = step.location!.coordinate
        mapComapassView.showLocation = step.setup.locationShown
        mapComapassView.showCompass = step.setup.compassShown
        mapComapassView.showDistance = step.setup.distanceShown
        mapComapassView.setup()
        activeViews.append(mapComapassView.view)
        activeBttns.append(mapClueBttn)
        
        //Complete
        self.view.sendSubview(toBack: containerView)
        
        //set scrollbar at bottom to clue
        containerView.bringSubview(toFront: activeViews[0])
        
    }
    
    func setupBttnConstraints() {
        purpleLineVertical?.autoRemove()
        purpleLineWidth?.autoRemove()

        for (index ,bttn) in activeBttns.enumerated() {
            clueTypeStackView.addArrangedSubview(bttn)
            bttn.tag = index
            if index > 0 {
                activeBttns[index].autoMatch(.width, to: .width, of: activeBttns[index - 1])
            }
            if index < activeBttns.count - 1 {
                let separator = UIView()
                separator.backgroundColor = UIColor.lightGray
                clueTypeStackView.addArrangedSubview(separator)
                separator.autoMatch(.height, to: .height, of: clueTypeStackView, withMultiplier: 0.9)
                separator.autoSetDimension(.width, toSize: 1)
            }
        }
        
        activeBttns[0].isSelected = true
        purpleLineVertical = purpleLine.autoAlignAxis(.vertical, toSameAxisOf: activeBttns[0])
        purpleLineWidth = purpleLine.autoMatch(.width, to: .width, of: activeBttns[0], withMultiplier: 0.9)

        
    }
}

// MARK: Private Functions

extension StepViewController {
    
    func clueBttnTapped(sender: UIButton) {
        purpleLineVertical?.autoRemove()

        for bttn in activeBttns {
            bttn.isSelected = false
        }
        activeBttns[sender.tag].isSelected = true
        containerView.bringSubview(toFront: activeViews[sender.tag])
        purpleLineVertical!.autoRemove()
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.purpleLineVertical = self.purpleLine.autoAlignAxis(.vertical, toSameAxisOf: self.activeBttns[sender.tag])
            self.clueSelectionContainer.layoutIfNeeded()
        }, completion: nil)

    }
    
    /// Menu button for exit, report, instructions
    @IBAction func moreActions(_ sender: AnyObject) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Exit Appventure", style: UIAlertActionStyle.destructive, handler: { action in
            self.dismiss(animated: false, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Report Content", style: .default, handler: { action in
            self.flagContent()
        }))
        alert.addAction(UIAlertAction(title: "Instructions", style: .default, handler: { action in
            self.performSegue(withIdentifier: Constants.PresentInstructions, sender: nil   )
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func flagContent() {
        let stepIs = self.step
        let stepID = stepIs?.backendlessId
        let flaggedContent = FlaggedContent(appventureFKID: self.appventure.backendlessId!, stepFKID: stepID!)
        flaggedContent.save()
    }
    
    func updateHintText(_ hint: String, hintsRecieved: Int16) {
        //Text
        if step.setup.textClue == false {
            activeViews.insert(textClueView.view, at: 0)
            containerView.bringSubview(toFront: activeViews[0])
            textClueView.clueTextView.text = ""
        }
        
        if step.freeHints < hintsRecieved { self.ms += Double(step.hintPenalty)}
        textClueView.clueTextView.text = textClueView.clueTextView.text! + "\n\nHint:\n" + hint
    }
    
    
    func stepComplete (){
        let storyBoard = UIStoryboard(name: Storyboards.LaunchAppventure, bundle:nil)
        if appventure.appventureSteps.count == (stepNumber + 1) {
            if let acvc = storyBoard.instantiateViewController(withIdentifier: Constants.AppventureComplete) as? AppventureCompleteViewController {
                acvc.appventure = self.appventure
                acvc.completeTime = self.ms
                self.dismiss(animated: true, completion: nil)
                self.presentingViewController?.present(acvc, animated: true, completion: nil)
            }
        } else {
            if let scvc = storyBoard.instantiateViewController(withIdentifier: Constants.CompletionVC) as? StepCompleteViewController {
                scvc.step = appventure.appventureSteps[stepNumber]
                scvc.currentTimeD = self.ms
                scvc.delegate = self
                self.present(scvc, animated: false, completion: nil)
                stepNumber += 1
                step = appventure.appventureSteps[stepNumber]
                setupViews()
                timer?.invalidate()
                timer = nil
                
            }
        }
    }
    
    
    //MARK: Timer
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: Selector(Constants.AppventureTimerFunc), userInfo: nil, repeats: true)
    }
    
    func updateAppventureTimer() {
        self.ms += 1
        let formattedTime = HelperFunctions.formatTime(ms, nano:  false)
        UIView.animate(withDuration: 0.01, animations: { () -> Void in
            self.timerLabel.text = formattedTime
        })
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension StepViewController : StepCompleteViewControllerDelegate {
    func setTime(_ currentTime : Double) {
        ms = currentTime
    }
}

