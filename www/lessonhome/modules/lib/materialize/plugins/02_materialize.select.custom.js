(function ($) {
    var $body = $('body');
    /*******************
     *  Select Plugin  *
     ******************/
    $.fn.material_select = function (callback) {
        var elements = $(this).each(function(){
            var $select = $(this);

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

            /* Create dropdown structure. */
            if (selectOptGroups.length) {
                // Check for optgroup
                selectOptGroups.each(function() {
                    var $this = $(this);
                    selectOptions = $this.children('option');
                    options.append($('<li class="optgroup" data-open="0"><span>' + $this.attr('label') + '</span></li>'));
                    selectOptions.each(function() {
                        var $this = $(this);
                        var disabledClass = ($this.is(':disabled')) ? 'disabled ' : '';

                        // Add icons
                        if ($select.hasClass('icons')) {
                            var icon_url = $this.data('icon');
                            var classes = $this.attr('class');
                            if (!!icon_url) {
                                options.append($('<li class="' + disabledClass + '"><img src="' + icon_url + '" class="' + classes + '"><span>' + $this.html() + '</span></li>'));
                                return true;
                            }
                        }
                        //options.append($('<li class="' + disabledClass + ' subgroup_' + outGroup + '"><span>' + $(this).html() + '</span></li>'));
                        options.append($('<li class="' + disabledClass + '" data-value="' + this.value + '"><span><input type="checkbox"' + disabledClass + '/><label></label>' + $this.html() + '</span></li>'));
                    });
                });
            } else {
                selectOptions.each(function () {
                    var $this = $(this);
                    // Add disabled attr if disabled
                    var disabledClass = ($this.is(':disabled')) ? 'disabled ' : '';
                    if (multiple) {
                        options.append($('<li class="' + disabledClass + '" " data-value="' + this.value + '"><span><input type="checkbox"' + disabledClass + '/><label></label>' + $this.html() + '</span></li>'));
                    } else {
                        // Add icons
                        if ($select.hasClass('icons')) {
                            var icon_url = $this.data('icon');
                            var classes = $this.attr('class');
                            if (!!icon_url) {
                                options.append($('<li class="' + disabledClass + '"><img src="' + icon_url + '" class="' + classes + '"><span>' + $this.html() + '</span></li>'));
                                return true;
                            }
                        }
                        options.append($('<li class="' + disabledClass + '"><span>' + $this.html() + '</span></li>'));
                    }
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
            var opt = {
                constrainwidth : true,
                minwidth : false
            };

            if ($select.data('constrainwidth') !== undefined) opt.constrainwidth = $select.data('constrainwidth');
            if ($select.data('minwidth') !== undefined) opt.minwidth = $select.data('minwidth');

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
    			var exist = {};
    			value = value.replace(/^\s*|\s*$/gm, '').toLowerCase();		

    			if (value.length) {
    				$(options).addClass('filter-result').find('li:not(.optgroup)').each(function () {
    					var text = $(this).removeClass('active').text().toLowerCase();
    					var val = $(this).data('value');

    					if (text.indexOf(value) >= 0 && !exist[val]) {
    						exist[val] = true;
    						$(this).addClass('result');
    					} else {
    						$(this).removeClass('result');
    					}
    				
    				});
    			} else {
    				$(options).removeClass('filter-result')
    			}

            };

            var listeners = (function (options, multiple, callback, filter) {
                
                var valuesSelected = [];
                var optionsHover = false;
                return {
                    click_option : function (e) {
                        // Check if option element is disabled

                        //if ($(this).is('.optgroup')){
                        //    $(options).siblings('input.select-dropdown').focus();
                        //    return true;
                        //}

                        var $this = $(this),
                            o = $(options), $select;

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
                        multiple && (optionsHover || $(options).siblings('input.select-dropdown').trigger('close'));
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

                            if (e.which == 27 ) {
                                $(options).siblings('input.select-dropdown').blur().trigger('close');
                                return;
                            }

                            //ENTER
		                    if (e.which == 13 && $(options).is(':visible')) {
		                    	$(options).find('li.active:visible').trigger('click');
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
            }(options[0], multiple, callback, filter));

            options.on('click', 'li:not(.optgroup)', listeners.click_option);

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