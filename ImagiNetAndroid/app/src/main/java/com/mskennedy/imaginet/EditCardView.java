package com.mskennedy.imaginet;

import android.os.Bundle;

import androidx.fragment.app.Fragment;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.firestore.CollectionReference;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.SetOptions;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class EditCardView extends Fragment {

    public EditCardView() {
        // Required empty public constructor
    }

    public static EditCardView newInstance() {
        EditCardView fragment = new EditCardView();
        Bundle args = new Bundle();
        return fragment;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (getArguments() != null) {
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_edit_card_view, container, false);

        EditText firstName = rootView.findViewById(R.id.firstNameField);
        EditText lastName = rootView.findViewById(R.id.lastNameField);
        EditText jobtitle = rootView.findViewById(R.id.jobtitleField);
        EditText company = rootView.findViewById(R.id.companyField);

        Button saveCard = rootView.findViewById(R.id.saveCardButton);

        saveCard.setOnClickListener(v -> {
            saveRemoteCard(firstName.getText().toString(), lastName.getText().toString(), jobtitle.getText().toString(), company.getText().toString());
        });

        return rootView;
    }

    private void saveRemoteCard(String fn, String ln, String jt, String c) {

        String uid = FirebaseAuth.getInstance().getUid();
        FirebaseFirestore db = FirebaseFirestore.getInstance();
        CollectionReference usersCollection = db.collection("users");

        DocumentReference documentRef = usersCollection.document(uid);

        Map<String, Object> data = new HashMap<>();
        data.put("firstName", fn);
        data.put("lastName", ln);
        data.put("jobTitle", jt);

        loadConnections(connections -> {
            if (connections != null) {
                data.put("connections", connections);

                documentRef.set(data, SetOptions.merge())
                        .addOnSuccessListener(aVoid -> System.out.println("Document updated successfully."))
                        .addOnFailureListener(e -> System.out.println("Error updating document: " + e.getMessage()));
            } else {
                System.out.println("Error: Some required fields were empty.");
            }
        });
    }

    private void loadConnections(OnConnectionsLoadedListener listener) {

        String uid = FirebaseAuth.getInstance().getUid();
        FirebaseFirestore db = FirebaseFirestore.getInstance();
        CollectionReference usersCollection = db.collection("users");

        DocumentReference documentRef = usersCollection.document(uid);

        documentRef.get()
                .addOnSuccessListener(documentSnapshot -> {
                    if (documentSnapshot.exists()) {
                        List<String> connections = (List<String>) documentSnapshot.get("connections");
                        if (connections != null) {
                            listener.onConnectionsLoaded(connections);
                        } else {
                            System.out.println("Connections array not available or is of the wrong type.");
                            listener.onConnectionsLoaded(null);
                        }
                    } else {
                        System.out.println("Document not found.");
                    }
                })
                .addOnFailureListener(e -> {
                    System.out.println("Error fetching document: " + e.getMessage());
                    listener.onConnectionsLoaded(null);
                });
    }

    private interface OnConnectionsLoadedListener {
        void onConnectionsLoaded(List<String> connections);
    }
}