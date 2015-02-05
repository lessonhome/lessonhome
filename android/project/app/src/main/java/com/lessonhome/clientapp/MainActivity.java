package com.lessonhome.clientapp;

import android.content.res.Configuration;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarActivity;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.widget.Toolbar;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.LinearLayout;

/**
 *Activity where
**/
public class MainActivity extends ActionBarActivity {

    private MyClickListener myClickListener;
    private DrawerLayout drawerlayout;
    private LinearLayout navdrawer;
    private FilterMainFragment filtermainframent;
    private ActionBarDrawerToggle toggle;

    //private CharSequence mTitle;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main_activity);

        myClickListener = new MyClickListener(this);
        InitNavDrawer();
        InitActionBar();
        filtermainframent = FilterMainFragment.newInstance(this, myClickListener);
        setMainFragment(filtermainframent);
        //mTitle = getTitle();



    }

    void setMainFragment(Fragment fragment) {
        FragmentManager fragmentManager = getSupportFragmentManager();
        fragmentManager.beginTransaction()
                .replace(R.id.content_frame, fragment).commit();

    }

    void InitNavDrawer() {

        drawerlayout = (DrawerLayout) findViewById(R.id.drawer_layout);

        navdrawer = (LinearLayout) findViewById(R.id.nav_drawer);




    }


    void InitActionBar()
    {

        Toolbar toolbar = (Toolbar) findViewById(R.id.my_awesome_toolbar);
        setSupportActionBar(toolbar);



        toggle = new ActionBarDrawerToggle(
                this,
                drawerlayout,
                R.string.navigation_drawer_open,
                R.string.navigation_drawer_close);
        toggle.setDrawerIndicatorEnabled(true);
        drawerlayout.setDrawerListener(toggle);

        toolbar.setOnMenuItemClickListener(new Toolbar.OnMenuItemClickListener() {
            @Override
            public boolean onMenuItemClick(MenuItem item) {
                int id = item.getItemId();

                //noinspection SimplifiableIfStatement
                if (id == R.id.action_settings) {
                    return true;
                }

                //todo handle the menu item
                return true;
            }
        });

        toolbar.inflateMenu(R.menu.main_activity);

    }
/*
    public void onSectionAttached(int number) {
        mTitle = "";
    }

    public void restoreActionBar() {
        ActionBar actionBar = getSupportActionBar();
        actionBar.setDisplayShowTitleEnabled(true);
        actionBar.setTitle(mTitle);
    }*/


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {

        return super.onCreateOptionsMenu(menu);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if (toggle.onOptionsItemSelected(item))
            return true;
        return super.onOptionsItemSelected(item);
    }

    @Override
    protected void onPostCreate(Bundle savedInstanceState) {
        super.onPostCreate(savedInstanceState);
        toggle.syncState();
    }

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
        toggle.onConfigurationChanged(newConfig);
    }

}
