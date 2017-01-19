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

class StepViewController: UIViewController {
    
    struct Constants {
        static let segueCompletion = "Segue Completion"
        static let CompletionVC = "Step Complete"
        static let AppventureComplete = "Appventure Complete VC"
        static let AppventureTimerFunc = "updateAppventureTimer"
        static let PresentInstructions = "PresentInstructions"
    }
    
    //MARK: IB Outlets

    @IBOutlet weak var answerContainer: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var timerLabel: UILabel!

    
    //ScrollOutlets
    @IBOutlet weak var scrollHolder: clickParentScroll!
    @IBOutlet weak var scrollCluePicker: UIScrollView!
    @IBOutlet weak var scrollClueLabel: UILabel!
    @IBOutlet weak var scrollSoundLabel: UILabel!
    @IBOutlet weak var scrollImageLabel: UILabel!
    @IBOutlet weak var mapScrollLabel: UILabel!
    
    //MARK: Constraints
    @IBOutlet weak var scrollViewWidth: NSLayoutConstraint!
    @IBOutlet weak var clueSelectWidth: NSLayoutConstraint!
    @IBOutlet weak var mapSelectWidth: NSLayoutConstraint!
    @IBOutlet weak var soundSelectWidth: NSLayoutConstraint!
    
    @IBOutlet weak var imageSelectConstantWidth: NSLayoutConstraint!
    
    //MARK: Model
    lazy var appventure = Appventure()
    lazy var completedAppventures = [CompletedAppventure]()
    var step = AppventureStep()
    var stepNumber = 0 { didSet {
        step = appventure.appventureSteps[stepNumber]
        //        setupForStep()
        }}
    var timer : Timer?
    var ms = 0.0
    
    //Timer
    var currentLabel = UILabel()
    var nextLabel = UILabel()
    var startOffset = CGFloat()
    var currentPage = 0
    
    //ViewVariable
    var activeViews = [UIView]()
    var activeScrollLabels = [UILabel]()
    

    
    //Child View Controllers
    let textClueView : TextClueViewController = TextClueViewController(nibName: "TextClueViewController", bundle: nil)
    let pictureClueView : PictureClueViewController = PictureClueViewController(nibName: "PictureClueViewController", bundle: nil)
    let soundClueView : SoundClueViewController = SoundClueViewController(nibName: "SoundClueViewController", bundle: nil)
    let mapComapassView : MapCompassViewController = MapCompassViewController(nibName: "MapCompassViewController", bundle: nil)
    let answerHintView : AnswerHintViewController = AnswerHintViewController(nibName: "AnswerHintViewController", bundle: nil)
    let checkInHintView : CheckInHintViewController = CheckInHintViewController(nibName: "CheckInHintViewController", bundle: nil)
    var answerCheckInView = UIView()

    //MARK: Lifecycle
    override func viewDidLoad() {
//        self.setNeedsStatusBarAppearanceUpdate
        originalHeight = 55
        stepNumber = 0
        timerLabel.text = HelperFunctions.formatTime(0, nano: false)
        step = appventure.appventureSteps[0]
        loadControllers()
        setupViews()
        scrollHolder.myScroll = self.scrollCluePicker
        setupScrollViews(0)
//        Appventure.setCurrentAppventure(self.appventure)

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(StepViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
//    
//    override func preferredStatusBarStyle() -> UIStatusBarStyle {
//        return UIStatusBarStyle.LightContent
//    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if timer == nil {
            self.startTimer()
        }
    }

    //MARK: Setup
    
    func setupScrollViews(_ activeLabel: Int) {
        for label in activeScrollLabels {
            label.font = label.font.withSize(13)
            label.textColor = UIColor.white
        }
        activeScrollLabels[activeLabel].font = activeScrollLabels[activeLabel].font.withSize(19)
        activeScrollLabels[activeLabel].textColor = UIColor.white
    }
    
    func loadControllers() {
        func addController (_ vc: UIViewController) {
            self.addChildViewController(vc)
            self.containerView.insertSubview(vc.view, at: 0)
            vc.view.frame = containerView.bounds
            vc.didMove(toParentViewController: self)
        }

        func addAnswerControllers (_ vc: UIViewController) {
            self.addChildViewController(vc)
            self.answerContainer.insertSubview(vc.view, at: 0)
            vc.view.frame = answerContainer.bounds
            vc.didMove(toParentViewController: self)
        }
        
        addController(soundClueView)
        addController(textClueView)
        addController(pictureClueView)
        addController(mapComapassView)
        addAnswerControllers(checkInHintView)
        addAnswerControllers(answerHintView)

        pictureClueView.delegate = self
    }

    
    
