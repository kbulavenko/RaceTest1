//
//  _PhisicsBody.h
//  RaceTest1
//
//  Created by  Z on 31.05.17.
//  Copyright © 2017  Z. All rights reserved.
//

#ifndef _PhisicsBody_h
#define _PhisicsBody_h


#endif /* _PhisicsBody_h */
/*

 
 
 import SpriteKit
 import simd
 
 //
 //  SKPhysicsBody.h
 //  SpriteKit
 //
 //  Copyright (c) 2011 Apple Inc. All rights reserved.
 //
 
 
 /**
 A SpriteKit physics body. These are the physical representations of your nodes. These specify the area and mass and any collision masking needed.
 
 All bodies have zero, one or more shapes that define its area. A body with no shapes is ethereal and does not collide with other bodies.
 */
open class SKPhysicsBody : NSObject, NSCopying, NSCoding {
    
    
    /**
     Creates a circle of radius r centered at the node's origin.
     @param r the radius in points
     */
    public /*not inherited*/ init(circleOfRadius r: CGFloat)
    
    
    /**
     Creates a circle of radius r centered at a point in the node's coordinate space.
     @param r the radius in points
     */
    public /*not inherited*/ init(circleOfRadius r: CGFloat, center: CGPoint)
    
    
    /**
     Creates a rectangle of the specified size centered at the node's origin.
     @param s the size in points
     */
    public /*not inherited*/ init(rectangleOf s: CGSize)
    
    
    /**
     Creates a rectangle of the specified size centered at a point in the node's coordinate space.
     @param s the size in points
     */
    public /*not inherited*/ init(rectangleOf s: CGSize, center: CGPoint)
    
    
    /**
     The path must represent a convex or concave polygon with counter clockwise winding and no self intersection. Positions are relative to the node's origin.
     @param path the path to use
     */
    public /*not inherited*/ init(polygonFrom path: CGPath)
    
    
    /**
     Creates an edge from p1 to p2. Edges have no volume and are intended to be used to create static environments. Edges can collide with bodies of volume, but not with each other.
     @param p1 start point
     @param p2 end point
     */
    public /*not inherited*/ init(edgeFrom p1: CGPoint, to p2: CGPoint)
    
    
    /**
     Creates an edge chain from a path. The path must have no self intersection. Edges have no volume and are intended to be used to create static environments. Edges can collide with bodies of volume, but not with each other.
     @param path the path to use
     */
    public /*not inherited*/ init(edgeChainFrom path: CGPath)
    
    
    /**
     Creates an edge loop from a path. A loop is automatically created by joining the last point to the first. The path must have no self intersection. Edges have no volume and are intended to be used to create static environments. Edges can collide with body's of volume, but not with each other.
     @param path the path to use
     */
    public /*not inherited*/ init(edgeLoopFrom path: CGPath)
    
    
    /**
     Creates an edge loop from a CGRect. Edges have no volume and are intended to be used to create static environments. Edges can collide with body's of volume, but not with each other.
     @param rect the CGRect to use
     */
    public /*not inherited*/ init(edgeLoopFrom rect: CGRect)
    
    
    /**
     Creates a body from the alpha values in the supplied texture.
     @param texture the texture to be interpreted
     @param size of the generated physics body
     */
    @available(iOS 8.0, *)
    public /*not inherited*/ init(texture: SKTexture, size: CGSize)
    
    
    /**
     Creates a body from the alpha values in the supplied texture.
     @param texture the texture to be interpreted
     @param alphaThreshold the alpha value above which a pixel is interpreted as opaque
     @param size of the generated physics body
     */
    @available(iOS 8.0, *)
    public /*not inherited*/ init(texture: SKTexture, alphaThreshold: Float, size: CGSize)
    
    
    /**
     Creates an compound body that is the union of the bodies used to create it.
     */
    public /*not inherited*/ init(bodies: [SKPhysicsBody])
    
    
    open var isDynamic: Bool
    
    open var usesPreciseCollisionDetection: Bool
    
    open var allowsRotation: Bool
    
