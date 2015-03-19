jQuery.expr[':'].regex = function(elem, index, match) {
    var matchParams = match[3].split(','),
        validLabels = /^(data|css):/,
        attr = {
            method: matchParams[0].match(validLabels) ? 
                        matchParams[0].split(':')[0] : 'attr',
            property: matchParams.shift().replace(validLabels,'')
        },
        regexFlags = 'ig',
        regex = new RegExp(matchParams.join('').replace(/^s+|s+$/g,''), regexFlags);
    return regex.test(jQuery(elem)[attr.method](attr.property));
}
var escapeRegExp;

(function () {
    // Referring to the table here:
    // https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/regexp
    // these characters should be escaped
    // \ ^ $ * + ? . ( ) | { } [ ]
    // These characters only have special meaning inside of brackets
    // they do not need to be escaped, but they MAY be escaped
    // without any adverse effects (to the best of my knowledge and casual testing)
    // : ! , =
    // my test "~!@#$%^&*(){}[]`/=?+\|-_;:'\",<.>".match(/[\#]/g)

    var specials = [
            // order matters for these
            "-"
            , "["
            , "]"
            // order doesn't matter for any of these
            , "/"
            , "{"
            , "}"
            , "("
            , ")"
            , "*"
            , "+"
            , "?"
            , "."
            , "\\"
            , "^"
            , "$"
            , "|"
        ]

    // I choose to escape every character with '\'
    // even though only some strictly require it when inside of []
        , regex = RegExp('[' + specials.join('\\') + ']', 'g')
        ;

    escapeRegExp = function (str) {
        return str.replace(regex, "\\$&");
    };

    // test escapeRegExp("/path/to/res?search=this.that")
}());
this.escapeRegExp = escapeRegExp;