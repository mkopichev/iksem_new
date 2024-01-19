package com.iksem.ui;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentActivity;
import androidx.viewpager2.adapter.FragmentStateAdapter;

import com.iksem.ui.bluetooth.BluetoothFragment;
import com.iksem.ui.home.HomeFragment;
import com.iksem.ui.map.MapFragment;
import com.iksem.ui.protocols.ProtocolsFragment;
import com.iksem.ui.settings.SettingsFragment;

public class ViewPagerAdapter extends FragmentStateAdapter {

    public ViewPagerAdapter(@NonNull FragmentActivity fragmentActivity) {
        super(fragmentActivity);
    }

    @NonNull
    @Override
    public Fragment createFragment(int position) {
        switch (position) {
            case 0:
                return new ProtocolsFragment();
            case 1:
                return new MapFragment();
            case 3:
                return new BluetoothFragment();
            case 4:
                return new SettingsFragment();
            default:
                return new HomeFragment();
        }
    }

    @Override
    public int getItemCount() {
        return 5;
    }
}
