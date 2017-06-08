//
//  GameScene.swift
//  RaceTest1
//
//  Created by  Z on 26.05.17.
//  Copyright © 2017  Z. All rights reserved.
//

import SpriteKit
#if os(watchOS)
    import WatchKit
    // SKColor typealias does not seem to be exposed on watchOS SpriteKit
    typealias SKColor = UIColor
#endif

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
  //  fileprivate var label : SKLabelNode?
   // fileprivate var spinnyNode : SKShapeNode?

    // MARK:  - Instance variable
    
    
    var   carSpeed                          : CGFloat =   0;
    
    let   carSpeedMax                       : CGFloat  = 250;
    var   car                               : SKSpriteNode?
    var   pedalIsPressedTimerIsStarted      : Bool  = false
    var   brakePedalPressedTimerIsStarted   : Bool  = false
 //   var   gasPedalTimerCounter              : Int  = 0
    
    var lastTouch: CGPoint? = nil
    var timer  = Timer()
    var timerBrake   = Timer()
    var stopBackCounter  = 0;
    let smoothnessOfTurn  :  CGFloat   = 128.0
    var impulsePower  : CGFloat  =   0;
    // MARK:  -  SKScene
    
    
    
    class func newGameScene() -> GameScene {
        // Load 'GameScene.sks' as an SKScene.
        print("newGameScene")
        guard let scene = SKScene(fileNamed: "GameScene") as? GameScene else {
            print("Failed to load GameScene.sks")
            abort()
        }
        
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        
        return scene
    }
    
    override func didMove(to view: SKView) {
        print("didMove")
        // self.setUpScene()
        // Setup physics world's contact delegate
        physicsWorld.contactDelegate = self
        
        
        // Настрока машины
        car  = self.childNode(withName: "car") as? SKSpriteNode
        self.listener   = car;
        
        // Setup initial camera position
        updateCamera()
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
      //  print("update")
    }

    // MARK: Touch Handling
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      //  print("touchesBegan")
        for touch in touches{
            let location = touch.location(in: self)
            let touchNode = atPoint(location)
            print("\(String(describing: touchNode.name))")

            if touchNode.name == "leftArrow" {
                print("leftArrow Pressed")
                if(carSpeed >= 2)  {
                    print("\(String(describing: car?.physicsBody))")
                    
                   // self.makeForce(impulse: impulsePower * 5 , dxRotation: -CGFloat.pi / 2.0, dyRotation: CGFloat.pi / 2.0)
                    
                    
                    
                    car?.zRotation   +=  CGFloat.pi / smoothnessOfTurn
                    camera?.zRotation +=  CGFloat.pi / smoothnessOfTurn
                    
                 //   self.makeForce(impulse: impulsePower * 2 , dxRotation: CGFloat.pi / 2.0, dyRotation: CGFloat.pi / 2.0)
                    

                }
                
            }
            
            
            if touchNode.name == "rightArrow" {
                print("rightArrow Pressed")
                if(carSpeed >= 2)  {
                    
                    car?.zRotation   -=  CGFloat.pi / smoothnessOfTurn
                    camera?.zRotation -=  CGFloat.pi / smoothnessOfTurn
                }
                
            }
            
            
            if touchNode.name == "brakePedal"{
                //write your logic here
                
                print("Brake pedal pressed")
                if(carSpeed >= 1 )  {
                    // carSpeed     *= 1.1
                    
                    
                    if(!brakePedalPressedTimerIsStarted )   {
                        timerBrake   = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.brakePedalPressed), userInfo: nil, repeats: true)
                        brakePedalPressedTimerIsStarted   = true;
                    }
                    
                    
                }
            }
            else   if touchNode.name == "pedal"{
                //write your logic here
               
                print("Gas pedal is pressed")
                
                
                
                
                //if(carSpeed < carSpeedMax && carSpeed != 0)  {
                   // carSpeed     *= 1.1
                    if(!pedalIsPressedTimerIsStarted )   {
                        timer   = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.pedalPressed), userInfo: nil, repeats: true)
                        pedalIsPressedTimerIsStarted   = true;
                    }
                    
                    
