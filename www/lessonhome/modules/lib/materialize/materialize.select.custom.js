(function ($) {
    var $body = $('body');
    /*******************
     *  Select Plugin  *
     ******************/
    $.fn.material_select = function (callback) {
        $(this).each(function(){
            var $select = $(this);

            if ($select.hasClass('browser-default')) {
                return; // Continue to next (return false breaks out of entire loop)
            }

            var multiple = $select.attr('multiple') ? true : false,
                lastID = $select.data('select-id'); // Tear down structure if Select needs to be rebuilt

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

            var valuesSelected = [],
                optionsHover = false;

            if ($select.find('option:selected').length > 0) {
                label = $select.find('option:selected');
            } else {
                label = selectOptions.first();
            }

            /* Create dropdown structure. */
            if (selectOptGroups.length) {
                // Check for optgroup
                var outGroup = 1
                selectOptGroups.each(function() {

                    selectOptions = $(this).children('option');
                    if(outGroup == 1) {
                        options.append($('<li class="optgroup" data-open="1" data-group="' + outGroup + '"><span>' + $(this).attr('label') + '</span></li>'));
                    } else {
                        options.append($('<li class="optgroup" data-open="0" data-group="' + outGroup + '"><span>' + $(this).attr('label') + '</span></li>'));
                    }
                    selectOptions.each(function() {
                        var disabledClass = ($(this).is(':disabled')) ? 'disabled ' : '';

                        // Add icons
                        if ($select.hasClass('icons')) {
                            var icon_url = $(this).data('icon');
                            var classes = $(this).attr('class');
                            if (!!icon_url) {
                                options.append($('<li class="' + disabledClass + '"><img src="' + icon_url + '" class="' + classes + '"><span>' + $(this).html() + '</span></li>'));
                                return true;
                            }
                        }
                        //options.append($('<li class="' + disabledClass + ' subgroup_' + outGroup + '"><span>' + $(this).html() + '</span></li>'));
                        options.append($('<li class="' + disabledClass + ' subgroup_' + outGroup + '"><span><input type="checkbox"' + disabledClass + '/><label></label>' + $(this).html() + '</span></li>'));
                    });

                    outGroup = outGroup + 1

                });
            } else {
                selectOptions.each(function () {
                    // Add disabled attr if disabled
                    var disabledClass = ($(this).is(':disabled')) ? 'disabled ' : '';
                    if (multiple) {
                        options.append($('<li class="' + disabledClass + '"><span><input type="checkbox"' + disabledClass + '/><label></label>' + $(this).html() + '</span></li>'));
                    } else {
                        // Add icons
                        if ($select.hasClass('icons')) {
                            var icon_url = $(this).data('icon');
                            var classes = $(this).attr('class');
                            if (!!icon_url) {
                                options.append($('<li class="' + disabledClass + '"><img src="' + icon_url + '" class="' + classes + '"><span>' + $(this).html() + '</span></li>'));
                                return true;
                            }
                        }
                        options.append($('<li class="' + disabledClass + '"><span>' + $(this).html() + '</span></li>'));
                    }
                });
            }


            options.find('li:not(.optgroup)').each(function (i) {
                var $curr_select = $select;
                $(this).click(function (e) {
                    // Check if option element is disabled
                    if (!$(this).hasClass('disabled') && !$(this).hasClass('optgroup')) {
                        if (multiple) {
                            $('input[type="checkbox"]', this).prop('checked', function(i, v) { return !v; });
                            toggleEntryFromArray(valuesSelected, $(this).index(), $curr_select);
                            $newSelect.trigger('focus');
                        } else {
                            options.find('li').removeClass('active');
                            $(this).toggleClass('active');
                            $curr_select.siblings('input.select-dropdown').val($(this).text());
                        }

                        activateOption(options, $(this));
                        $curr_select.find('option').eq(i).prop('selected', true);
                        // Trigger onchange() event
                        $curr_select.trigger('change');
                        if (typeof callback !== 'undefined') callback();
                    }

                    e.stopPropagation();
                });
            });

            // Wrap Elements
            $select.wrap(wrapper);
            // Add Select Display Element
            var dropdownIcon = $('<span class="caret">&#9660;</span>');
            if ($select.is(':disabled'))
                dropdownIcon.addClass('disabled');

            // escape double quotes
            var sanitizedLabelHtml = label.html() && label.html().replace(/"/g, '&quot;');

            var $newSelect = $('<input type="text" class="select-dropdown" readonly="true" ' + (($select.is(':disabled')) ? 'disabled' : '') + ' data-activates="select-options-' + uniqueID +'" value="'+ sanitizedLabelHtml +'"/>');
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

            $newSelect.on({
                'focus': function (){
                    if ($('ul.select-dropdown').not(options[0]).is(':visible')) {
                        $('input.select-dropdown').trigger('close');
                    }
                    if (!options.is(':visible')) {
                        $(this).trigger('open', ['focus']);
                        var label = $(this).val();
                        var selectedOption = options.find('li').filter(function() {
                            return $(this).text().toLowerCase() === label.toLowerCase();
                        })[0];
                        activateOption(options, selectedOption);
                    }
                },
                'click': function (e){
                    e.stopPropagation();
                }
            });

            $newSelect.on('blur', function() {
                if (!multiple) {
                    $(this).trigger('close');
                }
                options.find('li.selected').removeClass('selected');
            });

            options.hover(function() {
                optionsHover = true;
            }, function () {
                optionsHover = false;
            });

            $(window).on({
                'click': function (e){
                    multiple && (optionsHover || $newSelect.trigger('close'));
                }
            });

            // Make option as selected and scroll to selected position
            activateOption = function(collection, newOption) {
                collection.find('li.selected').removeClass('selected');
                $(newOption).addClass('selected');
            };

            // Allow user to search by typing
            // this array is cleared after 1 second
            var filterQuery = [],
                onKeyDown = function(e){
                    // TAB - switch to another input
                    if(e.which == 9){
                        $newSelect.trigger('close');
                        return;
                    }

                    // ARROW DOWN WHEN SELECT IS CLOSED - open select options
                    if(e.which == 40 && !options.is(':visible')){
                        $newSelect.trigger('open');
                        return;
                    }

                    // ENTER WHEN SELECT IS CLOSED - submit form
                    if(e.which == 13 && !options.is(':visible')){
                        return;
                    }

                    e.preventDefault();

                    // CASE WHEN USER TYPE LETTERS
                    var letter = String.fromCharCode(e.which).toLowerCase(),
                        nonLetters = [9,13,27,38,40];
                    if (letter && (nonLetters.indexOf(e.which) === -1)) {
                        filterQuery.push(letter);

                        var string = filterQuery.join(''),
                            newOption = options.find('li').filter(function() {
                                return $(this).text().toLowerCase().indexOf(string) === 0;
                            })[0];

                        if (newOption) {
                            activateOption(options, newOption);
                        }
                    }

                    // ENTER - select option and close when select options are opened
                    if (e.which == 13) {
                        var activeOption = options.find('li.selected:not(.disabled)')[0];
                        if(activeOption){
                            $(activeOption).trigger('click');
                            if (!multiple) {
                                $newSelect.trigger('close');
                            }
                        }
                    }

                    // ARROW DOWN - move to next not disabled option
                    if (e.which == 40) {
                        if (options.find('li.selected').length) {
                            newOption = options.find('li.selected').next('li:not(.disabled)')[0];
                        } else {
                            newOption = options.find('li:not(.disabled)')[0];
                        }
                        activateOption(options, newOption);
                    }

                    // ESC - close options
                    if (e.which == 27) {
                        $newSelect.trigger('close');
                    }

                    // ARROW UP - move to previous not disabled option
                    if (e.which == 38) {
                        newOption = options.find('li.selected').prev('li:not(.disabled)')[0];
                        if(newOption)
                            activateOption(options, newOption);
                    }

                    // Automaticaly clean filter query so user can search again by starting letters
                    setTimeout(function(){ filterQuery = []; }, 1000);
                };

            $newSelect.on('keydown', onKeyDown);
        });

        function toggleEntryFromArray(entriesArray, entryIndex, select) {
            var index = entriesArray.indexOf(entryIndex);

            if (index === -1) {
                entriesArray.push(entryIndex);
            } else {
                entriesArray.splice(index, 1);
            }

            select.siblings('ul.dropdown-content').find('li').eq(entryIndex).toggleClass('active');
            select.find('option').eq(entryIndex).prop('selected', true);
            setValueToInput(entriesArray, select);
        }

        function setValueToInput(entriesArray, select) {
            var value = '';

            for (var i = 0, count = entriesArray.length; i < count; i++) {
                var text = select.find('option').eq(entriesArray[i]).text();

                i === 0 ? value += text : value += ', ' + text;
            }

            if (value === '') {
                value = select.find('option:disabled').eq(0).text();
            }

            select.siblings('input.select-dropdown').val(value);
        }
    };
}( jQuery ));