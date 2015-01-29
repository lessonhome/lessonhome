package com.lessonhome.clientapp;

import android.app.Fragment;
import android.app.FragmentManager;
import android.content.Context;
import android.support.v13.app.FragmentPagerAdapter;

/**
 * Created by vlad on 25.01.2015.
 */
public class FilterViewPagerAdapter  extends FragmentPagerAdapter
        // implements ViewPager.OnPageChangeListener
{
    Context mContext;
    FilterPagesFragment mFilterPagesFragment;


    public FilterViewPagerAdapter (Context context, FragmentManager fm) {
        super(fm);
        mContext = context;
    }

    @Override
    public int getCount() {
        return 5;
    }

    @Override
    public Fragment getItem(int position) {
        return mFilterPagesFragment.newInstance(position, mContext);
    }

    @Override
    public CharSequence getPageTitle(int position) {
        //Locale loc = Locale.getDefault();
        switch (position) {
            case 0:
                return "Section 1";//.toUpperCase(loc);
            case 1:
                return "Section 2";//.toUpperCase(loc);
            case 2:
                return "Section 3";//.toUpperCase(loc);
        }
        return null;
    }

    /*
    @Override
    public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {
    }

    @Override
    public void onPageSelected(int position) {
    }

    @Override
    public void onPageScrollStateChanged(int state) {
    }
*/


}
//*/


