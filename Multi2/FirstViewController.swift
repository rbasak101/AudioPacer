//
//  FirstViewController.swift
//  Multi2
//
//  Created by Ron Basak on 7/16/20.
//  Copyright © 2020 RB. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation
import GoogleMobileAds
class CellClass: UITableViewCell {    // DropDown
    
}

class FirstViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var speedLabel: UILabel!
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var btnSelectUnits: UIButton!
    let transparentView = UIView() // DropDown
    let tableView = UITableView() // DropDown
    var dataSource = [String]() // DropDown
    var selectedButton = UIButton() // DropDown
    
    @IBOutlet weak var flipper: UISwitch!
     var switchState = true
    
    @IBOutlet weak var speedField: UITextField!
    var lowAudio: AVAudioPlayer = AVAudioPlayer()
    var highAudio: AVAudioPlayer = AVAudioPlayer()
    
    var low = true
    var high = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bannerView.adUnitID = "ca-app-pub-1207343093976281/2016965111" //actual
        //bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716" //test
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
        
        speedField.delegate = self
        locationManager.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CellClass.self, forCellReuseIdentifier: "Cell")
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        //locationManager.stopUpdatingLocation()
        
        do {
            let audioPathLow = Bundle.main.path(forResource: "LowPitch2", ofType: "mp3")
            try lowAudio = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPathLow!) as URL)
         
            let audioPathHigh = Bundle.main.path(forResource: "HighPitch2", ofType: "mp3")
            try highAudio = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPathHigh!) as URL)
                        
            } catch {
            
            }
    }
    
    func addTransparentView(frames: CGRect) {   // DropDown
        let window = UIApplication.shared.keyWindow
        transparentView.frame = window?.frame ?? self.view.frame
        self.view.addSubview(transparentView)
                    
        tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        self.view.addSubview(tableView)
        tableView.layer.cornerRadius = 5
                    
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
                    tableView.reloadData()
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        transparentView.addGestureRecognizer(tapgesture)
        transparentView.alpha = 0
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                        self.transparentView.alpha = 0.5
                        self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: CGFloat(self.dataSource.count * 50))
                    }, completion: nil)
    }
    
    @objc func removeTransparentView() {  //DropDown
        let frames = selectedButton.frame
               UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                   self.transparentView.alpha = 0
                   self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
            }, completion: nil)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           let location = locations[0];
           var pace = (speedField.text! as NSString).doubleValue
           pace = roundTenth(pace)
           print(location.speed)
           if(switchState == true) {
                locationManager.startUpdatingLocation() // ins
                if(selectedButton.titleLabel?.text == "M/S") {
                    let ms = location.speed
                    speedLabel.text = String(format: "%.2f",ms)
                } else if(selectedButton.titleLabel?.text == "KM/H") {
                    let kmh = location.speed * 3.6
                    speedLabel.text = String(format: "%.1f",kmh)
                } else {
                    let mph = location.speed * 2.24
                    speedLabel.text = String(format: "%.2f",mph)
                }
            
                let actualSpeed = location.speed * 2.24
                if(pace > actualSpeed && pace > 0) {
                        if(low == true) {
                            lowAudio.play()
                            low = false
                            high = true
                        }
                } else if(pace < actualSpeed && pace > 0 && high == true) {
                        if(high == true) {
                            highAudio.play()
                            high = false
                            low = true
                        }
                }
            
           } 
       }
    
    func roundTenth(_ value: Double) -> Double {
        return round(value / 0.1) * 0.1
    }

    @IBAction func onClickSelectUnits(_ sender: Any) {
        dataSource = ["MPH", "M/S", "KM/H"]
        selectedButton = btnSelectUnits
        addTransparentView(frames: btnSelectUnits.frame)
    }
    
    @IBAction func changingState(_ sender: UISwitch) {
        if(sender.isOn == true) {
            switchState = true;
            print(switchState)
        } else {
            switchState = false;
            print(switchState)
            }
    }
    
    
    
}


extension FirstViewController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
    
        /*if(dataSource[indexPath.row] == "M/S") {
            
        }*/
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedButton.setTitle(dataSource[indexPath.row], for: .normal)
        removeTransparentView()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        speedField.resignFirstResponder()
        return true
    }
}

extension FirstViewController: GADBannerViewDelegate {
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("recieved ad")
    }
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Failed to recieve ads")
        print(error)
    }
}
