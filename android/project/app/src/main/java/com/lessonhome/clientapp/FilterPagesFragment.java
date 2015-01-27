package com.lessonhome.clientapp;

import android.app.Fragment;
import android.content.Context;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

/**
 * Created by vlad on 25.01.2015.
 */
public class FilterPagesFragment extends Fragment {


    static final String ARGUMENT_PAGE_NUMBER = "section_number";



    Context context;
    FilterViewPagerAdapter mPagesAdapter;



    static FilterPagesFragment newInstance(int page, Context _context) {
        FilterPagesFragment pageFragment = new FilterPagesFragment();
        Bundle arguments = new Bundle();
        arguments.putInt(ARGUMENT_PAGE_NUMBER, page);
        pageFragment.setArguments(arguments);
        pageFragment.context = _context;



        return pageFragment;
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


        View view = inflater.inflate(R.layout.filterfirstpage, container, false);


        return view;
    }
}
