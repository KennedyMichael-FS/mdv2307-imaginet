package com.mskennedy.imaginet;

import android.nfc.cardemulation.HostApduService;
import android.os.Bundle;

public class ConnectionHostApduService extends HostApduService {
    private static final String TAG = "MyHostApduService";
    public static String myUID = ""; // The custom UID to be emulated

    @Override
    public byte[] processCommandApdu(byte[] commandApdu, Bundle extras) {
        // Check if the received APDU command matches the SELECT AID command (0x00A40400).
        if (commandApdu.length >= 4 &&
                commandApdu[0] == (byte) 0x00 &&
                commandApdu[1] == (byte) 0xA4 &&
                commandApdu[2] == (byte) 0x04 &&
                commandApdu[3] == (byte) 0x00) {
            // Respond with the custom UID in the response APDU.
            return hexStringToByteArray(myUID);
        } else {
            // For any other APDU command, respond with an empty payload (status word 0x9000).
            return new byte[]{(byte) 0x90, (byte) 0x00};
        }
    }

    @Override
    public void onDeactivated(int reason) {
        // This method will be called when the NFC link is deactivated (e.g., the user moves the phone away from the reader).
        // You can perform any cleanup operations here.
    }

    // Helper method to convert a hex string to a byte array.
    private byte[] hexStringToByteArray(String hexString) {
        int len = hexString.length();
        byte[] data = new byte[len / 2];
        for (int i = 0; i < len; i += 2) {
            data[i / 2] = (byte) ((Character.digit(hexString.charAt(i), 16) << 4)
                    + Character.digit(hexString.charAt(i + 1), 16));
        }
        return data;
    }

    // Method to set the custom UID to be emulated.
    public void setEmulatedUID(String uid) {
        myUID = uid;
    }
}