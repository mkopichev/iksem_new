package com.iksem.ui.calibration;

import static net.yslibrary.android.keyboardvisibilityevent.KeyboardVisibilityEvent.setEventListener;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;

import com.iksem.databinding.FragmentCalibrationBinding;

public class CalibrationFragment extends Fragment {

    private FragmentCalibrationBinding binding;

    public View onCreateView(@NonNull LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {

        binding = FragmentCalibrationBinding.inflate(inflater, container, false);
        View root = binding.getRoot();

        LinearLayout calibrationButtonsArea = binding.calibrationButtonsArea;

        setEventListener(requireActivity(), isOpen -> {

            if (isOpen)
                calibrationButtonsArea.setVisibility(View.GONE);
            else
                calibrationButtonsArea.setVisibility(View.VISIBLE);
        });

        return root;
    }

    @Override
    public void onDestroyView() {

        super.onDestroyView();
        binding = null;
    }
}
