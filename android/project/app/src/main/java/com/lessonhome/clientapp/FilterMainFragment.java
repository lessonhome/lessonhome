package com.lessonhome.clientapp;

import android.app.Fragment;
import android.content.Context;
import android.os.Bundle;
import android.support.v4.view.ViewPager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RelativeLayout;

/**
 * Created by vlad on 25.01.2015.
 */
public class FilterMainFragment extends Fragment {




    Context context;
    FilterViewPagerAdapter mPagesAdapter;
    ViewPager mViewPager;
    RelativeLayout MainLay;



    static FilterMainFragment newInstance(Context _context) {
        FilterMainFragment Fragment = new FilterMainFragment();
        Bundle arguments = new Bundle();
        Fragment.setArguments(arguments);
        Fragment.context = _context;



        return Fragment;
    }


    public int getPosition() {
        return getArguments().getInt("ARGUMENT_PAGE_NUMBER", 0);
    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        if (container == null) {
            return null;
        }


        MainLay = (RelativeLayout)inflater.inflate(R.layout.filter_fragment, container, false);
        mViewPager = (ViewPager)MainLay.findViewById(R.id.mviewpager);
        mPagesAdapter = new FilterViewPagerAdapter(context, getFragmentManager());
        mViewPager.setAdapter(mPagesAdapter);

        return MainLay;
    }
}
