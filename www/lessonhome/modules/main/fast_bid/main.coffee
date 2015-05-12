
class @main
  show : =>
    @button_next = @tree.button_next?.class
    @button_issue_bid = @tree.issue_bid?.class
    @content = @tree.content.class
    @button_next?.on 'submit', @b_next
    @button_issue_bid?.on 'submit', @b_issue_bid

    @content?.on 'make_active_issue_bid_button', => @button_issue_bid?.makeActive()
    @content?.on 'make_inactive_issue_bid_button', => @button_issue_bid?.makeInactive()
  b_next : =>
    @content?.save?().then (success)=>
      @button_next.submit() if success
      return true
    .done()

  b_issue_bid : =>
    @content?.save?().then (success)=>
      console.log 'status is : '+success
      @button_issue_bid.submit() if success
      return true
    .done()
