(function ($) {
    var $body = $('body');
    /*******************
     *  Select Plugin  *
     ******************/
    $.fn.material_select = function (callback) {
        var elements = $(this).each(function(){
            var $select = $(this);
            var opt = {
                constrainwidth : true,
                minwidth : false,
                large : false
            };

            if ($select.data('constrainwidth') !== undefined) opt.constrainwidth = $select.data('constrainwidth');
            if ($select.data('minwidth') !== undefined) opt.minwidth = $select.data('minwidth');
            if ($select.data('large') !== undefined) opt.large = $select.data('large');


            if ($select.hasClass('browser-default')) {
                return; // Continue to next (return false breaks out of entire loop)
            }

            var multiple = $select.attr('multiple') ? true : false,
                lastID = $select.data('select-id'), // Tear down structure if Select needs to be rebuilt
                filter = $select.data('filter') ? true : false;

            if (lastID) {
                $select.parent().find('span.caret').remove();
                $select.parent().find('input').remove();

                $select.unwrap();
                $('ul#select-options-'+lastID).remove();
            }

            // If destroying the select, remove the selelct-id and reset it to it's uninitialized state.
            if(callback === 'destroy') {
                $select.data('select-id', null).removeClass('initialized');
                return;
            }

            var uniqueID = Materialize.guid();
            $select.data('select-id', uniqueID);
            var wrapper = $('<div class="select-wrapper"></div>');
            wrapper.addClass($select.attr('class'));
            var options = $('<ul id="select-options-' + uniqueID +'" class="dropdown-content select-dropdown ' + (multiple ? 'multiple-select-dropdown' : '') + '"></ul>');
            var selectOptions = $select.children('option');
            var selectOptGroups = $select.children('optgroup');

            var label = $select.find('option:selected');

            if (label.length <= 0) {
                label = selectOptions.first();
            }

            var getOption = (function (is_icon, multiple) {
                return function (option) {
                    var disabledClass = (option.is(':disabled')) ? 'disabled ' : '';
                    var checked = option.is(':selected') ? ' checked=\"checked\"' : '';
                    if (multiple) {
                        return $('<li class="' + disabledClass + '" " data-value="' + option[0].value + '"><span><input type="checkbox"' + disabledClass + checked+ '/><label></label>' + option.html() + '</span></li>').css({});
                    } else {
                        // Add icons
                        if (is_icon) {
                            var icon_url = option.data('icon');
                            var classes = option.attr('class');
                            if (!!icon_url) {
                                return $('<li class="' + disabledClass + '"><img src="' + icon_url + '" class="' + classes + '"><span>' + option.html() + '</span></li>');
                            }
                        }
                        return $('<li class="' + disabledClass + '"><span>' + option.html() + '</span></li>');
                    }
                }

            }($select.hasClass('icons'), multiple));



            /* Create dropdown structure. */
            if (selectOptGroups.length) {
                // Check for optgroup
                selectOptGroups.each(function() {
                    var $this = $(this);
                    selectOptions = $this.children('option');
                    options.append($('<li class="optgroup" data-open="0"><span>' + $this.attr('label') + '</span></li>'));
                    if (!$select.data('large')){
                        selectOptions.each(function() {
                            options.append( getOption($(this)) );
                        });
                    }
                });
            } else {
                selectOptions.each(function() {
                    options.append( getOption($(this)) );
                });
            }

            // Wrap Elements
            $select.wrap(wrapper);
            // Add Select Display Element
            var dropdownIcon = $('<span class="caret">&#9660;</span>');
            if ($select.is(':disabled'))
                dropdownIcon.addClass('disabled');

            // escape double quotes
            var sanitizedLabelHtml = label.html() && label.html().replace(/"/g, '&quot;');

            var $newSelect = $('<input type="text" class="select-dropdown" '+ (filter ? '' : 'readonly="true" ') + (($select.is(':disabled')) ? 'disabled' : '') +' data-constrainwidth="'+opt.constrainwidth+'" data-minwidth="'+opt.minwidth+'" data-beloworigin="true" data-activates="select-options-' + uniqueID +'" value="'+ sanitizedLabelHtml +'"/>');
            $select.before($newSelect);
            $newSelect.before(dropdownIcon);

            $body.append(options);
            // Check if section element is disabled
            if (!$select.is(':disabled')) {
                $newSelect.dropdown({'hover': false, 'closeOnClick': false});
            }

            // Copy tabindex
            if ($select.attr('tabindex')) {
                $($newSelect[0]).attr('tabindex', $select.attr('tabindex'));
            }

            $select.addClass('initialized');

            // Make option as selected and scroll to selected position
            var activateOption = function(collection, newOption) {
                collection.find('li.selected').removeClass('selected');
                $(newOption).addClass('selected');
            };

            var setFilter = function(options, value) {
                options = $(options);
                var exist = {};

    			value = value.replace(/^\s*|\s*$/gm, '').toLowerCase();

                options.find('li.result').remove();

    			if (value.length) {
                    var frag = $(document.createDocumentFragment());
                    var elems = [];
    				options.addClass('filter-result');
                    options.siblings('select').find('option').each(function () {
    					var val = this.value;
                        var text = $(this).text().toLowerCase();
                        var i = text.indexOf(value);

    					if (i >= 0 && !exist[val]) {
                            exist[val] = true;

                            elems.push({
                                i : i,
                                text : text,
                                q : getOption($(this)).addClass('result')
                            });

                        }

    				});

                    elems.sort(function (a, b) {
                        if (a.i != b.i) return a.i - b.i;
                        return a.text >= b.text;
                    });

                    for (var i = 0; i < elems.length; i++) {
                        frag.append(elems[i].q);
                    }
                    options.prepend(frag);
    			} else {
    				options.removeClass('filter-result')
    			}

            };

            var listeners = (function (options, multiple, callback, filter, large) {

                var valuesSelected = [];
                var optionsHover = false;
                return {
                    click_option : function (e) {
                        var $this = $(this), o = $(options), $select;

                        if ($this.is('.optgroup')){

                            if ($this.attr('data-open') == '0') {
                                o.find('.optgroup').attr('data-open', 0);

                                if (large && !$this.data('fill')) {
                                    var current = $this;
                                    o.siblings('select').find('optgroup[label=\"'+$this.text()+'\"]').find('option').each(function () {
                                        var o = getOption($(this));
                                        current.after( o );
                                        current = o;

                                    });
                                    $this.attr('data-fill', 'true');
                                }

                                $this.attr('data-open', 1);
                                setTimeout(function () {
                                    var top = Math.ceil(o.scrollTop() + $this.position().top);
                                    if (top) o.animate({scrollTop: top}, 200);
                                }, 17);
                            }else{
                                $this.attr('data-open', 0);
                            }

                            return true;
                        }



                        if (!$this.hasClass('disabled') && !$this.hasClass('optgroup')) {
                            var value = $this.attr('data-value');

                            if (multiple) {
                            	var index  = _addValues(valuesSelected, $(this).text());
                                o.find('li[data-value=\"'+value+'\"] input[type="checkbox"]').prop('checked', index < 0);

                                if (filter && o.siblings('input.select-dropdown').is(':focus')){
                                    /*   */
                                }  else {
                                    _setValueToInput(valuesSelected, o.siblings('select'));
                                }

                                if (e.pageX - o.offset().left > 55) {
                                    o.siblings('input.select-dropdown').trigger('close');
                                }

                            } else {
                                o.find('li').removeClass('active');
                                $this.toggleClass('active');
                                o.siblings('input.select-dropdown').val($this.text());
                            }

                            activateOption(o, $this);
                            $select = o.siblings('select');
                            $select.find('option[value=\"'+value+'\"]:not(:disabled)').prop('selected', function (i, v) {return !v});
                            //$select.find('option').eq(i).prop('selected', true);
                            // Trigger onchange() event
                            $select.trigger('change');
                            if (typeof callback !== 'undefined') callback();
                        }

                        e.stopPropagation();


                    },

                    focus_input : function (){
                        if ($('ul.select-dropdown').not(options).is(':visible')) {
                            $('input.select-dropdown').trigger('close');
                        }

                        if(filter) {
                            $(this).val('');
                            $(options).removeClass('filter-result');
                        }

                        if (!$(options).is(':visible')) {

                            $(this).trigger('open', ['focus']);
                        	//var label = $(this).val();
                            //var selectedOption = options.find('li').filter(function() {
                            //    return $(this).text().toLowerCase() === label.toLowerCase();
                            //})[0];
                            //activateOption(options, selectedOption);
                        }

                    },

                    blur_input : function() {

                        if (!multiple) {
                            $(this).trigger('close');
                        }

                        if (filter) {
                            _setValueToInput(valuesSelected, $(this).siblings('select'));
                        }

                        $(options).find('li.selected').removeClass('selected');
                    },

                    window_click : function (){
                        multiple && (optionsHover || $(options).siblings('input.select-dropdown').trigger('close').blur());
                    },

                    update : function (e) {
                        var exist = {};
                        valuesSelected = [];

                        $(e.currentTarget).find('option:selected:not([value=""])').each(function () {

                            if (!exist[this.value]) {
                                valuesSelected.push(this.innerHTML);
                                //query += (query?',':'') + '[data-value=\"'+this.value+'\"]';
                                exist[this.value] = true;
                            }

                        });

                        $(options).find('li:not(.optgroup)').each(function () {
                            $(this).find('input[type="checkbox"]').prop('checked', !!exist[$(this).data('value')]);
                        });

                        if (filter && $(this).siblings('input.select-dropdown').is(':focus')){
                            /*   */
                        }  else {
                            _setValueToInput(valuesSelected, $(this));
                        }
                    },

                    hover_option : [
                        function () {optionsHover = true;},
                        function () {optionsHover = false;}
                    ],

                    //close_input : function (e) {
                    //	//_setValueToInput(valuesSelected, $(this).siblings('select'));
                    //},

                    key_press : (function () {
                    	var index = null;
                    	return function (e) {
                            //DOWN AND UP
                    		if (e.which == 40 || e.which == 38) {
                    			var el = $(options).find('li:not(.optgroup):visible');
                				el.eq(
                					el.index( el.filter('.active').removeClass('active') ) + (e.which == 40 ? 1 : -1)
            					).addClass('active');
		                    	return;
		                    }
                            //TAB
                            if (e.which == 9) {
                                return;
                            }
                            //ESC
                            if (e.which == 27 ) {
                                $(options).siblings('input.select-dropdown').trigger('close').blur();
                                return;
                            }

                            //ENTER
		                    if (e.which == 13 && $(options).is(':visible')) {
		                    	var l = $(options).find('li.active:visible').trigger('click').length;
                                var input = $(options).siblings('input.select-dropdown');
                                input.trigger('close').blur();
		                    	return;
		                    }

                    		if (filter) {
                                //var input = $(this);
	                    		clearTimeout(index);
	                    		index = setTimeout(function () {
                                    //input.data('save', input.val());
	                    			setFilter(options, e.currentTarget.value);
	                    		}, 150);
                    		}

                    	}
                    }())

                }
            }(options[0], multiple, callback, filter, opt.large));

            options.on('click', 'li', listeners.click_option);

            $newSelect.on({
                'focus': listeners.focus_input,
                'click': function (e){
                    e.stopPropagation();
                }
            });

            $newSelect.on('blur', listeners.blur_input);

            $.fn.hover.apply(options, listeners.hover_option);

            $(window).on('click', listeners.window_click);

            $newSelect.on('keydown', listeners.key_press);
            $select.on('update', listeners.update);
            $select.trigger('update');
        });

        function _addValues(entriesArray, text) {
        	var index = entriesArray.indexOf(text);

        	if (index === -1) {
                entriesArray.push(text);
            } else {
                entriesArray.splice(index, 1);
            }

            return index;
        }

        function _setValueToInput(entriesArray, select) {
            var value = '';

            for (var i = 0, count = entriesArray.length; i < count; i++) {
                var text = entriesArray[i];
                i === 0 ? value += text : value += ', ' + text;
            }

            if (value === '') {
                value = select.find('option:disabled').eq(0).text();
            }

            select.siblings('input.select-dropdown').val(value);
        }

        return elements;
    };
}( jQuery ));