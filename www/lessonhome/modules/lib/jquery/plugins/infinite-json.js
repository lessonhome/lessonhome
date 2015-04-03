/**
 * infinite-json.js Cycling and decycling of JavaScript objects into and from JSON.
 *
 * Module to allow the creation of JSON structures from a JavaScript object
 * which contains recursive/circular references. Also allows the decycling
 * of JSON structures. The stringify portion of this module is based on
 * the repo at https://github.com/isaacs/json-stringify-safe
 *
 * IMPORTANT: If you do not have cycle references in your JavaScript object, then
 * you do not need this. Performance takes a big hit, when creating and solving
 * cycles. Use JSON stringify and parse when possible.
 *
 * Copyright (C) 2013-2014 Julio Stanley <>
 *
 * LICENSE: This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 3
 * of the License, or (at your option) any later version.
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://opensource.org/licenses/gpl-license.php>;.
 *
 * @package com.juliostanley.code.js-infinite-json
 * @version 0.0.1
 * @author  Julio Stanley <>
 * @link    https://github.com/juliostanley
 */

// Encapsulate code so it may run on either NodeJS or Browser 
(function(){

	/**
	 * Returns a callback function that can be used
	 * to remove circular references, from any JavaScript
	 * object. 
	 * 
	 * @param  {Function} fn      Callback to be used as an extension. Must return the solved value.
	 * @param  {Function} decycle Callback to be used for the identification of a cycled/recursive value. Must return a string.
	 * @return {Mixed}            May return the original value or a modified one (Primitve value or Object)
	 */
	function getSerialize (fn, decycle) {
		// Define lists to keep track of the objects found
		var seen = [], keys = [];

		// Define the decycling method which creates the circular representation of the value provided
		decycle = decycle || function(key, value) {
			return '[Circular ' + getPath(value, seen, keys) + ']'
		};

		// Return the actual callback for JSON.stringify or any direct/recursive call to getSerialize
		return function(key, value) {
			var ret = value;
			if (typeof value === 'object' && value) {
				if (seen.indexOf(value) !== -1)
					ret = decycle(key, value);
				else {
					seen.push(value);
					keys.push(key);
				}
			}
			if (fn) ret = fn(key, ret);
			return ret;
		}
	}

	/**
	 * Used to figure out the "path" of a value within an object
	 * structure represented by an existing list of seen values, 
	 * and their corresponding keys.
	 *  
	 * @param  {Mixed} value The current value which we are attempting to create the path of (this value must exist within the seen list)
	 * @param  {Array} seen  List of seen values form the existing object
	 * @param  {Array} keys  List of key names from the existing object 
	 * @return {String}      Path within the object to the original value already "seen"
	 */
	function getPath (value, seen, keys) {
		var index = seen.indexOf(value);
		var path = [ keys[index] ];
		for (index--; index >= 0; index--) {
			if (seen[index][ path[0] ] === value) {
				value = seen[index];
				path.unshift(keys[index]);
			}
		}
		return '~' + path.join('.');
	}

	/**
	 * Constructor of a JSON representation for a
	 * JavaScript object, intended to be used just as
	 * JSON.stringify. The advantage is it uses a special
	 * serialization callback to create a JSON which stores
	 * as string values any circular reference that exists
	 * within the JavaScript object.
	 * 
	 * @param  {Object}   obj     The JavaScript object to be stringified 
	 * @param  {Function} fn      (Optional) Callback to be used for the transformation of values and properties encountered while stringifying
	 * @param  {Boolean}  spaces  (Optional) Causes the resulting string to be pretty-printed
	 * @param  {Function} decycle (Optional) Callback for the decycling method, refer to getSerialize method
	 * @return {String}           Returns the JSON respresentation of an object as a string
	 */
	function stringify( obj, fn, spaces, decycle ) {
		return JSON.stringify(obj, getSerialize(fn, decycle), spaces);
	}

	// Expose the getSerialize method
	stringify.getSerialize = getSerialize;






	/**
	 * Callback to be used to restore a value from a JSON
	 * string representation. Usually used with a value defined
	 * for the parameter 'fn', as this allows granular modifications
	 * during the parsing/deserialization process.
	 * 
	 * @param  {Function} fn Callback to be used when bring a value back to life from a previously serialized object
	 * @return {Mixed}       The value deserialized, and or modified by the 'fn' callback
	 */
	function revive( fn ) {
		return function( key, value ) {

			// Revive as requested
			if (fn) value = fn( key, value );
			
			// Provide the actuall value
			return value;
		}

	}

	/**
	 * Get the value within the data using the path provided
	 * 
	 * @param  {Object} data  The object from which to obtain the value using the path
	 * @param  {String} path  The path within the object up to the value to be returned 
	 * @return {Mixed}        The value found within the object using the path provided
	 */
	function getFromPath( data, path ) {

		// Data provided?
		if ( !data )
			return null;

		// Get the "keys" up to the value intended to obtain from the data object
		var parts;
		if ( typeof path === 'string' )
			parts = path.split( '.' );
		else
			return null;

		// Remove the first empty element
		// TODO: If a custom decycle method is used, there will be no first empty element, solve this 
		parts.shift();
		
		// Obtain the value from within the data
		var ret = data;
		for (var i=0; i <= parts.length-1; i++)
		{
			if ( typeof ret === 'object' && ret[ parts[i] ] )
				ret = ret[ parts[i] ];
			else 
				return null;
		}

		return ret;
	}


	/**
	 * Cycles values that already exist within an object/data stracture
	 * performing a recursive procedure.
	 * 
	 * @param  {Mixed} obj         The current object or primitive value being analyzed, if string and matches the cycle reference RegExp, the path will be solved, and the original cycled value assigned to the key
	 * @param  {String} key        (optional) The key name of the object currently being analyzed
	 * @param  {Function} filterFn (optional) Callback to to define if the value should be nulled out or modified. TODO: Review deletion of the key from the data structure
	 * @return {Mixed}             Returns the object as a new cycle reference or its original value
	 */
	function findAndSolvePointers( obj, key, filterFn )
	{
		// HACK: Really ugly hack!! Using module's constructor scope parsedData so there is always an appropiate root data, even when module is used through parse.findAndSolvePointers directly
		// TODO: Find a better implementation
		if( !parsedData ) parsedData = obj;

		// Add a level deep
		levelDeep++;

		// Solve the object
		if( Object.prototype.toString.call( obj ) === '[object Array]' )
		{
			for( var i=0; i<obj.length; i++ )
			{
				// Was a filter function defined
				if( filterFn ) obj[ i ] = filterFn( i, obj[ i ] );

				// Only if a value is still defined continue
				if( typeof obj[ i ] !== 'undefined' && obj[ i ] !== null )
					obj[ i ] = findAndSolvePointers( obj[ i ], i, filterFn );
			}
		}
		else if( Object.prototype.toString.call( obj ) === '[object Object]' )
		{
			for (var key in obj) {
				if( obj.hasOwnProperty(key) ) 
				{
					// Was a filter function defined
					if( filterFn ) obj[ key ] = filterFn( key, obj[ key ] );

					// Only if a value is still defined continue
					if( typeof obj[ key ] !== 'undefined' && obj[ key ] !== null )
						obj[ key ] = findAndSolvePointers( obj[ key ], key, filterFn );
				}
			}
		}
		else if( typeof obj === 'string' && obj.match( cycleMatchRegExp ) )
		{
			// Was a filter function defined
			if( filterFn ) obj = filterFn( key, obj );

			// Only if a value is still defined continue
			if( typeof obj !== 'undefined' && obj !== null )
					obj = cycle( parsedData, obj.replace( cycleMatchRegExp, '$1' ) );
		}

		// Lower the level back
		levelDeep--;

		// Clear parsed data if this was the last request to findAndSolvePointers 
		if( levelDeep === 0 ) parsedData = undefined;

		// Provide it back
		return obj;
	}

	// TODO: Work on all of this for an encapsulated and better solution
	// Closure definitions for the cycling of the data structure
	var parsedData;
	var levelDeep=0;
	var cycleMatchRegExp = /\[Circular\s~(([^\]]+)?)\]/;

	/**
	 * Method to be used when a cycle reference is found, it defines
	 * how the data is restored.
	 * 
	 * @param  {Object} data  The root of the data structure containing the referenced cycle 
	 * @param  {String} path  The path that must be followed on the data structure to find the corresponding value to be returend 
	 * @return {Object}       The corresponding value within the data structure, corresponding to the path provided
	 */
	function cycle( data, path ) {
		return getFromPath( data, path.replace(cycleMatchRegExp, '$1') )
	}

	// TODO: 
	/**
	 * Performance
	 *
	 * TODO: Improve performance, Work on a better encapsulated and better solution
	 * 
	 * @param  {String}   str     Serialized JSON structure containing cycle references
	 * @param  {Function} fn      (Optional) Callback method called upon each revival of value during deserialization
	 * @param  {RegExp}   regExp  (Optional) Regular expression to find pointers
	 * @param  {Function} cycleFn (Optional) Callback used to define how to solve a pointer, receives (data, path). Root of the data structure deserialized and the pointer/path to the object desired
	 * @param  {Function} solveFn (Optional) Callback that may be used to override the default solving of pointers/cycles within the serialized/JSON structure
	 * @return {Object}           Deserialized and cycled object created from the serialized string provided
	 */
	function parse( str, fn, regExp, cycleFn, solveFn ) {

		// Which regular expression should be used
		if (regExp) cycleMatchRegExp = regExp;

		// Get the data without cycling it back
		parsedData = JSON.parse( str, revive( fn ) );

		// Used to cycle it back
		cycle = cycleFn || cycle;

		// Solve the cycles
		var solvedData = solveFn ? solveFn( parsedData ) : findAndSolvePointers( parsedData );

		// Return the solved data
		return solvedData;
	}

	// Expose the findAndSolvePointers method
	parse.findAndSolvePointers = findAndSolvePointers;

	// Add them to the object
	this.parse     = parse;
	this.stringify = stringify;

// Pass the exports module if exists, otherwise pass in and create a global module (running in browser)  
}).call( (typeof exports === 'undefined') ? (this['InfiniteJSON']={}) : exports );