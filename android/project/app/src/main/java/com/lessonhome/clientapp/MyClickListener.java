package com.lessonhome.clientapp;

import android.content.Context;
import android.view.View;

/**
 * Created by vlad on 02.02.2015.
 */
public class MyClickListener implements View.OnClickListener {



    Context context;

    public MyClickListener(Context context)
    {
        this.context = context;
    }

    @Override
    public void onClick (View v)
    {

        switch (v.getId()) {

        }
    }

}
