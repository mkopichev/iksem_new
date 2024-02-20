package com.iksem.ui;

import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

import androidx.annotation.NonNull;

import com.iksem.R;

public class DialogBoxProtocolsSearch extends Dialog implements View.OnClickListener {

    DialogBoxListener dialogBoxListener;
    Button filterApply, filterClear;

    public DialogBoxProtocolsSearch(@NonNull Context context, DialogBoxListener dialogBoxListener) {

        super(context);
        this.dialogBoxListener = dialogBoxListener;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.dialog_search_protocols);
        filterApply = findViewById(R.id.dialog_search_protocols_apply);
        filterApply.setOnClickListener(this);
        filterClear = findViewById(R.id.dialog_search_protocols_clear);
        filterClear.setOnClickListener(this);
    }

    @Override
    public void onClick(View view) {


    }
}
