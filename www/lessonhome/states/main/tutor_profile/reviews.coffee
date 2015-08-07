
class @main extends @template '../tutor_profile'
  route: '/profile/reviews'
  model : 'main/tutor_profile_general'
  title : "Анкета репетитора отзывы"
  access : ['other','pupil']
  tree : =>
    selector: 'reviews'
    g_selector : 'profile_nav'
    s_selector: 'profile_nav'
    r_selector: 'profile_nav_active'
    content : @module 'tutor/profile_content/reviews_content' :
      reviews_rating  : @module 'rating_star':
        filling   : 0
        selector  : 'padding_no'
      pupils_number : 0
      list_reviews : []