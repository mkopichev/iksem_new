package com.iksem.ui.calibration;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.ViewModelProvider;

import com.iksem.databinding.FragmentCalibrationBinding;

public class CalibrationFragment extends Fragment {

    private FragmentCalibrationBinding binding;

    public View onCreateView(@NonNull LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {

        CalibrationViewModel calibrationViewModel =
                new ViewModelProvider(this).get(CalibrationViewModel.class);

        binding = FragmentCalibrationBinding.inflate(inflater, container, false);
        View root = binding.getRoot();

        final TextView textView = binding.textCalibration;
        calibrationViewModel.getText().observe(getViewLifecycleOwner(), textView::setText);

        return root;
    }

    @Override
    public void onDestroyView() {

        super.onDestroyView();
        binding = null;
    }
}
