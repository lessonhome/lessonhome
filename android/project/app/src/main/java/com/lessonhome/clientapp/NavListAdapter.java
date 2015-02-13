package com.lessonhome.clientapp;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

/**
 * Created by vlad on 12.02.2015.
 */
public class NavListAdapter extends BaseAdapter
{
    Context mContext;
    LayoutInflater lInflater;
    String[] items;
    View.OnClickListener onClickListener;

    public NavListAdapter(Context c, View.OnClickListener onClickListener) {
        mContext = c;
        this.onClickListener = onClickListener;

        lInflater = (LayoutInflater) mContext
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);
    }

    @Override
    public int getCount() {
        return 9;
    }

    @Override
    public String getItem(int position) {
        return items[position];
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    // create a new ImageView for each item referenced by the Adapter
    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        View view;

        if (convertView == null) {
            if (position==0)
            {

                view = lInflater.inflate(R.layout.nav_drawer_profile, parent, false);//todo change
                ((TextView)view.findViewById(R.id.name)).setText("I am GROOT");
                ((TextView)view.findViewById(R.id.mail)).setText("i@am.groot");
            }
            else
            {
                view = lInflater.inflate(R.layout.nav_drawer_button, parent, false);
                switch (position)
                {
                    case 1:
                        ((TextView)view.findViewById(R.id.nav_button_text)).setText(R.string.my_requests_navbut);
                        //((ImageView)view.findViewById(R.id.nav_button_image)).setImageResource();todo make icons in nav drawer
                        break;
                    case 2:
                        ((TextView)view.findViewById(R.id.nav_button_text)).setText(R.string.filter_navbut);
                        break;
                    case 3:
                        ((TextView)view.findViewById(R.id.nav_button_text)).setText(R.string.forum_navbut);
                        break;
                    case 4:
                        ((TextView)view.findViewById(R.id.nav_button_text)).setText(R.string.articles_navbut);
                        break;
                    case 5:
                        ((TextView)view.findViewById(R.id.nav_button_text)).setText(R.string.how_it_works_navbut);
                        break;
                    case 6:
                        ((TextView)view.findViewById(R.id.nav_button_text)).setText(R.string.settings_navbut);
                        break;
                    case 7:
                        ((TextView)view.findViewById(R.id.nav_button_text)).setText(R.string.help_navbut);
                        break;
                    case 8:
                        ((TextView)view.findViewById(R.id.nav_button_text)).setText(R.string.about_us_navbut);
                        break;
                }
            }
        } else {
            view = convertView;
        }

        view.setOnClickListener(onClickListener);
        return view;
    }


}