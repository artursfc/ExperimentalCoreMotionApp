//
//  ViewController.swift
//  ExperimentalCoreMotionApp
//
//  Created by Artur Carneiro on 17/06/19.
//  Copyright © 2019 Artur Carneiro. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var testView: UIView!
    @IBOutlet weak var myFaceView: UIImageView!
    
    let motion = CMMotionManager()
    
    let originalX : CGFloat = 0
    let originalY : CGFloat = 0
    
    let auxOriginalX : CGFloat = 0
    let auxOriginalY : CGFloat = 0
    
    var counter : Int = 0
    var shouldChange : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startDeviceMotion()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        testLabel.isHidden = true
        testView.isHidden = true
        
        self.myFaceView.image = UIImage(named: "arturComOOculos")
        self.myFaceView.center = self.view.center
        self.myFaceView.frame.size.height = 32
        self.myFaceView.frame.size.width = 32
    }
    
    func startDeviceMotion() {
        if motion.isDeviceMotionAvailable {
            self.motion.deviceMotionUpdateInterval = 1.0 / 60.0
            self.motion.showsDeviceMovementDisplay = true
            self.motion.startDeviceMotionUpdates(using: .xMagneticNorthZVertical)
            
            var timer =  Timer(fire: Date(), interval: (1.0 / 60.0), repeats: true) { (timer) in
                guard let data = self.motion.deviceMotion else { return }
                let userAcc = data.userAcceleration
                
                let xAcc = abs(userAcc.x)
                let yAcc = abs(userAcc.y)
                let zAcc = abs(userAcc.z)
                
                if (xAcc > 0.02) {
                    DispatchQueue.main.async {
//                        guard let aux = Double(self.testLabel.text!) else { return }
//                        self.testLabel.text = String(xAcc+yAcc+zAcc+aux)
                        
                        
                        UIView.animate(withDuration: 0.05, delay: 0, options: [.curveEaseInOut], animations: {
                            
                            self.myFaceView.frame.size.height += CGFloat(xAcc)
                            self.myFaceView.frame.size.width += CGFloat(xAcc)
                            self.myFaceView.center = self.view.center
                            

                            
                        }, completion: nil)
                        self.counter += 1
                        
                        if self.counter == 100 {
                            if self.shouldChange == false {
                                self.myFaceView.image = UIImage(named: "arturComAFlor")
                                self.counter = 0
                                self.shouldChange = true
                            }
                            else {
                                self.myFaceView.image = UIImage(named: "arturComOOculos")
                                self.counter = 0
                                self.shouldChange = false
                            }
                        }
                    }
                }
                
            }
            RunLoop.current.add(timer, forMode: RunLoop.Mode.default)
        }
    }

}

