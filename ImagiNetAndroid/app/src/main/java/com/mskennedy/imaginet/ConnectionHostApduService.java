package com.mskennedy.imaginet;

import android.nfc.NdefMessage;
import android.nfc.NdefRecord;
import android.nfc.cardemulation.HostApduService;
import android.os.Bundle;
import android.util.Log;

import java.util.Arrays;

public class ConnectionHostApduService extends HostApduService {

    private static final String TAG = "NFC_Emulation_Service";
    private static final byte[] RESPONSE_SUCCESS = {(byte) 0x90, (byte) 0x00};
    private static final byte[] RESPONSE_ERROR = {(byte) 0x6A, (byte) 0x00};

    public static String NDEF_TEXT = "";

    private static final byte[] SELECT_APDU = {
            (byte) 0x00, // CLA (Class)
            (byte) 0xA4, // INS (Instruction)
            (byte) 0x04, // P1 (Parameter 1)
            (byte) 0x00, // P2 (Parameter 2)
            (byte) 0x07, // Length of data
            (byte) 0xF0, (byte) 0x39, (byte) 0x41, (byte) 0x48, (byte) 0x00, (byte) 0x01, (byte) 0x02 // AID (Application Identifier)
    };

    private NdefMessage createNdefMessage() {
        Log.e("Printing value: ", NDEF_TEXT);
        NdefRecord record = NdefRecord.createTextRecord("en", NDEF_TEXT);
        return new NdefMessage(new NdefRecord[]{record});
    }

    @Override
    public byte[] processCommandApdu(byte[] commandApdu, Bundle extras) {
        Log.d(TAG, "Received APDU command: " + byteArrayToHex(commandApdu));

        if (Arrays.equals(commandApdu, SELECT_APDU)) {
            NdefMessage ndefMessage = createNdefMessage();
            byte[] ndefPayload = ndefMessage.toByteArray();
            byte[] response = new byte[ndefPayload.length + 2];
            System.arraycopy(ndefPayload, 0, response, 0, ndefPayload.length);
            System.arraycopy(RESPONSE_SUCCESS, 0, response, ndefPayload.length, 2);
            return response;
        }

        return RESPONSE_ERROR;
    }

    @Override
    public void onDeactivated(int reason) {
        Log.d(TAG, "Deactivated: " + reason);
    }

    private String byteArrayToHex(byte[] byteArray) {
        StringBuilder sb = new StringBuilder();
        for (byte b : byteArray) {
            sb.append(String.format("%02X", b));
        }
        return sb.toString();
    }
}