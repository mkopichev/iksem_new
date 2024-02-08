package com.iksem;

import android.annotation.SuppressLint;
import android.os.Bundle;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import com.google.android.material.appbar.MaterialToolbar;
import com.iksem.ui.calibration.CalibrationFragment;

import java.util.Objects;

public class CalibrationActivity extends AppCompatActivity {

    MaterialToolbar materialToolbar;

    @SuppressLint({"MissingInflatedId", "CommitTransaction"})
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_calibration);

        this.getWindow().setStatusBarColor(getColor(R.color.background_over));
        this.getWindow().setNavigationBarColor(getColor(R.color.background));

        materialToolbar = findViewById(R.id.calibration_toolbar);
        setSupportActionBar(materialToolbar);

        Objects.requireNonNull(getSupportActionBar()).setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setDisplayShowHomeEnabled(true);

        getSupportFragmentManager()
                .beginTransaction()
                .setReorderingAllowed(true)
                .add(R.id.calibration_fragment_container, CalibrationFragment.class, null)
                .commit();
    }
}
