/*******************
 *  Fix method val for input and somsing else  *
 ******************/

(function ($) {

    var original_val = $.fn.val;

    $(document).ready(function() {
        $.fn.val = function (value) {

            if (typeof(value) === 'string') {
                $(this).each(function () {
                    var elem = $(this);
                    if (!elem.is('input[type=text], input[type=password], input[type=email], input[type=url], input[type=tel], input[type=number], input[type=search], textarea')) return true;

                    if (value.length > 0 || elem.attr('placeholder') !== undefined || elem[0].validity.badInput === true) {
                        elem.siblings('label').addClass('active');
                    }
                    else {
                        elem.siblings('label, i').removeClass('active');
                    }

                });
            }

            return original_val.apply(this, arguments)
        }
    });

})(jQuery);;