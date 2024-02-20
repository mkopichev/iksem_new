package com.iksem.ui.settings;

import static net.yslibrary.android.keyboardvisibilityevent.KeyboardVisibilityEvent.setEventListener;

import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.ViewModelProvider;

import com.google.android.material.button.MaterialButton;
import com.iksem.CalibrationActivity;
import com.iksem.databinding.FragmentSettingsBinding;

public class SettingsFragment extends Fragment {

    private FragmentSettingsBinding binding;

    public View onCreateView(@NonNull LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {

        SettingsViewModel settingsViewModel =
                new ViewModelProvider(this).get(SettingsViewModel.class);

        binding = FragmentSettingsBinding.inflate(inflater, container, false);
        View root = binding.getRoot();

        final TextView textView = binding.textSettings;
        settingsViewModel.getText().observe(getViewLifecycleOwner(), textView::setText);

        MaterialButton calibration = binding.settingsCalibrationButton;

        LinearLayout settingsButtonsArea = binding.settingsButtonsArea;

        calibration.setOnClickListener(v -> startActivity(new Intent(getActivity(), CalibrationActivity.class)));

        setEventListener(requireActivity(), isOpen -> {

            if (isOpen)
                settingsButtonsArea.setVisibility(View.GONE);
            else
                settingsButtonsArea.setVisibility(View.VISIBLE);
        });

        return root;
    }

    @Override
    public void onDestroyView() {

        super.onDestroyView();
        binding = null;
    }
}