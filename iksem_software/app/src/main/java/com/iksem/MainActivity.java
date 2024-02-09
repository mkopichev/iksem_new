package com.iksem;

import static com.iksem.R.id.navigation_map;

import android.annotation.SuppressLint;
import android.os.Bundle;
import android.view.View;

import androidx.appcompat.app.AppCompatActivity;
import androidx.viewpager2.widget.ViewPager2;

import com.google.android.material.bottomnavigation.BottomNavigationView;
import com.iksem.ui.ViewPagerAdapter;

import net.yslibrary.android.keyboardvisibilityevent.KeyboardVisibilityEvent;

public class MainActivity extends AppCompatActivity {

    ViewPager2 viewPager2;
    ViewPagerAdapter viewPagerAdapter;
    BottomNavigationView bottomNavigationView;

    @SuppressLint({"NonConstantResourceId", "MissingInflatedId"})
    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);

        this.getWindow().setStatusBarColor(getColor(R.color.background));
        this.getWindow().setNavigationBarColor(getColor(R.color.background_over));

        setContentView(R.layout.activity_main);

        bottomNavigationView = findViewById(R.id.bottom_navigation_view);
        bottomNavigationView.getMenu().findItem(R.id.navigation_home).setChecked(true);

        viewPagerAdapter = new ViewPagerAdapter(this);

        viewPager2 = findViewById(R.id.viewPager);
        viewPager2.setAdapter(viewPagerAdapter);
        viewPager2.setCurrentItem(ViewPagerAdapter.HOME_FRAGMENT);

        bottomNavigationView.setOnItemSelectedListener(item -> {
            int id = item.getItemId();
            if (id == R.id.navigation_protocols) {
                viewPager2.setCurrentItem(ViewPagerAdapter.PROTOCOLS_FRAGMENT);
            } else if (id == navigation_map) {
                viewPager2.setCurrentItem(ViewPagerAdapter.MAP_FRAGMENT);
            } else if (id == R.id.navigation_home) {
                viewPager2.setCurrentItem(ViewPagerAdapter.HOME_FRAGMENT);
            } else if (id == R.id.navigation_bluetooth) {
                viewPager2.setCurrentItem(ViewPagerAdapter.BLUETOOTH_FRAGMENT);
            } else if (id == R.id.navigation_settings) {
                viewPager2.setCurrentItem(ViewPagerAdapter.SETTINGS_FRAGMENT);
            }
            return false;
        });

        viewPager2.registerOnPageChangeCallback(new ViewPager2.OnPageChangeCallback() {
            @Override
            public void onPageSelected(int position) {

                switch (position) {
                    case ViewPagerAdapter.PROTOCOLS_FRAGMENT:
                        bottomNavigationView.getMenu().findItem(R.id.navigation_protocols).setChecked(true);
                        break;
                    case ViewPagerAdapter.MAP_FRAGMENT:
                        bottomNavigationView.getMenu().findItem(navigation_map).setChecked(true);
                        break;
                    case ViewPagerAdapter.HOME_FRAGMENT:
                        bottomNavigationView.getMenu().findItem(R.id.navigation_home).setChecked(true);
                        break;
                    case ViewPagerAdapter.BLUETOOTH_FRAGMENT:
                        bottomNavigationView.getMenu().findItem(R.id.navigation_bluetooth).setChecked(true);
                        break;
                    case ViewPagerAdapter.SETTINGS_FRAGMENT:
                        bottomNavigationView.getMenu().findItem(R.id.navigation_settings).setChecked(true);
                        break;
                }
                super.onPageSelected(position);
            }
        });

        KeyboardVisibilityEvent.setEventListener(this, isOpen -> {

            if (isOpen)
                bottomNavigationView.setVisibility(View.GONE);
            else
                bottomNavigationView.setVisibility(View.VISIBLE);
        });
    }
}