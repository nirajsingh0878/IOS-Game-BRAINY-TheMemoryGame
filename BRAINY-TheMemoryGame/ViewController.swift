
import UIKit
import AVFoundation

class ViewController: UIViewController,AVAudioPlayerDelegate {

    @IBOutlet weak var startGameButton: UIButton!
    
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet var soundButton: [UIButton]!
    
    
    @IBOutlet weak var currentScorelabel: UILabel!
    
    @IBOutlet weak var highScorelabel: UILabel!
    
    
    
    var gameOver = false
    
    //for updating high Score
    var scoreCurrent = 0
    var highScore = 0
    
    var sound1Player:AVAudioPlayer!
    var sound2Player:AVAudioPlayer!
    var sound3Player:AVAudioPlayer!
    var sound4Player:AVAudioPlayer!
    
    var playList=[Int]()
    var currentItem = 0
    var numberOfTabs = 0
    var readyForUser = false
    
    var level = 1
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudioFiles()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func setupAudioFiles(){
        
        let soundFilePath = Bundle.main.path(forResource:"1",ofType:"wav")
        let soundFileURL = URL(fileURLWithPath: soundFilePath!)
        
        let soundFilePath2 = Bundle.main.path(forResource:"2",ofType:"wav")
        let soundFileURL2 = URL(fileURLWithPath: soundFilePath2!)
        
        let soundFilePath3 = Bundle.main.path(forResource:"3",ofType:"wav")
        let soundFileURL3 = URL(fileURLWithPath: soundFilePath3!)
        
        let soundFilePath4 = Bundle.main.path(forResource:"4",ofType:"wav")
        let soundFileURL4 = URL(fileURLWithPath: soundFilePath4!)
        
       do {
            try sound1Player = AVAudioPlayer(contentsOf: soundFileURL)
            try sound2Player = AVAudioPlayer(contentsOf: soundFileURL2)
            try sound3Player = AVAudioPlayer(contentsOf: soundFileURL3)
            try sound4Player = AVAudioPlayer(contentsOf: soundFileURL4)
            
        } catch {
            print(error)
        }
        sound1Player.delegate = self
        sound2Player.delegate = self
        sound3Player.delegate = self
        sound4Player.delegate = self
        
        sound1Player.numberOfLoops = 0
        sound2Player.numberOfLoops = 0
        sound3Player.numberOfLoops = 0
        sound4Player.numberOfLoops = 0
        
    }
    
    @IBAction func soundButtonPressed(_ sender: Any) {
        
        if readyForUser {
            
        let button = sender as! UIButton
        
        switch button.tag {
        case 1:
            sound1Player.play()
            checkIfCorrect(buttonPressed: 1)
        case 2:
            sound2Player.play()
            checkIfCorrect(buttonPressed: 2)
        case 3:
            sound3Player.play()
            checkIfCorrect(buttonPressed: 3)
        case 4:
            sound4Player.play()
            checkIfCorrect(buttonPressed: 4)
            
        default:
            break
        }
      }
    }
    
    func checkIfCorrect(buttonPressed:Int){
        print(numberOfTabs)
        if buttonPressed == playList[numberOfTabs] {
              if numberOfTabs == playList.count - 1 {  //we have arrived at last item of playlist
                print("check")
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)){
                    self.nextRound()
                }
                
             //  let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW),Int64(NSEC_PER_SEC))
            //    dispatch_after(time,dispatch_get_main_queue(),{self.nextRound()})
                
                return
            }
            numberOfTabs += 1
        }
        
        else {  //Game Over
                //resetGame
           resetGame()
            }
    }
    
    func resetGame(){
        
        print("resetGAme")
        if scoreCurrent >= highScore {
            highScorelabel.text = "Highest Score: \(scoreCurrent)"
            
        }
        
        currentScorelabel.text = "Your Score Is:0"
        gameOver = true
        level = 1
        readyForUser = false
        numberOfTabs = 0
        currentItem = 0
        playList = []
        levelLabel.text = "Game Over"
        startGameButton.isHidden = false
        disableButtons()
    }
    
    func nextRound() {
        
        print("nextRound")
        level += 1
     scoreCurrent = (level * (level + 1)) / 2
        levelLabel.text = "Level \(level)"
        currentScorelabel.text = "Your Score Is \(scoreCurrent) "
        readyForUser = false
        numberOfTabs = 0
        currentItem = 0
        disableButtons()
        
        let  randomNumber = Int (arc4random_uniform(4) + 1 )
        playList.append(randomNumber)
        playNextItem()
        //disableButton
    }
    
    
    @IBAction func startGame(_ sender: Any) {
        gameOver = false
        levelLabel.text = "Level 1"
        disableButtons()
        let randomNumber = Int(arc4random_uniform(4) + 1 )
        playList.append(randomNumber)
        startGameButton.isHidden=true
        playNextItem()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        if currentItem <= playList.count - 1 {
            playNextItem()
        }
        else if !gameOver {
            
            readyForUser = true
            resetButtonHighlights()
            enableButtons()
            //resetButtonHighlights
            //enable Buttons
            
        }
        else {
            resetButtonHighlights()
            
        }
    
    }
    func playNextItem(){
        let selectedItem = playList[currentItem]
        
        switch selectedItem {
        case 1:
            highlightButtonWithTag(Tag: 1)
            sound1Player.play()
            break
        case 2:
            highlightButtonWithTag(Tag: 2)
            sound2Player.play()
            break
        case 3:
            highlightButtonWithTag(Tag: 3)
            sound3Player.play()
            break
        case 4:
            highlightButtonWithTag(Tag: 4)
            sound4Player.play()
            break
        default:
            break
        }
        
        currentItem += 1
    }
    
    func highlightButtonWithTag (Tag:Int){
        
        switch Tag {
        case 1:
            resetButtonHighlights()
            soundButton[Tag - 1].setImage(UIImage(named:"redPressed"), for: .normal)
        case 2:
            resetButtonHighlights()
            soundButton[Tag - 1].setImage(UIImage(named:"yellowPressed"), for: .normal)
        case 3:
            resetButtonHighlights()
            soundButton[Tag - 1].setImage(UIImage(named:"bluePressed"), for: .normal)
        case 4:
            resetButtonHighlights()
            soundButton[Tag - 1].setImage(UIImage(named:"greenPressed"), for: .normal)
            
        default:
            break
        }
    }
    
    

    func disableButtons(){
        for button in soundButton {
            button.isUserInteractionEnabled = false
        }
    }
    func enableButtons(){
        for button in soundButton {
            button.isUserInteractionEnabled = true
        }
        
    }
    
    
    
    
    
    func resetButtonHighlights(){
        soundButton[0].setImage(UIImage(named:"red"), for: .normal)
        soundButton[1].setImage(UIImage(named:"yellow"), for: .normal)
        soundButton[2].setImage(UIImage(named:"blue"), for: .normal)
        soundButton[3].setImage(UIImage(named:"green"), for: .normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

