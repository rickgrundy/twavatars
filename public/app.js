var TWAvatars = {
    jumpToAlphabet: function(e) {
        var char = String.fromCharCode(e.which).toUpperCase();
        location.hash = "#" + char;
    }
}

$(function() {
    $(document).keypress(TWAvatars.jumpToAlphabet);    
});
