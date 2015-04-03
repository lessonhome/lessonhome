class @main extends template './search_bids'
  route : '/tutor/search_bids_filter'
  model   : 'tutor/bids/search_bids_filter'
  title : "поиск заявок с фильтром"
  tree : =>
    advanced_filter : state 'main/advanced_filter_popup'
    min_height       : '1028px'
