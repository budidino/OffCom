//
//  OffCom @ Hackathon
//

import UIKit
import MultipeerConnectivity

class MainTVC: UITableViewController, MCSessionDelegate, MCBrowserViewControllerDelegate {
  
  var peerID: MCPeerID!
  var mcSession: MCSession!
  var mcAdvertiserAssistant: MCAdvertiserAssistant!
  
  var hostButton: UIButton!
  var joinButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "OffCom"
    
    view.backgroundColor = .white
    
    peerID = MCPeerID(displayName: UIDevice.current.name)
    mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
    mcSession.delegate = self
    
    let joinButton = UIBarButtonItem(title: "Join", style: .plain, target: self, action: #selector(joinSession))
    self.navigationItem.rightBarButtonItem  = joinButton
    
    startHosting()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  func startHosting() {
    mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "OffCom", discoveryInfo: nil, session: mcSession)
    mcAdvertiserAssistant.start()
  }
  
  func joinSession() {
    let mcBrowser = MCBrowserViewController(serviceType: "OffCom", session: mcSession)
    mcBrowser.delegate = self
    present(mcBrowser, animated: true)
  }
  
  
  
  func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    
  }
  
  func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    
  }
  
  func session(_ session:MCSession, didFinishReceivingResourceWithName resourceName:String, fromPeer peerID:MCPeerID, at localURL:URL, withError error:Error?){
    
  }
  
  func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
    dismiss(animated: true)
  }
  
  func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
    dismiss(animated: true)
  }
  
  
  func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
    switch state {
    case MCSessionState.connected:
      print("Connected: \(peerID.displayName)")
      dismiss(animated: true)
      
    case MCSessionState.connecting:
      print("Connecting: \(peerID.displayName)")
      
    case MCSessionState.notConnected:
      print("Failed to connect to: \(peerID.displayName)")
    }
  }
  
  
  func sendImage(img: UIImage) {
    if mcSession.connectedPeers.count > 0 {
      if let imageData = UIImagePNGRepresentation(img) {
        do {
          try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
        } catch let error as NSError {
          let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
          ac.addAction(UIAlertAction(title: "OK", style: .default))
          present(ac, animated: true)
        }
      }
    }
  }
  
  
  func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
    if let image = UIImage(data: data) {
      DispatchQueue.main.async { [unowned self] in
        // do something with the image
      }
    }
  }

}

