package com.lessonhome.clientapp;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.content.Context;
import android.support.v4.app.FragmentPagerAdapter;
import android.view.View;

/**
 * adapter for steps of filter <FilterPagesFragment>
 */
public class FilterViewPagerAdapter  extends FragmentPagerAdapter
        // implements ViewPager.OnPageChangeListener
{
    Context mContext;
    FilterPagesFragment mFilterPagesFragment;

    View.OnClickListener mclicklistener;


    public FilterViewPagerAdapter (Context context, FragmentManager fm, View.OnClickListener mclicklistener) {
        super(fm);
        mContext = context;
        this.mclicklistener = mclicklistener;
    }

    @Override
    public int getCount() {
        return 5;
    }

    @Override
    public Fragment getItem(int position) {
        return FilterPagesFragment.newInstance(position, mContext, mclicklistener);
    }

    @Override
    public CharSequence getPageTitle(int position) {
        //Locale loc = Locale.getDefault();
        switch (position) {//todo make page titles
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


