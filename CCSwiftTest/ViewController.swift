//
//  ViewController.swift
//  CCSwiftTest
//
//  Created by Satyar Mansouri on 9/18/20.
//  Copyright © 2020 oulu. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    
    //Button of Taking SnapShot
    @IBOutlet weak var btn: UIButton!
    @IBAction func btn_take_snap(_ sender: Any) {
        
        let screenshot_take = self.view.take_screen()
        
        
        // SnapSHot view controller
        image = screenshot_take
        
        // Small Image view
        img_small.image = screenshot_take
        img_small.isHidden = false
        btn_show.isEnabled = true
    }
    
    
    // Button of show new controller view
    
    @IBOutlet weak var btn_show: UIButton!
    
    // Small image view in main screen
    @IBOutlet weak var img_small: UIImageView!
    
    // Define the Node Position
    var OurNodePosition = SCNVector3(0,0,0)
    //var EndingPostionNode = SCNNode()
    
   
    
  
 
    // Labels which show  Our Distace from AR Object
    @IBOutlet weak var lbl_z: UILabel!
    @IBOutlet weak var lbl_y: UILabel!
    @IBOutlet weak var lbl_x: UILabel!
    
    //Define the ARScene
    @IBOutlet weak var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Our Code
        // Define the scence and put it in scenceView
        let scence = SCNScene()
        sceneView.scene = scence
        // Our sceneView need to be configured with viewWillAppear func
        sceneView.delegate = self
        
        // Config AR Session
        let configuration = ARWorldTrackingConfiguration()
        
        sceneView.session.run(configuration)
        
        // Active the feature point
        sceneView.showsStatistics = true
        
        //Load the AR object
        addObject()
        
        img_small.isHidden = true
        btn_show.isEnabled = false
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Define our configuration var
        img_small.isHidden = true
        btn_show.isEnabled = false
        
        
        
    }
    
    
    // Function of loading AR Object
    func addObject() {
        let loadObj = Object()
        
        
        loadObj.loadModel()
        
        // Define the scale of Object 0.007 m
        loadObj.scale = SCNVector3(0.007,0.007,0.007)
        
        // Define the position of AR Object
        loadObj.position = SCNVector3(0, 0, -1)
        
        // Put the object as a child of sceneView
        sceneView.scene.rootNode.addChildNode(loadObj)
        
        // Try give action to the object and rotate it aroun y-axis
        let RotateAction = SCNAction.rotate(by: 360.DegreesToRadians(),
                                      around:SCNVector3(0, 1, 0)
                                     , duration: 8)
        
        // Give forever action to the Node
        let repeatAction = SCNAction.repeatForever(RotateAction)
        loadObj.runAction(repeatAction)
        
        // Get the position of Our node and put it in public Function
        OurNodePosition = loadObj.position
    }
    
    
    // Define the random position for the node
    
    func RandomPosition(lowerBound lower: Float, upperBound upper: Float) -> Float {
        return Float(arc4random()) / Float(UInt32.max) * (lower - upper) + upper
    }
    
    
    
    
 
    
    // Define The guesture
    // When user touch the screen this Function try to find the new position
    // Puts the Node in the proper position
    @IBAction func onTape(_ sender: UITapGestureRecognizer) {
        
        
        // Find the loction of touching in SceneView
        let location = sender.location(in: sceneView)
         
        // We call the scene view's hitTest() by passing in the touchPosition, and the type of hitTest* we want conducted: using feature points.
         var hitTestResult = sceneView.hitTest(location, types: .featurePoint)
         
         
        var xx:Float = 0.0, yy:Float = 0.0, zz:Float = 0.0
         
         if !hitTestResult.isEmpty
        {
            // Removed the node
            sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
                node.removeFromParentNode()
            }
            
            if hitTestResult.first?.worldTransform.columns.3 != nil
            {
                // Place the new node in new position
                replaceObj(xPosition: hitTestResult.first?.worldTransform.columns.3.x ?? Float(xx), yPosition: hitTestResult.first?.worldTransform.columns.3.y ?? Float(yy), zPosition: hitTestResult.first?.worldTransform.columns.3.z ?? Float(zz))
                xx = hitTestResult.first?.worldTransform.columns.3.x as! Float
                yy = hitTestResult.first?.worldTransform.columns.3.y as! Float
                zz = hitTestResult.first?.worldTransform.columns.3.z as! Float
            }
            
        }
        
        else
         {
            return
           
        }
    }
    
    
    // This function work as load Node
    func replaceObj(xPosition x:Float, yPosition y:Float, zPosition z: Float) -> Void {
        
        
        let loadObj = Object()
        
        loadObj.loadModel()
        
        loadObj.scale = SCNVector3(0.007,0.007,0.007)
        loadObj.position = SCNVector3(x, y,-1)
        sceneView.scene.rootNode.addChildNode(loadObj)
        
        let RotateAction = SCNAction.rotate(by: 360.DegreesToRadians(),
                                      around:SCNVector3(0, 1, 0)
                                     , duration: 8)
        
        let repeatAction = SCNAction.repeatForever(RotateAction)
        loadObj.runAction(repeatAction)
        OurNodePosition = loadObj.position
      
        
    }
    
    
    // This function render the scene view in 60 frame per second
    // With this function we try to find the position of our camera
    // in comprision the origion position of scene view
    
   func renderer(_ renderer: SCNSceneRenderer,
    willRenderScene scene: SCNScene,
    atTime time: TimeInterval)
    {
        guard let pointOfView = sceneView.pointOfView else { return }
        let transform = pointOfView.transform
        let location = SCNVector3(transform.m41,
                                  transform.m42,
                                  transform.m43)
       
       
        
        // This part makes us to be ensure that loading the labels would be
        // in runtime
         DispatchQueue.main.async {
            self.lbl_x.text = "x: " + String (location.x - self.OurNodePosition.x)
            self.lbl_y.text = "y: " + String (location.y - self.OurNodePosition.y)
            self.lbl_z.text = "z: " + String (location.z - self.OurNodePosition.z)
            }
        
        
        
    }
    

    
    


}

extension Int
{
    // Cnage degree to radians
    func DegreesToRadians()-> CGFloat
    {
        return CGFloat(self) * CGFloat.pi / 180.0
    }
}

extension UIView
{
    // Take screen shot from the sceneview
    func take_screen() -> UIImage {
        
        
        //Begin
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        
        //Draw View in that context
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        //Get Image
        
        var image_screen = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if image_screen != nil
        {
            return image_screen!
        }
        
        return UIImage()
        
    }
}

