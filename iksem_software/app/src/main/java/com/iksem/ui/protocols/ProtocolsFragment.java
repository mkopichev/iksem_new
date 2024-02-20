package com.iksem.ui.protocols;

import android.annotation.SuppressLint;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Build;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.PopupMenu;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.ViewModelProvider;

import com.google.android.material.button.MaterialButton;
import com.iksem.R;
import com.iksem.databinding.FragmentProtocolsBinding;
import com.iksem.ui.DialogBoxListener;
import com.iksem.ui.DialogBoxProtocolsSearch;

import java.util.Objects;

public class ProtocolsFragment extends Fragment {

    private FragmentProtocolsBinding binding;

    @SuppressLint({"ResourceAsColor", "NonConstantResourceId"})
    public View onCreateView(@NonNull LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {

        ProtocolsViewModel protocolsViewModel = new ViewModelProvider(this).get(ProtocolsViewModel.class);

        binding = FragmentProtocolsBinding.inflate(inflater, container, false);
        View root = binding.getRoot();

        final TextView textView = binding.textProtocols;
        protocolsViewModel.getText().observe(getViewLifecycleOwner(), textView::setText);

        final MaterialButton protocolsViewMode = binding.protocolsViewModeButton;
        final MaterialButton protocolsSearch = binding.protocolsSearchButton;

        final PopupMenu popupMenu = new PopupMenu(requireActivity(), protocolsViewMode);
        popupMenu.getMenuInflater().inflate(R.menu.protocols_view_menu, popupMenu.getMenu());
        popupMenu.getMenu().setGroupDividerEnabled(true);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            popupMenu.setForceShowIcon(true);
        }

        protocolsViewMode.setOnClickListener(v -> {

            popupMenu.setOnMenuItemClickListener(menuItem -> {

                menuItem.setChecked(true);
                return true;
            });
            popupMenu.show();
        });

        DialogBoxListener dialogBoxListener = new DialogBoxListener() {
            @Override
            public void rightButtonPressed(Object object) {

            }

            @Override
            public void leftButtonPressed() {

            }
        };

        protocolsSearch.setOnClickListener(view -> {

            DialogBoxProtocolsSearch dialogBoxProtocolsSearch = new DialogBoxProtocolsSearch(requireActivity(), dialogBoxListener);
            Objects.requireNonNull(dialogBoxProtocolsSearch.getWindow()).setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
            dialogBoxProtocolsSearch.show();

        });

        return root;
    }

    @Override
    public void onDestroyView() {

        super.onDestroyView();
        binding = null;
    }
}