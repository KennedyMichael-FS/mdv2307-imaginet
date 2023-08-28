package com.mskennedy.imaginet;

import android.content.Intent;
import android.os.Bundle;
import androidx.fragment.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;

import com.google.firebase.auth.FirebaseAuth;

public class AddCard extends Fragment {

    public AddCard() {
        // Required empty public constructor
    }

    public static AddCard newInstance() {
        return new AddCard();
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        String uid = FirebaseAuth.getInstance().getUid();

        // Inflate the layout for this fragment
        View rootView = inflater.inflate(R.layout.fragment_add_card, container, false);

        // Find the TextView and Button by their IDs
        TextView textView = rootView.findViewById(R.id.currentUIDdisplay);
        textView.setText(uid);
        ConnectionHostApduService.NDEF_TEXT = uid;
        Button button = rootView.findViewById(R.id.sendNFCbutton);

        // Set an OnClickListener on the button
        button.setOnClickListener(v -> startNfcEmulation());
        return rootView;
    }

    private void startNfcEmulation() {
        // Start the NFC emulation service
        Intent serviceIntent = new Intent(requireContext(), ConnectionHostApduService.class);
        requireContext().startService(serviceIntent);
    }
}