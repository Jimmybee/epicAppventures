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

    @IBOutlet weak var clueTypeStackView: UIStackView!
    
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
    
    //Child View Controllers
    let textClueView : TextClueViewController = TextClueViewController(nibName: "TextClueViewController", bundle: nil)
    let pictureClueView : PictureClueViewController = PictureClueViewController(nibName: "PictureClueViewController", bundle: nil)
    let soundClueView : SoundClueViewController = SoundClueViewController(nibName: "SoundClueViewController", bundle: nil)
    let mapComapassView : MapCompassViewController = MapCompassViewController(nibName: "MapCompassViewController", bundle: nil)

    
    private(set) var textClueBttn: UIButton = {
        let bttn = UIButton(frame: .zero)
        bttn.setImage(UIImage(named: ImageNames.VcStep.file), for: .normal)
        bttn.setImage(UIImage(named: ImageNames.VcStep.fileSelected), for: .selected)
        bttn.addTarget(self, action: #selector(textClueTapped), for: .touchUpInside)
        return bttn
    }()
    
    private(set) var imageClueBttn: UIButton = {
        let bttn = UIButton(frame: .zero)
        bttn.setImage(UIImage(named: ImageNames.VcStep.camera), for: .normal)
        bttn.setImage(UIImage(named: ImageNames.VcStep.cameraSelected), for: .selected)
        bttn.addTarget(self, action: #selector(imageClueTapped), for: .touchUpInside)
        return bttn
    }()
    
    private(set)  var mapClueBttn: UIButton = {
        let bttn = UIButton(frame: .zero)
        bttn.setImage(UIImage(named: ImageNames.VcStep.map), for: .normal)
        bttn.setImage(UIImage(named: ImageNames.VcStep.mapSelected), for: .selected)
        bttn.addTarget(self, action: #selector(mapClueTapped), for: .touchUpInside)
        return bttn
    }()
    
    private(set)  var purpleLine: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = Colors.purple
        return view
    }()
    
    private(set)  var separatorLine1: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.darkGray
        return view
    }()
    
    private(set)  var separatorLine2: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.darkGray
        return view
    }()
    
    private(set)  var separatorLine3: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.darkGray
        return view
    }()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        stepNumber = 0
        timerLabel.text = HelperFunctions.formatTime(0, nano: false)
        step = appventure.appventureSteps[0]
        loadControllers()
        setupViews()
//        Appventure.setCurrentAppventure(self.appventure)

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(StepViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        setupConstraints()
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
        clueTypeStackView.addArrangedSubview(textClueBttn)
        clueTypeStackView.addArrangedSubview(separatorLine2)
        clueTypeStackView.addArrangedSubview(imageClueBttn)
        clueTypeStackView.addArrangedSubview(separatorLine3)
        clueTypeStackView.addArrangedSubview(mapClueBttn)


        textClueBttn.autoSetDimension(.height, toSize: 30)
        separatorLine2.autoMatch(.height, to: .height, of: clueTypeStackView, withMultiplier: 0.9)
        separatorLine2.autoSetDimension(.width, toSize: 1)
        imageClueBttn.autoSetDimension(.height, toSize: 25)
        separatorLine3.autoMatch(.height, to: .height, of: clueTypeStackView, withMultiplier: 0.9)
        separatorLine3.autoSetDimension(.width, toSize: 1)
        mapClueBttn.autoSetDimension(.height, toSize: 30)
        
        
    }
    
    //MARK: Setup
    
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
        
        //Text
        if  step.setup.textClue {
            textClueView.clueText = step.initialText
            textClueView.setup()
            activeViews.append(textClueView.view)
        }
        
        //Sound
        if  step.setup.soundClue {
            if let isSound = step.sound as Data! {
                soundClueView.sound = isSound
                soundClueView.setupAP()
                activeViews.append(soundClueView.view)
            }
        }
        
        //Image
        if  step.setup.pictureClue {
            if let isImage = step.image as UIImage! {
                pictureClueView.clueImage = isImage
                pictureClueView.setup()
                activeViews.append(pictureClueView.view)
            }
        }
        
        //Map
        mapComapassView.stepCoordinate = step.location!.coordinate
        mapComapassView.showLocation = step.setup.locationShown
        mapComapassView.showCompass = step.setup.compassShown
        mapComapassView.showDistance = step.setup.distanceShown
        mapComapassView.setup()
        activeViews.append(mapComapassView.view)
        
        
        //Complete
        self.view.sendSubview(toBack: containerView)
        
        //set scrollbar at bottom to clue
        containerView.bringSubview(toFront: activeViews[0])
    }
}

// MARK: Private Functions

extension StepViewController {
    
    func textClueTapped() {
        textClueBttn.isSelected = !textClueBttn.isSelected
    }
    
    func imageClueTapped() {
        imageClueBttn.isSelected = !imageClueBttn.isSelected
    }
    
    func mapClueTapped() {
        mapClueBttn.isSelected = !mapClueBttn.isSelected
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

