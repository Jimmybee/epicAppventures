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
    @IBOutlet weak var compassImageView: UIImageView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var northLabel: UILabel!
    
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
    var timer : NSTimer?
    var ms = 0.0
    
    //Timer
    var currentLabel = UILabel()
    var nextLabel = UILabel()
    var startOffset = CGFloat()
    var currentPage = 0
    
    //ViewVariable
    var activeViews = [UIView]()
    var activeScrollLabels = [UILabel]()
    
    let compassImage = UIImage(named: "White_Arrow_Up")

    
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
        stepNumber = 0
        distanceLabel.text = ""
        compassImageView.alpha = 0
        timerLabel.text = HelperFunctions.formatTime(0, nano: false)
        step = appventure.appventureSteps[0]
        loadControllers()
        setupViews()
        scrollHolder.myScroll = self.scrollCluePicker
        setupScrollViews(0)
        
        Appventure.setCurrentAppventure(self.appventure)
        
    }
//    
//    override func preferredStatusBarStyle() -> UIStatusBarStyle {
//        return UIStatusBarStyle.LightContent
//    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if timer == nil {
            self.startTimer()
        }
    }

    //MARK: Setup
    
    func setupScrollViews(activeLabel: Int) {
        for label in activeScrollLabels {
            label.font = label.font.fontWithSize(13)
            label.textColor = UIColor.grayColor()
        }
        activeScrollLabels[activeLabel].font = activeScrollLabels[activeLabel].font.fontWithSize(19)
        activeScrollLabels[activeLabel].textColor = UIColor.whiteColor()
    }
    
    func loadControllers() {
        func addController (vc: UIViewController) {
            self.addChildViewController(vc)
            self.containerView.insertSubview(vc.view, atIndex: 0)
            vc.view.frame = containerView.bounds
            vc.didMoveToParentViewController(self)
        }

        func addAnswerControllers (vc: UIViewController) {
            self.addChildViewController(vc)
            self.answerContainer.insertSubview(vc.view, atIndex: 0)
            vc.view.frame = answerContainer.bounds
            vc.didMoveToParentViewController(self)
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
        
        //Self Top Bar
        if step.setup[AppventureStep.setup.compassShown]! {
            compassImageView.alpha = 1
            northLabel.alpha = 1
        } else {
            compassImageView.alpha = 0
            northLabel.alpha = 0
        }
        if !step.setup[AppventureStep.setup.distanceShown]! {distanceLabel.text = ""}
        
        //Text
        if  step.setup[AppventureStep.setup.textClue]! {
            textClueView.clueText = step.initialText
            textClueView.setup()
            clueSelectWidth.constant = scrollViewWidth.constant
            activeViews.append(textClueView.view)
            activeScrollLabels.append(scrollClueLabel)
        } else {
            clueSelectWidth.constant = 0
        }
        
        //Sound
        if  step.setup[AppventureStep.setup.soundClue]! {
            if let isSound = step.sound as NSData! {
                soundClueView.sound = isSound
                soundClueView.setupAP()
                soundSelectWidth.constant = scrollViewWidth.constant
                activeViews.append(soundClueView.view)
                activeScrollLabels.append(scrollSoundLabel)
            } else { soundSelectWidth.constant = 0 }
        } else { soundSelectWidth.constant = 0 }
        
        //Image
        if  step.setup[AppventureStep.setup.pictureClue]! {
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
        mapComapassView.stepCoordinate = step.coordinate
        mapComapassView.showLocation = step.setup[AppventureStep.setup.locationShown]!
        mapComapassView.showCompass = step.setup[AppventureStep.setup.compassShown]!
        mapComapassView.showDistance = step.setup[AppventureStep.setup.distanceShown]!
        mapComapassView.setup()
        activeViews.append(mapComapassView.view)
        activeScrollLabels.append(mapScrollLabel)

        
        //Complete
        if step.setup[AppventureStep.setup.checkIn]! {
            checkInHintView.stepLocationName = step.nameOrLocation
            checkInHintView.stepCoordinate = step.coordinate
            checkInHintView.answerHint = self.step.answerHint
            checkInHintView.stepDistance = step.checkInProximity
            checkInHintView.setup()
            checkInHintView.view.alpha = 1
            answerHintView.view.alpha = 0
            extendedHeight = originalHeight + 110
        } else {
            answerHintView.answers = self.step.answerText
            answerHintView.answerHint = self.step.answerHint
            answerHintView.setup()
            checkInHintView.view.alpha = 0
            answerHintView.view.alpha = 1
            extendedHeight = originalHeight + 180
        }
        
        self.view.sendSubviewToBack(containerView)
        
        containerView.bringSubviewToFront(activeViews[0])
        
        setupPan()


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
  
    func setupPan() {
        //panning
        originalHeight = 55
        maxPan = extendedHeight
        panEndDown()
    }
    
    @IBAction func panning(sender: UIPanGestureRecognizer) {
        
        switch (sender.state) {
        case .Began:
            break
        case .Changed:
            yMoved = sender.translationInView(self.view).y
            
            if topExtended == false {
                answerViewHeight.constant = max(min(originalHeight + yMoved, maxPan), originalHeight)
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
        case .Ended:
            if sender.translationInView(self.view).y > (self.extendedHeight - self.originalHeight) / 2 {
                panEndDown()
            } else {
                panEndUp()
            }
            
            break
        case .Possible: break
        case .Cancelled:break
        case .Failed:break
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
    
    
    @IBAction func moreActions(sender: AnyObject) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Exit Appventure", style: UIAlertActionStyle.Destructive, handler: { action in
            self.dismissViewControllerAnimated(false, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Report Content", style: .Default, handler: { action in
            self.flagContent()
        }))
        alert.addAction(UIAlertAction(title: "Instructions", style: .Default, handler: { action in
                self.performSegueWithIdentifier(Constants.PresentInstructions, sender: nil   )
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func flagContent() {
        let stepIs = self.step
        let stepID = stepIs.PFObjectID
        let flaggedContent = FlaggedContent(appventureFKID: self.appventure.PFObjectID!, stepFKID: stepID!)
        flaggedContent.save()
    }
    
    //MARK: Actions for child VCs
    func updateLabel(distance: Double, lastLocation: CLLocation) {
        distanceLabel.text = ("\(HelperFunctions.formatDistance(distance))")
        checkInHintView.lastLocation = lastLocation
    }
    
    func updateLastLocation(lastLocation: CLLocation) {
        checkInHintView.lastLocation = lastLocation
    }
    
    func updateCompass(degree: CGFloat) {
        compassImageView.image? = compassImage!.imageRotatedByDegrees(degree, flip: false)

    }
    
    func updateHintText(hint: String, hintsRecieved: Int) {
        //Text
        if clueSelectWidth.constant != scrollViewWidth.constant {
            clueSelectWidth.constant = scrollViewWidth.constant
            activeViews.insert(textClueView.view, atIndex: 0)
            activeScrollLabels.insert(scrollClueLabel, atIndex: 0)
            setupScrollViews(activeScrollLabels.count - 1)
            containerView.bringSubviewToFront(activeViews[0])
            textClueView.textClueLabe.text = ""
        }
        
        if step.freeHints < hintsRecieved { self.ms += Double(step.hintPenalty)}
        textClueView.textClueLabe.text = textClueView.textClueLabe.text! + "\n\nHint:\n" + hint
    }
    
    
    func stepComplete (){
        let storyBoard = UIStoryboard(name: Storyboards.LaunchAppventure, bundle:nil)
        if appventure.appventureSteps.count == (stepNumber + 1) {
            if let acvc = storyBoard.instantiateViewControllerWithIdentifier(Constants.AppventureComplete) as? AppventureCompleteViewController {
                acvc.appventure = self.appventure
                acvc.completeTime = self.ms
                self.dismissViewControllerAnimated(true, completion: nil)
                self.presentingViewController?.presentViewController(acvc, animated: true, completion: nil)
            }
        } else {
            if let scvc = storyBoard.instantiateViewControllerWithIdentifier(Constants.CompletionVC) as? StepCompleteViewController {
                scvc.step = appventure.appventureSteps[stepNumber]
                scvc.currentTimeD = self.ms
                scvc.delegate = self
                self.presentViewController(scvc, animated: false, completion: nil)
                stepNumber += 1
                step = appventure.appventureSteps[stepNumber]
                setupViews()
                timer?.invalidate()
                timer = nil
                containerView.bringSubviewToFront(answerCheckInView)
            }
        }
    }
    
    
    //MARK: Timer
    
    func startTimer() {
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector(Constants.AppventureTimerFunc), userInfo: nil, repeats: true)
    }
    
    func updateAppventureTimer() {
        self.ms += 1
        let formattedTime = HelperFunctions.formatTime(ms, nano:  false)
        UIView.animateWithDuration(0.01) { () -> Void in
            self.timerLabel.text = formattedTime
        }
    }

}

extension StepViewController : UIScrollViewDelegate {
    
    @IBAction func scrollHolderTapped(sender: UITapGestureRecognizer) {
        currentPage = Int(scrollCluePicker.contentOffset.x / scrollCluePicker.frame.size.width)
        startOffset = scrollCluePicker.contentOffset.x

        if sender.locationInView(self.view).x > self.view.frame.midX + (scrollCluePicker.frame.size.width/2) {
            if currentPage+1 != activeScrollLabels.count {
                scrollCluePicker.contentOffset.x = scrollCluePicker.contentOffset.x + scrollCluePicker.frame.size.width
                containerView.bringSubviewToFront(activeViews[currentPage+1])
                setupScrollViews(currentPage+1)
                pictureClueView.zoomOut()
                
            }
        }
        
        if sender.locationInView(self.view).x < self.view.frame.midX - (scrollCluePicker.frame.size.width/2) {
            if currentPage != 0 {
                scrollCluePicker.contentOffset.x = scrollCluePicker.contentOffset.x - scrollCluePicker.frame.size.width
                containerView.bringSubviewToFront(activeViews[currentPage-1])
                setupScrollViews(currentPage-1)
                pictureClueView.zoomOut()
            }
        }
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        startOffset = scrollView.contentOffset.x
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        
        func adjustLabels(current: UILabel, next: UILabel, movement: CGFloat) {
            print("movement \(movement)")
            next.font = next.font.fontWithSize(13 + 6*movement)
            next.textColor = UIColor(white: 0.7 + 0.3*movement, alpha: 1)
            current.font = current.font.fontWithSize(19 - 6*movement)
            current.textColor = UIColor(white: 1 - 0.3*movement, alpha: 1)
        }
        
        let scrollWidth = scrollView.frame.size.width
        
        let currentScrollOffset = scrollView.contentOffset.x
        let wholeMoves = Int((currentScrollOffset-startOffset) / scrollWidth)
        let completedMovement = abs((currentScrollOffset % scrollWidth) / scrollWidth)
        
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
    
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        containerView.bringSubviewToFront(activeViews[page])
        setupScrollViews(page)
        pictureClueView.zoomOut()
        
       
    }
}


extension StepViewController : StepCompleteViewControllerDelegate {
    func setTime(currentTime : Double) {
        ms = currentTime
    }
}

extension StepViewController : PictureClueViewControllerDelegate {
    func closePan() {
            panEndUp()
    }
}

