package com.iksem.ui.protocols;

import android.annotation.SuppressLint;
import android.content.res.ColorStateList;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.ViewModelProvider;

import com.google.android.material.button.MaterialButton;
import com.iksem.R;
import com.iksem.databinding.FragmentProtocolsBinding;

public class ProtocolsFragment extends Fragment {

    private FragmentProtocolsBinding binding;

    @SuppressLint("ResourceAsColor")
    public View onCreateView(@NonNull LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {

        ProtocolsViewModel protocolsViewModel = new ViewModelProvider(this).get(ProtocolsViewModel.class);

        binding = FragmentProtocolsBinding.inflate(inflater, container, false);
        View root = binding.getRoot();

        final TextView textView = binding.textProtocols;
        protocolsViewModel.getText().observe(getViewLifecycleOwner(), textView::setText);

        final MaterialButton protocolsViewPlot = binding.protocolsViewPlot, protocolsViewMap = binding.protocolsViewMap;
        final MaterialButton protocolsSplitView = binding.protocolsSplitView, protocolsMergeView = binding.protocolsMergeView;

        protocolsViewPlot.addOnCheckedChangeListener((button, isChecked) -> {
            if (isChecked) {
                protocolsViewPlot.setIconTintResource(R.color.background_over);
            } else {
                protocolsViewPlot.setIconTintResource(R.color.background_text);
            }
        });

        protocolsViewMap.addOnCheckedChangeListener((button, isChecked) -> {
            if (isChecked) {
                protocolsViewMap.setIconTintResource(R.color.background_over);
            } else {
                protocolsViewMap.setIconTintResource(R.color.background_text);
            }
        });

        protocolsSplitView.addOnCheckedChangeListener((button, isChecked) -> {
            if (isChecked) {
                protocolsSplitView.setIconTintResource(R.color.background_over);
            } else {
                protocolsSplitView.setIconTintResource(R.color.background_text);
            }
        });

        protocolsMergeView.addOnCheckedChangeListener((button, isChecked) -> {
            if (isChecked) {
                protocolsMergeView.setIconTintResource(R.color.background_over);
            } else {
                protocolsMergeView.setIconTintResource(R.color.background_text);
            }
        });

        return root;
    }

    @Override
    public void onDestroyView() {

        super.onDestroyView();
        binding = null;
    }
}