    func setupViews() {
        activeViews.removeAll()
        activeScrollLabels.removeAll()
        
        //Text
        if  step.setup.textClue {
            textClueView.clueText = step.initialText
            textClueView.setup()
            clueSelectWidth.constant = scrollViewWidth.constant
            activeViews.append(textClueView.view)
            activeScrollLabels.append(scrollClueLabel)
        } else {
            clueSelectWidth.constant = 0
        }
        
        //Sound
        if  step.setup.soundClue {
            if let isSound = step.sound as Data! {
                soundClueView.sound = isSound
                soundClueView.setupAP()
                soundSelectWidth.constant = scrollViewWidth.constant
                activeViews.append(soundClueView.view)
                activeScrollLabels.append(scrollSoundLabel)
            } else { soundSelectWidth.constant = 0 }
        } else { soundSelectWidth.constant = 0 }
        
        //Image
        if  step.setup.pictureClue {
            if let isImage = step.image as UIImage! {
                pictureClueView.clueImage = isImage
                pictureClueView.setup()
                imageSelectConstantWidth.constant = scrollViewWidth.constant
                activeViews.append(pictureClueView.view)
                activeScrollLabels.append(scrollImageLabel)
            } else { imageSelectConstantWidth.constant = 0 }
        } else {
            imageSelectConstantWidth.constant = 0
        }
        
        //Map
        mapComapassView.stepCoordinate = step.coordinate2D!.coordinate
        mapComapassView.showLocation = step.setup.locationShown
        mapComapassView.showCompass = step.setup.compassShown
        mapComapassView.showDistance = step.setup.distanceShown
        mapComapassView.setup()
        activeViews.append(mapComapassView.view)
        activeScrollLabels.append(mapScrollLabel)

        
        //Complete
        if step.setup.checkIn {
            checkInHintView.stepLocationName = step.nameOrLocation
            checkInHintView.stepCoordinate = step.coordinate2D!.coordinate
            checkInHintView.answerHint = self.step.answerHint
            checkInHintView.stepDistance = step.checkInProximity
            checkInHintView.setup()
            checkInHintView.view.alpha = 1
            answerHintView.view.alpha = 0
            extendedHeight = 135
        } else {
            answerHintView.answers = self.step.answerText
            answerHintView.answerHint = self.step.answerHint
            answerHintView.setup()
            checkInHintView.view.alpha = 0
            answerHintView.view.alpha = 1
            extendedHeight = 165
        }
        
        self.view.sendSubview(toBack: containerView)
        
        //set scrollbar at bottom to clue
        containerView.bringSubview(toFront: activeViews[0])
        setupScrollViews(0)
        scrollCluePicker.contentOffset.x = 0
        
        panEndDown()

    }
    
    
    //MARK: Pan Setup
    var yMoved:CGFloat = 0
    var topExtended = false
    var originalHeight:CGFloat = 0
    var extendedHeight:CGFloat = 0
    var maxPan: CGFloat = 0
    
    @IBOutlet var panGesture: UIPanGestureRecognizer!
    @IBOutlet weak var answerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var commentImage: UIImageView!
  
    
    @IBAction func panning(_ sender: UIPanGestureRecognizer) {
        
        switch (sender.state) {
        case .began:
            break
        case .changed:
            yMoved = sender.translation(in: self.view).y
            
            if topExtended == false {
                answerViewHeight.constant = max(min(originalHeight + yMoved, extendedHeight), originalHeight)
                let strength = yMoved / (extendedHeight - originalHeight)
                switch strength {
                case let x where x < 0.3:
                    self.answerContainer.alpha = 0
                    self.commentImage.alpha = 1
                case let x where x > 0.3:
                    self.answerContainer.alpha = x
                    self.commentImage.alpha = 1 - (x*2)
                default: break
                }
                
            } else {
                answerViewHeight.constant = max(min(extendedHeight + yMoved, extendedHeight), originalHeight)
                
                let strength = -yMoved / (extendedHeight - originalHeight)

                switch strength {
                case let x where x < 0.3:
                    self.answerContainer.alpha = 1
                    self.commentImage.alpha = 0
                case let x where x > 0.3:
                    self.answerContainer.alpha = 1 - (x*2)
                    self.commentImage.alpha = x
                default: break
                }
           
            }
            break
        case .ended:
            if sender.translation(in: self.view).y > (self.extendedHeight - self.originalHeight) / 2 {
                panEndDown()
            } else {
                panEndUp()
            }
            
            break
        case .possible: break
        case .cancelled:break
        case .failed:break
        }
    }
     
