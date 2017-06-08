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
    
    
    var   car                               : SKSpriteNode?
    
    
  //  var   carSpeed                          : CGFloat   =   0;
//    let   carSpeedMax                       : CGFloat   = 250;
    let    maxVelocitySpeed                 : CGFloat   = 1500;
    var   pedalIsPressedTimerIsStarted      : Bool      = false
    var   brakePedalPressedTimerIsStarted   : Bool      = false
    
    var   turnLeftPressedTimerIsStarted     : Bool      = false
    var   turnRightPressedTimerIsStarted    : Bool      = false
    
    
    let   turnStepAngle                     : CGFloat   =   CGFloat.pi / 720.0

    
    //   var   gasPedalTimerCounter              : Int  = 0
    
    var lastTouch                           : CGPoint?  = nil
    var timer                               : Timer     = Timer()
    var timerBrake                          : Timer     = Timer()
    var timerTurnLeft                       : Timer     = Timer()
    var timerTurnRight                      : Timer     = Timer()
    
  //  var stopBackCounter  = 0;
    let smoothnessOfTurn                    :  CGFloat  = 128.0
    var impulsePower                        : CGFloat   =   0;
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

            
            // MARK: Turn LEFT
            
            if touchNode.name == "leftArrow" {
                print("leftArrow Pressed")
                if( self.getCarSpeed() > 1 )  {
                    if(!turnLeftPressedTimerIsStarted )   {
                        timerTurnLeft   = Timer.scheduledTimer(timeInterval: 0.02,
                                                                target: self,
                                                                selector: #selector(self.turnLeftPressed),
                                                                userInfo: nil,
                                                                repeats: true)
                        turnLeftPressedTimerIsStarted   = true;
                    }
                }
                
            }
            
            // MARK: Turn RIGHT
            
            if touchNode.name == "rightArrow" {
                print("rightArrow Pressed")
                
                if(self.getCarSpeed() > 1 )  {
                    if(!turnRightPressedTimerIsStarted )   {
                        timerTurnRight   = Timer.scheduledTimer(timeInterval: 0.02,
                                                                target: self,
                                                                selector: #selector(self.turnRightPressed),
                                                                userInfo: nil,
                                                                repeats: true)
                        turnRightPressedTimerIsStarted   = true;
                    }
                }
            }
            
            
            // MARK: BRAKE Pedal
            
            if touchNode.name == "brakePedal"{
                //write your logic here
                
                print("Brake pedal pressed")
                if(self.getCarSpeed() >= 1 )  {
                    // carSpeed     *= 1.1
                    
                    
                    if(!brakePedalPressedTimerIsStarted )   {
                        timerBrake   = Timer.scheduledTimer(timeInterval: 0.1,
                                                            target: self,
                                                            selector: #selector(self.brakePedalPressed),
                                                            userInfo: nil,
                                                            repeats: true)
                        brakePedalPressedTimerIsStarted   = true;
                    }
                }
            }  // MARK: GAS Pedal
            else   if touchNode.name == "pedal"{
                //write your logic here
                print("Gas pedal is pressed")
                
                //if(carSpeed < carSpeedMax && carSpeed != 0)  {
                   // carSpeed     *= 1.1
                    if(!pedalIsPressedTimerIsStarted )   {
                        timer   = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.pedalPressed), userInfo: nil, repeats: true)
                        pedalIsPressedTimerIsStarted   = true;
                    }
                    
                    
                
            }
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
        
        timerTurnRight.invalidate()
        turnRightPressedTimerIsStarted = false;
        timerTurnLeft.invalidate()
        turnLeftPressedTimerIsStarted = false;
        
        car?.physicsBody?.friction = 0.0; // 0.2
        
        print("self.getCarSpeed()  = \(self.getCarSpeed())")
        
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
      //  if car?.physicsBody?.isResting   == true  {
             car?.physicsBody?.isResting   = false
      //  }
        
    }
 
    func updateCamera() {
        
        let speed   = self.getCarSpeed()
            //= sqrt(Double(  pow((car?.physicsBody?.velocity.dx)! - 0*(car?.position.x)!, 2.0) +  pow((car?.physicsBody?.velocity.dy)! - 0*(car?.position.y)!, 2.0)))
        print("updateCamera  speed  = \(speed)")
        print("dx =\(String(describing: car?.physicsBody?.velocity.dy))  dy = \(String(describing: car?.physicsBody?.velocity.dy))")
        
        let velocityAngle   = atan2((car?.physicsBody?.velocity.dy)!, (car?.physicsBody?.velocity.dx)!)
        
        print("velocityAngle = \(velocityAngle)")
        print("zRotation = \(String(describing: car?.zRotation))")
        
        if let camera = camera {
            camera.position = CGPoint(x: car!.position.x, y: car!.position.y)
           // camera.zRotation  = (car?.zRotation)!
            
        }
        
        
        car?.physicsBody?.linearDamping   =  0.0 + 0.02 * self.getCarSpeed() / maxVelocitySpeed
        print("self.getCarSpeed()  = \(self.getCarSpeed())")
        
        //  print("\(String(describing: car?.physicsBody?.velocity))")
        print("Velocity = \(String(describing: car?.physicsBody?.velocity))")
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
        if(self.getCarSpeed() < maxVelocitySpeed) {
          //  carSpeed   *= 1.1
        
            if(!brakePedalPressedTimerIsStarted)
            {
              // self.makeForce(impulse: 0.00 +  800 * carSpeed  , dxRotation: CGFloat.pi / 2.0, dyRotation: CGFloat.pi / 2.0)
                // Заменить метод
                self.correctVelocity(correction: 1.1)
                
                
            }
        }
        
        
        
        if(self.getCarSpeed() < 0.1) {
            //carSpeed  = 2.0
            self.setVelocityForMove()
            // Вызвать метод ускорения  или заданрия velocity
        }

        
        // updateCamera();
    }

    
    func   brakePedalPressed  () -> Void {
        print("brakePedalPressed")
        if(self.getCarSpeed()  < 1) {
            //carSpeed   = 0
           self.setVelocityForStop()
            // Задать нулевой Velocity
            
            car?.physicsBody?.isResting   = true;
            timerBrake.invalidate()
            brakePedalPressedTimerIsStarted   = false;
          // car?.physicsBody?.friction   = 0.0;  //0.0
            return
        }
        car?.physicsBody?.friction   = 1.0;  //1.0
      //  gasPedalTimerCounter   += 1;
      //  carSpeed   /= 1.1;
        
       self.correctVelocity(correction: 0.8)
        
       //  Вызвать метод чтобу уменьшить Velocity
        
        
        
        print("takeImpulse back")
        
      //  self.makeForce(impulse: 0.045  + 0.0015 * carSpeed, dxRotation: -CGFloat.pi / 2.0, dyRotation: CGFloat.pi / 2.0)
      
        //это пока можно закомментить
      //  self.makeForce(impulse: 600.0  + 30000.0 * carSpeed / carSpeedMax, dxRotation: -CGFloat.pi / 2.0, dyRotation: CGFloat.pi / 2.0)
        
      
        
        
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
    
    
    
    func setVelocityForStop() -> Void {
        //        let  dx1  : CGFloat    =   0.1
        //        let  dy1  : CGFloat    =   0.1
//        
//        let  angleVelocity   : CGFloat   =  CGFloat.pi
//        //atan2(dy1, dx1)
//        //
//        //        let  newAngleVelocity  : CGFloat =  angleVelocity  + rotation
//        
//        
//        let velocitySpeed  : CGFloat  =  0.0
//        // self.getCarSpeed()
//        
//        let   dx   : CGFloat   =  velocitySpeed    *  cos(angleVelocity)
//        let   dy   : CGFloat   =  velocitySpeed    *  sin(angleVelocity)
//        let   stringForVector  : String =  String(format: "%f,%f", dx, dy)
//        print("stringForVector = \(stringForVector)")
        car?.physicsBody?.velocity  = CGVector.init(dx: 0.0, dy: 0.0)
        
    }

    
    
    func setVelocityForMove() -> Void {
//        let  dx1  : CGFloat    =   0.1
//        let  dy1  : CGFloat    =   0.1
        
        let  angleVelocity   : CGFloat   =   CGFloat.pi / 2.0  + (self.camera?.zRotation)!
            //atan2(dy1, dx1)
        //
        //        let  newAngleVelocity  : CGFloat =  angleVelocity  + rotation
        
        
        let velocitySpeed  : CGFloat  =  0.5
           // self.getCarSpeed()
        
        let   dx   : CGFloat   =  velocitySpeed    *  cos(angleVelocity)
        let   dy   : CGFloat   =  velocitySpeed    *  sin(angleVelocity)
        let   stringForVector  : String =  String(format: "%f,%f", dx, dy)
        print("stringForVector = \(stringForVector)")
        car?.physicsBody?.velocity  = CGVector.init(dx: dx, dy: dy)

    }
    
    
    func correctVelocity(correction: CGFloat) -> Void {
        let  dx1  : CGFloat    =   CGFloat( (car?.physicsBody?.velocity.dx.native)!)
        let  dy1  : CGFloat    =   CGFloat( (car?.physicsBody?.velocity.dy.native)!)
        
        let  angleVelocity   : CGFloat   = atan2(dy1, dx1)
//        
//        let  newAngleVelocity  : CGFloat =  angleVelocity  + rotation
        
        
        let velocitySpeed   =  self.getCarSpeed()
        
        let   dx   : CGFloat   =  velocitySpeed  * correction   *  cos(angleVelocity)
        let   dy   : CGFloat   =  velocitySpeed  * correction   *  sin(angleVelocity)
        let   stringForVector  : String =  String(format: "%f,%f", dx, dy)
        print("stringForVector = \(stringForVector)")
        car?.physicsBody?.velocity  = CGVector.init(dx: dx, dy: dy)
    }
    
    
/*
    
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

        
        
//        impulsePower  = impulse;
//        print("impulsePower  = \(impulsePower)")
//        // Create a vector in the direction the sprite is facing
//        let dx : CGFloat = impulse * cos (car!.zRotation + dxRotation);
//        let dy : CGFloat = impulse * sin (car!.zRotation + dyRotation);
//        
//        // Apply impulse to physics body
//        // car!.physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))
//        car!.physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))
        
        
        
        
    }

    
    */
    
    func turnCarLeft() -> Void {
        turnCar(angle: turnStepAngle)
    }
    
    func turnCarRight() -> Void {
        turnCar(angle: -turnStepAngle)
    }
    
    
    func turnCar(angle: CGFloat ) -> Void {
        let    rotation   = angle  * log( self.getCarSpeed() + 1 ) * 4.0  / log( maxVelocitySpeed + 1)
        
        
        
        
        
        let  dx1  : CGFloat    =   CGFloat( (car?.physicsBody?.velocity.dx.native)!)
        let  dy1  : CGFloat    =   CGFloat( (car?.physicsBody?.velocity.dy.native)!)
        
        
        
        let  angleVelocity   : CGFloat   = atan2(dy1, dx1)
        
        let  newAngleVelocity  : CGFloat =  angleVelocity  + rotation
        
        
        let velocitySpeed   =  self.getCarSpeed()
        
        let   dx   : CGFloat   = velocitySpeed * cos(newAngleVelocity )
        let   dy   : CGFloat   =  velocitySpeed * sin(newAngleVelocity )
        let   stringForVector  : String =  String(format: "%f,%f", dx, dy)
        print("stringForVector = \(stringForVector)")
        car?.physicsBody?.velocity  = CGVector.init(dx: dx, dy: dy)
        
        car?.zRotation      += rotation
        camera?.zRotation   += rotation
        

    }
    
    
    
    
    
    func  getCarSpeed() -> CGFloat {
         return sqrt(pow((car?.physicsBody?.velocity.dx)! - 0*(car?.position.x)!, 2.0) +  pow((car?.physicsBody?.velocity.dy)! - 0*(car?.position.y)!, 2.0))
    }
    
    
    
    
    func   turnLeftPressed  () -> Void {
        print("turnLeftPressed")
        if(self.getCarSpeed() < 2.0) {
            timerTurnLeft.invalidate()
            turnLeftPressedTimerIsStarted   = false;
            return
        }
       // car?.physicsBody?.friction   = 1.0;  //1.0
      //  carSpeed   /= 1.1;
        print("take Rotate Turn Left")
        
        
        self.turnCarLeft()
        //self.makeForce(impulse: 600.0  + 35000.0 * carSpeed / carSpeedMax, dxRotation: -CGFloat.pi / 2.0, dyRotation: CGFloat.pi / 2.0)
        
    }

    func   turnRightPressed  () -> Void {
        print("turnRightPressed")
        if( self.getCarSpeed()  < 2.0) {
            timerTurnRight.invalidate()
            turnLeftPressedTimerIsStarted   = false;
            return
        }
        // car?.physicsBody?.friction   = 1.0;  //1.0
        //  carSpeed   /= 1.1;
        print("take Rotate Turn Right")
        
        
        self.turnCarRight()
        //self.makeForce(impulse: 600.0  + 35000.0 * carSpeed / carSpeedMax, dxRotation: -CGFloat.pi / 2.0, dyRotation: CGFloat.pi / 2.0)
        
    }

    func carGas() -> Void {
        
    }
    

}
