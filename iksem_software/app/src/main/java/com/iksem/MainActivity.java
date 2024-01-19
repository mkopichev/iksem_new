package com.iksem;

import static com.iksem.R.id.navigation_map;

import android.annotation.SuppressLint;
import android.os.Bundle;

import androidx.appcompat.app.AppCompatActivity;
import androidx.viewpager2.widget.ViewPager2;

import com.google.android.material.bottomnavigation.BottomNavigationView;
import com.iksem.ui.ViewPagerAdapter;

import java.util.Objects;

public class MainActivity extends AppCompatActivity {
    BottomNavigationView bottomNavigationView;
    ViewPager2 viewPager2;
    ViewPagerAdapter viewPagerAdapter;

    @SuppressLint("NonConstantResourceId")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        bottomNavigationView = findViewById(R.id.bottomNavigationView);
        bottomNavigationView.getMenu().findItem(R.id.navigation_home).setChecked(true);
        Objects.requireNonNull(getSupportActionBar()).setTitle(R.string.title_home);
        viewPager2 = findViewById(R.id.viewPager);
        viewPagerAdapter = new ViewPagerAdapter(this);
        viewPager2.setAdapter(viewPagerAdapter);
        viewPager2.setCurrentItem(2);
        bottomNavigationView.setOnItemSelectedListener(item -> {
            int id = item.getItemId();
            if (id == R.id.navigation_protocols) {
                viewPager2.setCurrentItem(0);
            } else if (id == navigation_map) {
                viewPager2.setCurrentItem(1);
            } else if (id == R.id.navigation_home) {
                viewPager2.setCurrentItem(2);
            } else if (id == R.id.navigation_bluetooth) {
                viewPager2.setCurrentItem(3);
            } else if (id == R.id.navigation_settings) {
                viewPager2.setCurrentItem(4);
            }
            return false;
        });

        viewPager2.registerOnPageChangeCallback(new ViewPager2.OnPageChangeCallback() {
            @Override
            public void onPageSelected(int position) {
                switch (position) {
                    case 0:
                        bottomNavigationView.getMenu().findItem(R.id.navigation_protocols).setChecked(true);
                        Objects.requireNonNull(getSupportActionBar()).setTitle(R.string.title_protocols);
                        break;
                    case 1:
                        bottomNavigationView.getMenu().findItem(navigation_map).setChecked(true);
                        Objects.requireNonNull(getSupportActionBar()).setTitle(R.string.title_map);
                        break;
                    case 2:
                        bottomNavigationView.getMenu().findItem(R.id.navigation_home).setChecked(true);
                        Objects.requireNonNull(getSupportActionBar()).setTitle(R.string.title_home);
                        break;
                    case 3:
                        bottomNavigationView.getMenu().findItem(R.id.navigation_bluetooth).setChecked(true);
                        Objects.requireNonNull(getSupportActionBar()).setTitle(R.string.title_bluetooth);
                        break;
                    case 4:
                        bottomNavigationView.getMenu().findItem(R.id.navigation_settings).setChecked(true);
                        Objects.requireNonNull(getSupportActionBar()).setTitle(R.string.title_settings);
                        break;
                }
                super.onPageSelected(position);
            }
        });
    }
}