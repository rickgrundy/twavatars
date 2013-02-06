var TWAvatars = {
    timers: {
        highlightAlphabet: undefined
    },
        
    jumpToAlphabet: function(e) {
        var char = String.fromCharCode(e.which).toUpperCase();
        location.hash = "#" + char;
    },
    
    highlightAlphabet: function(e) {
        if (e) {
            clearTimeout(TWAvatars.timers.highlightAlphabet);
            TWAvatars.timers.highlightAlphabet = setTimeout(TWAvatars.highlightAlphabet, 10);
        } else {
            var initialsWithinViewport = $.grep($("a.initial"), function(initial) {
                return $(initial).offset().top >= window.pageYOffset && $(initial).offset().top < window.pageYOffset + window.innerHeight;
            }); 
            var initialsAboveViewport = $.grep($("a.initial"), function(initial) {
                return $(initial).offset().top <= window.pageYOffset;
            });
            var char = $(initialsWithinViewport[0] || initialsAboveViewport[initialsAboveViewport.length-1]).data("initial");
            $(".alphabet .letter").removeClass("active");
            $(".alphabet .letter:contains(" + char + ")").addClass("active");            
        }
    },
    
    zoomPhoto: function(e) {
        var offset = $(e.target).data("zoom-offset")
        $(".zoom").hide().css({
            "background-position": "-" + offset + " 0"
        }).appendTo($(e.target).parent()).fadeIn('fast');
        return false;
    },
    
    closeZoom: function(e) {
        $(".zoom:visible").fadeOut('fast');
    }
 }

$(function() {
    $(document).keypress(TWAvatars.jumpToAlphabet);
    $(document).scroll(TWAvatars.highlightAlphabet);
    $(document).click(TWAvatars.closeZoom);    
    $(".photo").click(TWAvatars.zoomPhoto);
});