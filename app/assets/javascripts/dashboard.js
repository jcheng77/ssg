$(document).ready(function(){
    $("ul.myActions").tabs("div.myActions-panel > div");
    var tabHandler = $("ul.myActions").data("tabs");
    if(tabHandler){
        tabHandler.onBeforeClick(function(){
            $('div.myActions-panel').show();
        });    
    }
    
    $("ul.myActions li").click(function(){
        $('div.myActions-panel').show();
    });
    var toggleActionPanel = function(event){
        if(!$.contains($('div.myActions-panel').get(0), event.toElement?event.toElement:event.target)
            && !$.contains($('ul.myActions').get(0), event.toElement?event.toElement:event.target)) {
            $('div.myActions-panel').hide();    
        }
    };
    $(document).click(toggleActionPanel);
    //$("ul.myActions li").mouseout(toggleActionPanel);
    //$("div.myActions-panel").mouseout(toggleActionPanel);

    $("#parseUrl-btn-dash").click(function(){
        $("#share-btn").click();
        $("input.#url").val($("input.#url-dash").val());
        $("input.#url-dash").val("");
        $("#collect_item_form").submit();
    });
});