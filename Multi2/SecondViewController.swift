//
//  SecondViewController.swift
//  Multi2
//
//  Created by Ron Basak on 7/16/20.
//  Copyright © 2020 RB. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
  
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var start: UIButton!
    @IBOutlet weak var reset: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var flipper: UISwitch!
    
    
    var timer = Timer()
    var counter = 0.0
    var isStarted = false
    var splitsArray = [String]()
    var switchPosition = true;
    var player: AVAudioPlayer = AVAudioPlayer()
    
    //var resetTapped = false
    override func viewDidLoad() {
        super.viewDidLoad()
        start.layer.cornerRadius = start.bounds.width/2
        reset.layer.cornerRadius = start.bounds.width/2
        timerLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 60, weight: UIFont.Weight.medium)
        do {
            let audioPath = Bundle.main.path(forResource: "5sec7.0", ofType: "mp3")
            try player = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
             player.numberOfLoops = -1
        } catch {
            //
        }
        // Do any additional setup after loading the view.
    }

    @objc func updateTimerLabel() {
        counter += 0.1
        let floorCounter = Int(floor(counter))
        let minute = (floorCounter % 3600) / 60
        
        var minuteString = "\(minute)"
        if( minute < 10) {
            minuteString = "0\(minute)"
        }
        let second = (floorCounter % 3600) % 60
        var secondString = "\(second)"
        if( second < 10) {
            secondString = "0\(second)"
        }
        let decisecond = String(format: "%.1f", counter).components(separatedBy: ".").last!
        
        timerLabel.text = "\(minuteString):\(secondString).\(decisecond)"
       // timerLabel.text = String(round(counter*10)/10)
        
    }
    @IBAction func startTapped(_ sender: UIButton) {
        if(isStarted) { // start not clicked
            timer.invalidate()
            isStarted = false
            start.setTitle("Start", for: .normal)
            reset.setTitle("Reset", for: .normal)
                if(switchPosition == true) {
                    player.pause()
                    flipper.isHidden = false
                }
        } else {
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimerLabel), userInfo: nil, repeats: true)
            RunLoop.current.add(timer, forMode: .common) // ins
            isStarted = true
            start.setTitle("Stop", for: .normal)
            reset.setTitle("Split", for: .normal)
            
            if(switchPosition == true) {
                player.play()
                flipper.isHidden = true
            }
            flipper.isHidden = true // inserted
            
        }
    }
    
    
    @IBAction func reset(_ sender: UIButton) {
        
        if(isStarted) {
            start.setTitle("Stop", for: .normal) //split buttonn shows up (display times below)
            splitsArray.append(timerLabel.text!)
            tableView.reloadData()
        } else {
            counter = 0.0
            timerLabel.text = "00:00.0"
            timer.invalidate()
            splitsArray.removeAll()
            tableView.reloadData()
            reset.setTitle("Reset", for: .normal)
            
            if(switchPosition == true) {
                player.currentTime = 0;
                player.pause()
            }
             flipper.isHidden = false
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return splitsArray.count
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "splitsCell")
        cell?.textLabel?.text = splitsArray[indexPath.row]
        return cell!
      }
    
    
    @IBAction func changingState(_ sender: UISwitch) {
        if(sender.isOn == true) {
            switchPosition = true;
        } else {
            switchPosition = false;
        }
    }

    
}

// Live Speed Display + Units, Stopwatch    Check
// Splits  (2 hours)                        Check
// Audio for stopwatch (3 hours)            Check
// Combine: Speed Display + Stop (1 Hour)   Check
// Way of turning off speed display (.5 Hr) Check
// Running pace/max speed audio mph         Check
// Debug + Fix                              
// Design (3 hours)                         Check

