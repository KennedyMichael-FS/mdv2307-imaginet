import Foundation
import CoreNFC
import UIKit

class NFCViewController: UIViewController, NFCNDEFReaderSessionDelegate {
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        // NFC session invalidated due to error
        print("NFC reading session invalidated with error: \(error.localizedDescription)")
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        // Ensure there's at least one message
        guard let firstMessage = messages.first else {
            session.invalidate(errorMessage: "No NDEF messages found.")
            return
        }
        
        // Iterate through the records of the first message
        for record in firstMessage.records {
            let payloadData = record.payload
            if let dataAsString = String(data: payloadData, encoding: .utf8) {
                // Display an alert with the received NFC data
                DispatchQueue.main.async {
                    self.showAlert(with: dataAsString)
                }
            } else {
                print("Received data could not be converted to a UTF-8 string.")
            }
        }
        
        // End the NFC session
        session.invalidate()
    }

    // Helper method to display an alert
    private func showAlert(with data: String) {
        let alertController = UIAlertController(
            title: "NFC Data Received",
            message: "Received NFC Data: \(data)",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    

    var nfcSession: NFCTagReaderSession?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check for NFC availability and device compatibility
        guard NFCNDEFReaderSession.readingAvailable else {
            // Display an alert indicating that NFC reading is not available on this device
            let alertController = UIAlertController(
                title: "NFC Not Supported",
                message: "This device does not support NFC reading.",
                preferredStyle: .alert
            )
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Start the NFC reading session when the view appears
        let session = NFCNDEFReaderSession(delegate: self, queue: DispatchQueue.main, invalidateAfterFirstRead: false)
        session.begin()
    }

    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        // A compatible NFC tag was detected
        guard let tag = tags.first else {
            session.invalidate(errorMessage: "Error detecting NFC tag.")
            return
        }

        // Connect to detected NFC tag
        session.connect(to: tag) { error in
            if let error = error {
                // Error connecting to the tag
                print("Error connecting to NFC tag: \(error.localizedDescription)")
                session.invalidate(errorMessage: "Error connecting to NFC tag.")
                return
            }

            if tag.isKind(of: NFCMiFareTag.self) {
                // Handle MiFare NFC tag
                guard let mifareTag = tag as? NFCMiFareTag else {
                    print("Error casting NFC tag to NFCMiFareTag.")
                    session.invalidate(errorMessage: "Error handling NFC tag.")
                    return
                }

                mifareTag.readNDEF { ndefMessage, error in
                    if let error = error {
                        print("Error reading NFC data: \(error.localizedDescription)")
                    } else if let ndefMessage = ndefMessage {
                        // Process the NFC data here
                        for record in ndefMessage.records {
                            let payloadData = record.payload
                            let dataAsString = String(data: payloadData, encoding: .utf8)
                            print("NFC Data: \(dataAsString ?? "Unknown")")
                        }
                    }

                }
            } else {
                // The detected tag is not supported
                print("Unsupported NFC tag type.")
                session.invalidate(errorMessage: "Unsupported NFC tag type.")
            }
        }
    }
    
    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
        // TODO: Handle becoming active.
    }

}
