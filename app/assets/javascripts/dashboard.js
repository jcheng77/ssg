$(document).ready(function(){
    $("ul.myActions").tabs("div.myActions-panel > div", {event: 'mouseover'});
    var tabHandler = $("ul.myActions").data("tabs");
    tabHandler.onBeforeClick(function(){
        $('div.myActions-panel').show();
    });
    $("ul.myActions li").mouseover(function(){
        $('div.myActions-panel').show();
    });
    var toggleActionPanel = function(event){
        if(!$.contains($('div.myActions-panel').get(0), event.toElement)
            && !$.contains($('ul.myActions').get(0), event.toElement)) {
            $('div.myActions-panel').hide();    
        }
    };
    $("ul.myActions li").mouseout(toggleActionPanel);
    $("div.myActions-panel").mouseout(toggleActionPanel);
});