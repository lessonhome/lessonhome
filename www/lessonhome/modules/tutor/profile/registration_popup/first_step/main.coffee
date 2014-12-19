

class @main
  Dom : =>
    @tree.sex_man.class.onClick @click
    @tree.sex_woman.class.onClick @click
  click : (selector)=>
    console.log selector