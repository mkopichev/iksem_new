package com.iksem;

import android.annotation.SuppressLint;
import android.os.Bundle;
import android.view.View;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import com.google.android.material.appbar.MaterialToolbar;
import com.iksem.ui.calibration.CalibrationFragment;

public class CalibrationActivity extends AppCompatActivity {

    MaterialToolbar materialToolbar;
    private View decorView;

    @SuppressLint({"MissingInflatedId", "CommitTransaction"})
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        decorView = getWindow().getDecorView();
        decorView.setSystemUiVisibility(hideNavigationBar());
        setContentView(R.layout.activity_calibration);
        materialToolbar = findViewById(R.id.calibration_toolbar);
        getSupportFragmentManager()
                .beginTransaction()
                .setReorderingAllowed(true)
                .add(R.id.calibration_fragment_container, CalibrationFragment.class, null)
                .commit();
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