//                }
//                else if(carSpeed  == 0)  {
//                    carSpeed   = 2.0;
//                    if(!pedalIsPressedTimerIsStarted )   {
//                        timer   = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.pedalPressed), userInfo: nil, repeats: true)
//                        pedalIsPressedTimerIsStarted   = true;
//                    }

                    
                //}
                
            }
          //  print("carSpeed  = \(carSpeed)")
         //   print("velocity  = \(String(describing: car?.physicsBody?.velocity))")
         //   print("position = \(String(describing: car?.position))")
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesMoved")
       // handleTouches(touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesEnded")
       // handleTouches(touches)
        
        timer.invalidate()
        pedalIsPressedTimerIsStarted   = false;
        timerBrake.invalidate()
        brakePedalPressedTimerIsStarted = false;
        car?.physicsBody?.friction = 0.0; // 0.2
        
        print("carSpeed  = \(carSpeed)")
        
      //  print("\(String(describing: car?.physicsBody?.velocity))")
        print("velocity = \(String(describing: car?.physicsBody?.velocity))")
        print("position =\(String(describing: car?.position))")

        
    }
    
    // MARK - Updates
    
    override func didSimulatePhysics() {
      //  print("didSimulatePhysics")
        if let _ = car {
            updateCar()
          //  updateZombies()
        }
    }
    
