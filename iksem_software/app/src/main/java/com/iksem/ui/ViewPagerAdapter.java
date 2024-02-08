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

    public static final int PROTOCOLS_FRAGMENT = 0, MAP_FRAGMENT = 1, HOME_FRAGMENT = 2,
            BLUETOOTH_FRAGMENT = 3, SETTINGS_FRAGMENT = 4;

    public ViewPagerAdapter(@NonNull FragmentActivity fragmentActivity) {
        super(fragmentActivity);
    }

    @NonNull
    @Override
    public Fragment createFragment(int position) {

        switch (position) {
            case PROTOCOLS_FRAGMENT:
                return new ProtocolsFragment();
            case MAP_FRAGMENT:
                return new MapFragment();
            case BLUETOOTH_FRAGMENT:
                return new BluetoothFragment();
            case SETTINGS_FRAGMENT:
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