    func panEndUp() {
        self.answerViewHeight.constant = self.originalHeight
        self.commentImage.alpha = 1
        self.answerContainer.alpha = 0
        self.topExtended = false
    }
    
    func panEndDown() {
        self.answerViewHeight.constant = self.extendedHeight
        self.commentImage.alpha = 0
        self.answerContainer.alpha = 1
        self.topExtended = true
    }
    
    //MARK: Button Actions
    
    
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
        let stepID = stepIs.backendlessId
        let flaggedContent = FlaggedContent(appventureFKID: self.appventure.backendlessId!, stepFKID: stepID!)
        flaggedContent.save()
    }
    
    //MARK: Actions for child VCs
    func updateLabel(_ distance: Double, lastLocation: CLLocation) {
        checkInHintView.lastLocation = lastLocation
    }
    
    func updateLastLocation(_ lastLocation: CLLocation) {
        checkInHintView.lastLocation = lastLocation
    }
    

    
    func updateHintText(_ hint: String, hintsRecieved: Int16) {
        //Text
        if clueSelectWidth.constant != scrollViewWidth.constant {
            clueSelectWidth.constant = scrollViewWidth.constant
            activeViews.insert(textClueView.view, at: 0)
            activeScrollLabels.insert(scrollClueLabel, at: 0)
            setupScrollViews(activeScrollLabels.count - 1)
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
                containerView.bringSubview(toFront: answerCheckInView)


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

}

extension StepViewController : UIScrollViewDelegate {
    
    @IBAction func scrollHolderTapped(_ sender: UITapGestureRecognizer) {
        currentPage = Int(scrollCluePicker.contentOffset.x / scrollCluePicker.frame.size.width)
        startOffset = scrollCluePicker.contentOffset.x

        if sender.location(in: self.view).x > self.view.frame.midX + (scrollCluePicker.frame.size.width/2) {
            if currentPage+1 != activeScrollLabels.count {
                scrollCluePicker.contentOffset.x = scrollCluePicker.contentOffset.x + scrollCluePicker.frame.size.width
                containerView.bringSubview(toFront: activeViews[currentPage+1])
                setupScrollViews(currentPage+1)
                pictureClueView.zoomOut()
                
            }
        }
        
        if sender.location(in: self.view).x < self.view.frame.midX - (scrollCluePicker.frame.size.width/2) {
            if currentPage != 0 {
                scrollCluePicker.contentOffset.x = scrollCluePicker.contentOffset.x - scrollCluePicker.frame.size.width
                containerView.bringSubview(toFront: activeViews[currentPage-1])
                setupScrollViews(currentPage-1)
                pictureClueView.zoomOut()
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        startOffset = scrollView.contentOffset.x
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        func adjustLabels(_ current: UILabel, next: UILabel, movement: CGFloat) {
            print("movement \(movement)")
            next.font = next.font.withSize(13 + 6*movement)
//            next.textColor = UIColor(white: 0.7 + 0.3*movement, alpha: 1)
            current.font = current.font.withSize(19 - 6*movement)
//            current.textColor = UIColor(white: 1 - 0.3*movement, alpha: 1)
        }
        
        let scrollWidth = scrollView.frame.size.width
        
        let currentScrollOffset = scrollView.contentOffset.x
        let wholeMoves = Int((currentScrollOffset-startOffset) / scrollWidth)
        let completedMovement = abs((currentScrollOffset.truncatingRemainder(dividingBy: scrollWidth)) / scrollWidth)
        
        let startingActiveScrollLabel = currentPage + wholeMoves
        
        currentLabel = activeScrollLabels[startingActiveScrollLabel]
        
        if currentScrollOffset < startOffset {
            if startingActiveScrollLabel != 0 {
                nextLabel = activeScrollLabels[startingActiveScrollLabel-1]
                adjustLabels(currentLabel, next: nextLabel, movement: (1-completedMovement))
            }
        }
        if currentScrollOffset > startOffset {
            if startingActiveScrollLabel+1 != activeScrollLabels.count {
                nextLabel = activeScrollLabels[currentPage+1]
               adjustLabels(currentLabel, next: nextLabel, movement: completedMovement)

            }
        }
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        containerView.bringSubview(toFront: activeViews[page])
        setupScrollViews(page)
        pictureClueView.zoomOut()
        
       
    }
}


extension StepViewController : StepCompleteViewControllerDelegate {
    func setTime(_ currentTime : Double) {
        ms = currentTime
    }
}

extension StepViewController : PictureClueViewControllerDelegate {
    func closePan() {
            panEndUp()
    }
}

