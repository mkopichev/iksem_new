package com.iksem.ui.protocols;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.ViewModelProvider;

import com.iksem.databinding.FragmentProtocolsBinding;

public class ProtocolsFragment extends Fragment {

    private FragmentProtocolsBinding binding;

    public View onCreateView(@NonNull LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {
        ProtocolsViewModel protocolsViewModel =
                new ViewModelProvider(this).get(ProtocolsViewModel.class);

        binding = FragmentProtocolsBinding.inflate(inflater, container, false);
        View root = binding.getRoot();

        final TextView textView = binding.textProtocols;
        protocolsViewModel.getText().observe(getViewLifecycleOwner(), textView::setText);
        return root;
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        binding = null;
    }
}