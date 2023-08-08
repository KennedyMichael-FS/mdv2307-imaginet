import Foundation
import CoreNFC
import UIKit

class NFCViewController: UIViewController, NFCTagReaderSessionDelegate {

    var nfcSession: NFCTagReaderSession?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Check for NFC support on the device
        if NFCTagReaderSession.readingAvailable {
            // NFC is available, enable reading
            nfcSession = NFCTagReaderSession(pollingOption: .iso14443, delegate: self)
            nfcSession?.alertMessage = "Hold your iPhone near the NFC tag to read."
        } else {
            // NFC is not available on this device
            print("NFC is not supported on this device.")
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Start the NFC reading session when the view appears
        nfcSession?.begin()
    }

    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        // NFC session became active
    }

    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        // NFC session invalidated due to error
        print("NFC reading session invalidated with error: \(error.localizedDescription)")
    }

    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
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

            // Check if the tag is of type NFCNDEFTag
            if case let NFCTag.miFare(tag) = tag {
                // Read data from the NFC tag
                tag.readNDEF { ndefMessage, error in
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

                    // End the NFC session
                    session.invalidate()
                }
            } else {
                // The detected tag is not of type NFCNDEFTag
                print("Unsupported NFC tag type.")
                session.invalidate(errorMessage: "Unsupported NFC tag type.")
            }
        }
    }
}
