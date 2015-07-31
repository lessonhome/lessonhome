
class @main
  Dom: =>
    @rating = @tree.rating.class
    @full_name = @found.full_name
    @personal_data = @tree.personal_data.class
    @edu = @tree.edu.class
    @about_text = @found.about_text
    @honors_text = @found.honors_text
  setValue : (data)=>
    @rating.setValue data.rating
    @full_name.text(data.full_name)
    @personal_data.setValue data.personal_data
    @edu.setValue data.edu
    @about_text.text(data.about_text)
    @honors_text.text(data.honors_text)