//    // Determines if the car's position should be updated
//    fileprivate func shouldMove(currentPosition: CGPoint, touchPosition: CGPoint) -> Bool {
//     //   print("shouldMove")
//        
//        return true
//            //abs(currentPosition.x - touchPosition.x) > car!.frame.width / 2 ||
//           // abs(currentPosition.y - touchPosition.y) > car!.frame.height/2
//    }
//
    
    
    // Updates the car's position by moving towards the last touch made
    func updateCar() {
     //   print("updateCar")
        
        
      //  if(pedalIsPressedTimerIsStarted &&  !brakePedalPressedTimerIsStarted)
   //     {
        
        
      //  self.makeForce(impulse: 0.00 +  0.004 * log(carSpeed + 1) , dxRotation: CGFloat.pi / 2.0, dyRotation: CGFloat.pi / 2.0)
//        if(!brakePedalPressedTimerIsStarted)
//        {
//            self.makeForce(impulse: 0.00 +  800 * log(carSpeed + 1) , dxRotation: CGFloat.pi / 2.0, dyRotation: CGFloat.pi / 2.0)
//        }
        
//        // Specify the force to apply to the SKPhysicsBody
//      //  let r  : CGFloat = 0.00 +  0.004 * log(carSpeed + 1)
//        
//        let r  : CGFloat = 0.00 +  0.4 * log(carSpeed + 1)
//        forcePower  = r;
//        print("forcePower  = \(forcePower)")
//        // Create a vector in the direction the sprite is facing
//        let dx : CGFloat = r * cos (car!.zRotation + CGFloat.pi / 2.0);
//        let dy : CGFloat = r * sin (car!.zRotation + CGFloat.pi / 2.0);
//        
//        // Apply impulse to physics body
//       // car!.physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))
//        car!.physicsBody?.applyForce(CGVector(dx: dx, dy: dy))
//        
     //   }
//        if(brakePedalPressedTimerIsStarted)    {
//            // Specify the force to apply to the SKPhysicsBody
//            let r  : CGFloat =  0.0015
//            
//            // Create a vector in the direction the sprite is facing
//            let dx : CGFloat = r * cos (car!.zRotation + CGFloat.pi / 2.0);
//            let dy : CGFloat = r * sin (car!.zRotation - CGFloat.pi / 2.0);
//            
//            // Apply impulse to physics body
//            car!.physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))
//            //car!.physicsBody?.
//        }
        
         updateCamera();
        if car?.physicsBody?.isResting   == true  {
             car?.physicsBody?.isResting   = false
        }
        
    }
 
    func updateCamera() {
        
        let speed  = sqrt(Double(  pow((car?.physicsBody?.velocity.dx)! - 0*(car?.position.x)!, 2.0) +  pow((car?.physicsBody?.velocity.dy)! - 0*(car?.position.y)!, 2.0)))
        print("updateCamera  speed  = \(speed)")
        print("dx =\(String(describing: car?.physicsBody?.velocity.dy))  dy = \(String(describing: car?.physicsBody?.velocity.dy))")
        
        let velocityAngle   = atan2((car?.physicsBody?.velocity.dy)!, (car?.physicsBody?.velocity.dx)!)
        
        print("velocityAngle = \(velocityAngle)")
        print("zRotation = \(String(describing: car?.zRotation))")
        
        if let camera = camera {
            camera.position = CGPoint(x: car!.position.x, y: car!.position.y)
           // camera.zRotation  = (car?.zRotation)!
            
        }
        
        
        car?.physicsBody?.linearDamping   =  0.0 + 0.02 * carSpeed / carSpeedMax
        print("carSpeed  = \(carSpeed)")
        
        //  print("\(String(describing: car?.physicsBody?.velocity))")
     //   print("Velocity = \(String(describing: car?.physicsBody?.velocity))")
     //   print("Position = \(String(describing: car?.position))")

    }

      func   pedalPressed  () -> Void {
        print("Gas pedal pressed")
       // if(carSpeed * 1.1 > carSpeedMax) {
          //  timer.invalidate()
         //   pedalIsPressedTimerIsStarted   = false;
        //    return
      //  }
     //   gasPedalTimerCounter   += 1;
        if(carSpeed * 1.1 < carSpeedMax) {
            carSpeed   *= 1.1
        }
        if(!brakePedalPressedTimerIsStarted)
        {
            self.makeForce(impulse: 0.00 +  800 * carSpeed  , dxRotation: CGFloat.pi / 2.0, dyRotation: CGFloat.pi / 2.0)
        }
        
        
        
        if(carSpeed == 0) {
            carSpeed  = 2.0
        }

        
        // updateCamera();
    }

    
    func   brakePedalPressed  () -> Void {
        print("brakePedalPressed")
        if(carSpeed / 1.1 < 2) {
            carSpeed   = 0
            car?.physicsBody?.isResting   = true;
            timer.invalidate()
            brakePedalPressedTimerIsStarted   = false;
          // car?.physicsBody?.friction   = 0.0;  //0.0
            return
        }
        car?.physicsBody?.friction   = 1.0;  //1.0
      //  gasPedalTimerCounter   += 1;
        carSpeed   /= 1.1;
        
        
        
        
        print("takeImpulse back")
        
      //  self.makeForce(impulse: 0.045  + 0.0015 * carSpeed, dxRotation: -CGFloat.pi / 2.0, dyRotation: CGFloat.pi / 2.0)
         self.makeForce(impulse: 600.0  + 35000.0 * carSpeed / carSpeedMax, dxRotation: -CGFloat.pi / 2.0, dyRotation: CGFloat.pi / 2.0)
        
//        // Specify the force to apply to the SKPhysicsBody
////        let r  : CGFloat =  0.045  + 0.0015 * carSpeed
//
//        let r  : CGFloat =  0.45  + 0.15 * carSpeed
//        forcePower  = r;
//        print("forcePower  = \(forcePower)")
//        // Create a vector in the direction the sprite is facing
//        let dx : CGFloat = r * cos (car!.zRotation - CGFloat.pi / 2.0);
//        let dy : CGFloat = r * sin (car!.zRotation + CGFloat.pi / 2.0);
//
//        // Apply impulse to physics body
//       // car!.physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))
//         car!.physicsBody?.applyForce(CGVector(dx: dx, dy: dy))
//        //car!.physicsBody?.
//
//       
//        //updateCar()
//      //  updateCamera()
        
        
        
    }

    
    func makeForce(impulse:   CGFloat ,dxRotation: CGFloat, dyRotation: CGFloat) -> Void {
        print("makeForce with impulse : \(impulse), dx = \(dxRotation), dy = \(dyRotation)")
        // Specify the force to apply to the SKPhysicsBody
        //        let r  : CGFloat =  0.045  + 0.0015 * carSpeed
     //   var   r   : CGFloat    = 0 ;
        
//        if(dxRotation < 0) {
//        
//            //let r  : CGFloat =  0.045  + 0.0015 * carSpeed
//            //
//            //        let r  : CGFloat =  0.45  + 0.15 * carSpeed
//            
//            r  =  0.045  + 0.0015 * carSpeed        }
//        else {
//            
//            //      //  let r  : CGFloat = 0.00 +  0.004 * log(carSpeed + 1)
//            //
//            //        let r  : CGFloat = 0.00 +  0.4 * log(carSpeed + 1)
//
//            
//            r   = 0.00 +  0.004 * log(carSpeed + 1)
//
//
//        }
        impulsePower  = impulse;
        print("impulsePower  = \(impulsePower)")
        // Create a vector in the direction the sprite is facing
        let dx : CGFloat = impulse * cos (car!.zRotation + dxRotation);
        let dy : CGFloat = impulse * sin (car!.zRotation + dyRotation);
        
        // Apply impulse to physics body
        // car!.physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))
        car!.physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))
    }

    
    func turnLeft() -> Void {
        
    }
    
    

}
