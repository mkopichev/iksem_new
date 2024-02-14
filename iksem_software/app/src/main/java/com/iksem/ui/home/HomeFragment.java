package com.iksem.ui.home;

import android.annotation.SuppressLint;
import android.content.res.Resources;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.compose.foundation.layout.LayoutWeightElement;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.ViewModelProvider;

import com.google.android.material.button.MaterialButton;
import com.iksem.R;
import com.iksem.databinding.FragmentHomeBinding;

public class HomeFragment extends Fragment {

    private FragmentHomeBinding binding;

    @SuppressLint("UseCompatLoadingForDrawables")
    public View onCreateView(@NonNull LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {

        HomeViewModel homeViewModel =
                new ViewModelProvider(this).get(HomeViewModel.class);

        binding = FragmentHomeBinding.inflate(inflater, container, false);
        View root = binding.getRoot();

        final TextView textView = binding.textHome;
        homeViewModel.getText().observe(getViewLifecycleOwner(), textView::setText);

        final MaterialButton homeOneWayProtocol = binding.homeOneWayProtocol, homeBothWaysProtocol = binding.homeBothWaysProtocol;

        homeOneWayProtocol.addOnCheckedChangeListener((button, isChecked) -> {
            if (isChecked) {
                homeOneWayProtocol.setTextColor(getResources().getColor(R.color.background_over, requireActivity().getTheme()));
                homeOneWayProtocol.setIcon(getResources().getDrawable(R.drawable.ic_button_apply_no_frame, requireActivity().getTheme()));
                homeOneWayProtocol.setLayoutParams(new Layou);
                Toast.makeText(requireActivity(), R.string.home_trip_type_one_way_toast, Toast.LENGTH_SHORT).show();
            } else {
                homeOneWayProtocol.setTextColor(getResources().getColor(R.color.background_text, requireActivity().getTheme()));
            }
        });

        homeBothWaysProtocol.addOnCheckedChangeListener((button, isChecked) -> {
            if (isChecked) {
                homeBothWaysProtocol.setTextColor(getResources().getColor(R.color.background_over, requireActivity().getTheme()));
                homeBothWaysProtocol.setIcon(getResources().getDrawable(R.drawable.ic_button_apply_no_frame, requireActivity().getTheme()));
                Toast.makeText(requireActivity(), R.string.home_trip_type_both_ways_toast, Toast.LENGTH_SHORT).show();
            } else {
                homeBothWaysProtocol.setTextColor(getResources().getColor(R.color.background_text, requireActivity().getTheme()));
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