package com.lessonhome.clientapp;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

/**
 * Created by vlad on 30.01.2015.
 */
public class NavDrawerListAdapter extends BaseAdapter
{
    Context mContext;
    LayoutInflater lInflater;
    String[] names_of_layouts_to_go;
    View.OnClickListener mclicklistener;

    public NavDrawerListAdapter(Context c, String [] names_of_layouts_to_go, View.OnClickListener mclicklistener) {
        mContext = c;

        this.names_of_layouts_to_go = names_of_layouts_to_go;
        this.mclicklistener = mclicklistener;
        lInflater = (LayoutInflater) mContext
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);
    }

    @Override
    public int getCount() {
        return names_of_layouts_to_go.length+1;
    }

    @Override
    public String getItem(int position) {
        if (position == 0)
        {
            return "User review";
        }
        return names_of_layouts_to_go[position-1];
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        View item;

        if (convertView == null) {

            if (position == 0)
            {
                item = lInflater.inflate(R.layout.nav_drawer_text_view, parent, false);//todo replace
            }
            else
            {
                item = lInflater.inflate(R.layout.nav_drawer_text_view, parent, false);

            }

        } else {
            item = convertView;
        }

        if (position == 0)//todo use clicklistener
        {
        }
        else
        {
            ((TextView)item).setText(names_of_layouts_to_go[position-1]);
            item.setOnClickListener(mclicklistener);
        }

        return item;
    }


}