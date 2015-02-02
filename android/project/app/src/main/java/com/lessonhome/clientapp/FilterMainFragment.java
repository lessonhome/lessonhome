package com.lessonhome.clientapp;

import android.support.v4.app.Fragment;
import android.content.Context;
import android.os.Bundle;
import android.support.v4.view.ViewPager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RelativeLayout;

/**
 * Fragment for PageFilter <FilterViewPagerAdapter<FilterPagesFragment>> and founded tutors/students<todo place here name of list for founded items>
 */
public class FilterMainFragment extends Fragment {




    Context context;
    FilterViewPagerAdapter mPagesAdapter;
    ViewPager mViewPager;
    RelativeLayout MainLay;
    View.OnClickListener mclicklistener;



    static FilterMainFragment newInstance(Context _context, View.OnClickListener mclicklistener) {
        FilterMainFragment Fragment = new FilterMainFragment();
        Bundle arguments = new Bundle();
        Fragment.setArguments(arguments);
        Fragment.context = _context;
        Fragment.mclicklistener = mclicklistener;



        return Fragment;
    }


    public int getPosition() {
        return getArguments().getInt("ARGUMENT_PAGE_NUMBER", 0);
    }


    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        if (container == null) {
            return null;
        }


        MainLay = (RelativeLayout)inflater.inflate(R.layout.filter_fragment, container, false);
        mViewPager = (ViewPager)MainLay.findViewById(R.id.mviewpager);
        mPagesAdapter = new FilterViewPagerAdapter(context, getChildFragmentManager(), mclicklistener);
        mViewPager.setAdapter(mPagesAdapter);

        return MainLay;
    }
}
