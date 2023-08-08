import Foundation
import UIKit
import CoreBluetooth
import MultipeerConnectivity
import FirebaseFirestore

public class AddCardViewController: UIViewController, MCBrowserViewControllerDelegate, MCSessionDelegate, MCNearbyServiceAdvertiserDelegate {

    // Now implementing multipeer connectivity
    var peerID:MCPeerID! // Device ID
    var session:MCSession! // Connection between devices
    var browser:MCBrowserViewController! // Prebuilt, searches for advertisers
    var advertiser:MCNearbyServiceAdvertiser!// Advertises to browsers nearby
    let serviceID = "ImagiNetAdding" // Channel
    
    let queue = DispatchGroup.init()
    
    private let centralQueue = DispatchQueue(label: "com.mskennedy.ImagiNet.centralQueue")
    private let peripheralQueue = DispatchQueue(label: "com.mskennedy.ImagiNet.peripheralQueue")
    
    var isCentralDataReceived = false
    var isPeripheralDataReceived = false
    private var receivedDataFromCentral: String?
    private var isResponseSent = false
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting up connectivity
        peerID = MCPeerID(displayName: UIDevice.current.name)
        session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.none)
        session.delegate = self
        advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: serviceID)
        advertiser.delegate = self
        advertiser.startAdvertisingPeer()
    }
    
    
    @IBAction func bluetoothSelected(_ sender: Any) {
        browser = MCBrowserViewController(serviceType: serviceID, session: session)
        browser.delegate = self
        self.present(browser, animated: true, completion: nil)
    }
    
    public func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        let alert = UIAlertController(title: "Request to join", message: "\(peerID.displayName) wants to connect to your session.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Accept", style: .default, handler: { [weak self] (action) in
            invitationHandler(true, self?.session)
        }))
        alert.addAction(UIAlertAction(title: "Decline", style: .destructive, handler: { [weak self] (action) in
            invitationHandler(false, self?.session)
        }))

        self.present(alert, animated: true, completion: nil)
    }
    
    public func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        DispatchQueue.main.async {
            if session.connectedPeers.count > 0 {
                // Connected to a peer, send the LoginViewController.myUid string
                if let dataToSend = LoginViewController.myUid.data(using: .utf8) {
                    do {
                        try session.send(dataToSend, toPeers: session.connectedPeers, with: .reliable)
                    } catch {
                        print("Error sending data: \(error)")
                    }
                }
            }
        }
    }
    
    public func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let receivedString = String(data: data, encoding: .utf8) {
            if peerID == session.myPeerID {
                // Data sent from local device (central)
                centralQueue.async {
                    // Handle received data on the central side
                    self.handleReceivedDataOnCentral(receivedString: receivedString)
                }
            } else {
                // Data sent from remote device (peripheral)
                peripheralQueue.async {
                    // Handle received data on the peripheral side
                    self.handleReceivedDataOnPeripheral(receivedString: receivedString, fromPeer: peerID)
                }
            }
        }
    }
    
    private func handleReceivedDataOnCentral(receivedString: String) {
        // Process the received data from the peripheral device (responder)
        print("Received data from peripheral device: \(receivedString)")
        isCentralDataReceived = true
        receivedDataFromCentral = receivedString
        saveRemoteCard(uidToSave: receivedString)
        checkDataReceivedOnBothSides()
    }

    private func handleReceivedDataOnPeripheral(receivedString: String, fromPeer peerID: MCPeerID) {
        // Process the received data from the central device (initiator)
        print("Received data from central device (\(peerID.displayName)): \(receivedString)")
        isPeripheralDataReceived = true
        saveRemoteCard(uidToSave: receivedString)
        checkDataReceivedOnBothSides()

        // Respond to the central device only after receiving data from it
        if isCentralDataReceived && !isResponseSent, let responseData = receivedDataFromCentral?.data(using: .utf8) {
            do {
                try session.send(responseData, toPeers: [peerID], with: .reliable)
                isResponseSent = true
            } catch {
                print("Error sending data: \(error)")
            }
        }
    }

    private func checkDataReceivedOnBothSides() {
        if isCentralDataReceived && isPeripheralDataReceived {
            // Both sides have received data, disconnect the session
            session.disconnect()
        }
    }
    
    // Another instance of this method will live here so we can save the connection to our database entry for the user.
    func saveRemoteCard(uidToSave: String) {
        
        let db = Firestore.firestore()
        let usersCollection = db.collection("users")
        
        let documentRef = usersCollection.document(LoginViewController.myUid)
        
        let data: [String: Any] = ["connections": uidToSave]

        // Update the document with the data
        documentRef.setData(data, merge: true) { error in
            if let error = error {
                print("Error updating document: \(error.localizedDescription)")
            } else {
                print("Document updated successfully.")
            }
        }

    }
    
    
    // Received a byte stream from remote peer.
    public func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        } // Start receiving a resource from remote peer.
    public func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    public func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}
    public func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        browserViewController.dismiss(animated: true, completion: nil)}
    public func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        browserViewController.dismiss(animated: true, completion: nil)}

}
    


