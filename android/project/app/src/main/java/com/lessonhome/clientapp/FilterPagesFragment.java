package com.lessonhome.clientapp;

import android.support.v4.app.Fragment;
import android.content.Context;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

/**
 * Fragment for every page
 */
public class FilterPagesFragment extends Fragment {


    static final String ARGUMENT_PAGE_NUMBER = "section_number";



    Context context;
    FilterViewPagerAdapter mPagesAdapter;
    public int position;
    View.OnClickListener mclicklistener;



    static FilterPagesFragment newInstance(int page, Context _context, View.OnClickListener mclicklistener) {
        FilterPagesFragment pageFragment = new FilterPagesFragment();
        /*
        Bundle arguments = new Bundle();
        arguments.putInt(ARGUMENT_PAGE_NUMBER, page);
        pageFragment.setArguments(arguments);*/
        pageFragment.context = _context;

        pageFragment.position = page;
        pageFragment.mclicklistener = mclicklistener;

        return pageFragment;
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
        View view;
        switch (position)//todo use clicklistener
        {
            case 0:
                view = inflater.inflate(R.layout.filter_first_page, container, false);
                break;
            case 1:
                view = inflater.inflate(R.layout.filter_tutor_kind_page, container, false);
                break;
            case 2:
                view = inflater.inflate(R.layout.filter_address_page, container, false);
                break;
            case 3:
                view = inflater.inflate(R.layout.filter_range_of_price_page, container, false);
                break;
            case 4:
                view = inflater.inflate(R.layout.registration, container, false);
                break;
            default: return null;
        }



        return view;
    }
}
