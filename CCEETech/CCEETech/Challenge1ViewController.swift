//
//  Challenge1ViewController.swift
//  CCEETech
//
//  ViewController that handles AR scanner in Challenge 1
//
//  Created by Macbook Pro on 3/14/19.
//

import UIKit
import SceneKit
import ARKit
import Firebase

class Challenge1ViewController: UIViewController {
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var label: UILabel!
    var score = 0
    let currentUser = Auth.auth().currentUser;
    let ref = Database.database().reference().child("users/profile/")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let userProfile = UserService.currentUserProfile else { return }
        score = userProfile.score
        sceneView.delegate = self
        configureLighting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        resetTrackingConfiguration()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    func configureLighting() {
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }
    
    @IBAction func resetButtonDidTouch(_ sender: UIBarButtonItem) {
        resetTrackingConfiguration()
    }
    
    func resetTrackingConfiguration() {
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else { return }
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        let options: ARSession.RunOptions = [.resetTracking, .removeExistingAnchors]
        sceneView.session.run(configuration, options: options)
        label.text = "Move camera around to detect images"
    }
    
}

extension Challenge1ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        let referenceImage = imageAnchor.referenceImage
        let imageName = referenceImage.name ?? "no name"
        
        let width = CGFloat(referenceImage.physicalSize.width*2)
        let height = CGFloat(referenceImage.physicalSize.height*4.5)
        
        let videoHolder = SCNNode()
        let videoHolderGeometry = SCNPlane(width: width, height: height)
        videoHolder.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
        videoHolder.geometry = videoHolderGeometry
        
        if let videoURL = Bundle.main.url(forResource: "ozo_tutorial2", withExtension: "mp4"){
            setupVideoOnNode(videoHolder, fromURL: videoURL)
        }
        
        //5. Add It To The Hierarchy
        node.addChildNode(videoHolder)
        
        DispatchQueue.main.async {
            self.label.text = "Technology detected: \"\(imageName)\""
        }
    }
    
    func setupVideoOnNode(_ node: SCNNode, fromURL url: URL){
        
        var videoPlayerNode: SKVideoNode!
        let videoPlayer = AVPlayer(url: url)
        
        videoPlayerNode = SKVideoNode(avPlayer: videoPlayer)
        videoPlayerNode.yScale = -1
        
        let spriteKitScene = SKScene(size: CGSize(width: 600, height: 300))
        spriteKitScene.scaleMode = .aspectFit
        videoPlayerNode.position = CGPoint(x: spriteKitScene.size.width/2, y: spriteKitScene.size.height/2)
        videoPlayerNode.size = spriteKitScene.size
        spriteKitScene.addChild(videoPlayerNode)
        
        node.geometry?.firstMaterial?.diffuse.contents = spriteKitScene
        
        videoPlayerNode.play()
        videoPlayer.volume = 5
        if score < 500 {
            ref.child("\(currentUser!.uid)/score").setValue(500)
        }
    }
}
