$.fn.focusNextInputField = function() {
return this.each(function() {
var fields = $(this).parents('form:eq(0),body').find('button,input,textarea,select');
var index = fields.index( this );
if ( index > -1 && ( index + 2 ) < fields.length ) {
fields.eq( index + 2 ).focus();
}
return false;
});
};