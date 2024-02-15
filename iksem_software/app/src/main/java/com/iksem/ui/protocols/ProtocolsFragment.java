package com.iksem.ui.protocols;

import android.annotation.SuppressLint;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.PopupMenu;
import android.widget.TextView;
import android.widget.Toast;

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

        final MaterialButton protocolsViewMode = binding.protocolsViewModeButton;
        final MaterialButton protocolsSearchButton = binding.protocolsSearchButton;

        protocolsViewMode.setOnClickListener(v -> {
            PopupMenu popupMenu = new PopupMenu(requireActivity(), v);
            popupMenu.getMenuInflater().inflate(R.menu.protocols_view_menu, popupMenu.getMenu());
            popupMenu.show();
        });

//        final MaterialButton protocolsViewPlot = binding.protocolsViewPlot, protocolsViewMap = binding.protocolsViewMap;
//        final MaterialButton protocolsSplitView = binding.protocolsSplitView, protocolsMergeView = binding.protocolsMergeView;
//
//        protocolsViewPlot.addOnCheckedChangeListener((button, isChecked) -> {
//            if (isChecked) {
//                protocolsViewPlot.setIconTintResource(R.color.background_over);
//                Toast.makeText(requireActivity(), R.string.protocols_plot_view_toast, Toast.LENGTH_SHORT).show();
//            } else {
//                protocolsViewPlot.setIconTintResource(R.color.background_text);
//            }
//        });
//
//        protocolsViewMap.addOnCheckedChangeListener((button, isChecked) -> {
//            if (isChecked) {
//                protocolsViewMap.setIconTintResource(R.color.background_over);
//                Toast.makeText(requireActivity(), R.string.protocols_map_view_toast, Toast.LENGTH_SHORT).show();
//            } else {
//                protocolsViewMap.setIconTintResource(R.color.background_text);
//            }
//        });
//
//        protocolsSplitView.addOnCheckedChangeListener((button, isChecked) -> {
//            if (isChecked) {
//                protocolsSplitView.setIconTintResource(R.color.background_over);
//                Toast.makeText(requireActivity(), R.string.protocols_split_both_ways_protocol_toast, Toast.LENGTH_SHORT).show();
//            } else {
//                protocolsSplitView.setIconTintResource(R.color.background_text);
//            }
//        });
//
//        protocolsMergeView.addOnCheckedChangeListener((button, isChecked) -> {
//            if (isChecked) {
//                protocolsMergeView.setIconTintResource(R.color.background_over);
//                Toast.makeText(requireActivity(), R.string.protocols_merge_both_ways_protocol_toast, Toast.LENGTH_SHORT).show();
//            } else {
//                protocolsMergeView.setIconTintResource(R.color.background_text);
//            }
//        });

        return root;
    }

    @Override
    public void onDestroyView() {

        super.onDestroyView();
        binding = null;
    }
}