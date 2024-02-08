package com.iksem;

import static com.iksem.R.id.container_main;
import static com.iksem.R.id.navigation_map;

import android.annotation.SuppressLint;
import android.os.Bundle;
import android.view.View;

import androidx.appcompat.app.AppCompatActivity;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.viewpager2.widget.ViewPager2;

import com.google.android.material.bottomnavigation.BottomNavigationView;
import com.iksem.ui.GetSystemBarsHeight;
import com.iksem.ui.ViewPagerAdapter;

public class MainActivity extends AppCompatActivity {

    ConstraintLayout constraintLayout;
    ViewPager2 viewPager2;
    ViewPagerAdapter viewPagerAdapter;
    BottomNavigationView bottomNavigationView;
    private View decorView;

    @SuppressLint({"NonConstantResourceId", "MissingInflatedId"})
    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_main);

        decorView = getWindow().getDecorView();
        decorView.setSystemUiVisibility(hideNavigationBar());

        constraintLayout = findViewById(container_main);
        constraintLayout.setPadding(0, GetSystemBarsHeight.getStatusBarHeight(MainActivity.this) , 0, 0);

        bottomNavigationView = findViewById(R.id.bottom_navigation_view);
        ConstraintLayout.LayoutParams params = (ConstraintLayout.LayoutParams) bottomNavigationView.getLayoutParams();
        params.setMargins(0, 0, 0, -GetSystemBarsHeight.getNavigationBarHeight(MainActivity.this));
        bottomNavigationView.getMenu().findItem(R.id.navigation_home).setChecked(true);

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
                        break;
                    case 1:
                        bottomNavigationView.getMenu().findItem(navigation_map).setChecked(true);
                        break;
                    case 2:
                        bottomNavigationView.getMenu().findItem(R.id.navigation_home).setChecked(true);
                        break;
                    case 3:
                        bottomNavigationView.getMenu().findItem(R.id.navigation_bluetooth).setChecked(true);
                        break;
                    case 4:
                        bottomNavigationView.getMenu().findItem(R.id.navigation_settings).setChecked(true);
                        break;
                }
                super.onPageSelected(position);
            }
        });
    }

    @Override
    public void onWindowFocusChanged(boolean hasFocus) {

        super.onWindowFocusChanged(hasFocus);
        if (hasFocus)
            decorView.setSystemUiVisibility(hideNavigationBar());
    }

    private int hideNavigationBar() {

        return View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                | View.SYSTEM_UI_FLAG_HIDE_NAVIGATION | View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY
                | View.SYSTEM_UI_FLAG_LAYOUT_STABLE;
    }
}