    @available(iOS 8.0, *)
    open var pinned: Bool
    
    
    /**
     If the physics simulation has determined that this body is at rest it may set the resting property to YES. Resting bodies do not participate
     in the simulation until some collision with a non-resting  object, or an impulse is applied, that unrests it. If all bodies in the world are resting
     then the simulation as a whole is "at rest".
     */
    open var isResting: Bool
    
    
    /**
     Determines the 'roughness' for the surface of the physics body (0.0 - 1.0). Defaults to 0.2
     */
    open var friction: CGFloat
    
    
    /**
     Specifies the charge on the body. Charge determines the degree to which a body is affected by
     electric and magnetic fields. Note that this is a unitless quantity, it is up to the developer to
     set charge and field strength appropriately. Defaults to 0.0
     */
    @available(iOS 8.0, *)
    open var charge: CGFloat
    
    
    /**
     Determines the 'bounciness' of the physics body (0.0 - 1.0). Defaults to 0.2
     */
    open var restitution: CGFloat
    
    
    /**
     Optionally reduce the body's linear velocity each frame to simulate fluid/air friction. Value should be zero or greater. Defaults to 0.1.
     Used in conjunction with per frame impulses, an object can be made to move at a constant speed. For example, if an object 64 points in size
     and default density and a linearDamping of 25 will slide across the screen in a few seconds if an impulse of magnitude 10 is applied every update.
     */
    open var linearDamping: CGFloat
    
    
    /**
     Optionally reduce the body's angular velocity each frame to simulate rotational friction. (0.0 - 1.0). Defaults to 0.1
     */
    open var angularDamping: CGFloat
    
    
    /**
     The density of the body.
     @discussion
     The unit is arbitrary, as long as the relative densities are consistent throughout the application. Note that density and mass are inherently related (they are directly proportional), so changing one also changes the other. Both are provided so either can be used depending on what is more relevant to your usage.
     */
    open var density: CGFloat
    
    
    /**
     The mass of the body.
     @discussion
     The unit is arbitrary, as long as the relative masses are consistent throughout the application. Note that density and mass are inherently related (they are directly proportional), so changing one also changes the other. Both are provided so either can be used depending on what is more relevant to your usage.
     */
    open var mass: CGFloat
    
    
    /**
     The area of the body.
     @discussion
     The unit is arbitrary, as long as the relative areas are consistent throughout the application.
     */
    open var area: CGFloat { get }
    
    
    /**
     Bodies are affected by field forces such as gravity if this property is set and the field's category mask is set appropriately. The default value is YES.
     @discussion
     If this is set a force is applied to the object based on the mass. Set the field force vector in the scene to modify the strength of the force.
     */
    open var affectedByGravity: Bool
    
    
    /**
     Defines what logical 'categories' of fields this body responds to. Defaults to all bits set (all categories).
     Can be forced off via affectedByGravity.
     */
    @available(iOS 8.0, *)
    open var fieldBitMask: UInt32
    
    
    /**
     Defines what logical 'categories' this body belongs to. Defaults to all bits set (all categories).
     */
    open var categoryBitMask: UInt32
    
    
    /**
     Defines what logical 'categories' of bodies this body responds to collisions with. Defaults to all bits set (all categories).
     */
    open var collisionBitMask: UInt32
    
    
    /**
     Defines what logical 'categories' of bodies this body generates intersection notifications with. Defaults to all bits cleared (no categories).
     */
    open var contactTestBitMask: UInt32
    
    
    open var joints: [SKPhysicsJoint] { get }
    
    
    /**
     The representedObject this physicsBody is currently bound to, or nil if it is not.
     */
    weak open var node: SKNode? { get }
    
    
    open var velocity: CGVector
    
    open var angularVelocity: CGFloat
    
    
    open func applyForce(_ force: CGVector)
    
    open func applyForce(_ force: CGVector, at point: CGPoint)
    
    
    open func applyTorque(_ torque: CGFloat)
    
    
    open func applyImpulse(_ impulse: CGVector)
    
    open func applyImpulse(_ impulse: CGVector, at point: CGPoint)
    
    
    open func applyAngularImpulse(_ impulse: CGFloat)
    
    
    /* Returns an array of all SKPhysicsBodies currently in contact with this one */
    open func allContactedBodies() -> [SKPhysicsBody]
}


*/
