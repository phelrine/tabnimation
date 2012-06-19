$(document).ready(function(){
    var isChrome = (navigator.userAgent.indexOf('Chrome') != -1);
    var slidesize = parseInt($("input[name = slidesize]").val());
    var filename = $("input[name = filename]").val();
    var counter = 0;

    var fakeClickOpen = function(url){
        if (isChrome){
            var a = $('<a target="_blank" href="'+ url +'"></a>');
            var evt;
            if (document.createEvent) {
                evt = document.createEvent("MouseEvents");
                if (evt.initMouseEvent) {
                    evt.initMouseEvent("click", true, true, window, 0, 0, 0, 0, 0, false, false, false, false, 1, null);
                    a.get(0).dispatchEvent(evt);
                }
            }
        }else{
            window.open(url);
        }
        return this;
    };


    $("#open-tab").click(function(){
        for (var i=0; i<25; i++) {
            if(counter < slidesize){
                fakeClickOpen(filename + "-" + (counter++) + '.png');
            }
        };
    });
});
