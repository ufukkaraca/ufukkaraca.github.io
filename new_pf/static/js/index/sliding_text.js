function vh(v) {
    var h = Math.max(document.documentElement.clientHeight, window.innerHeight || 0);
    return (v * h) / 100;
}

function vw(v) {
    var w = Math.max(document.documentElement.clientWidth, window.innerWidth || 0);
    return (v * w) / 100;
}

function pxw(px) {
    return px * (100 / document.documentElement.clientWidth);
}

function pxh(px) {
    return px * (100 / document.documentElement.clientHeight);
}

window.onload = function () {
    let scc = $(".slidercontainer");
    scc.css("height", (parseFloat($(".scrolltextl").css("width")) * 1.2))
}


$(document).on("scroll", function () {
    let stl = $(".scrolltextl");
    stl.css("right", Math.max(80 - 0.2 * (window.scrollY)) + "vw");
    let str = $(".scrolltextr");
    str.css("left", Math.max(80 - 0.2 * window.scrollY) + "vw");


    let sci = $(".scrollindicator");
    sci.css("opacity", Math.max(100 - 200 * window.scrollY / window.innerHeight) + "%");


    let slidingcol = $(".slidingcol");
    let scrollTop = window.scrollY;
    let elementOffset = slidingcol.offset().top;
    let distance = (elementOffset - scrollTop);
    let screen = vh(100)
    console.log("Margin Top: "+slidingcol.css("margin-top"))
    console.log("Offset:" + (elementOffset))
    console.log("Distance: " + distance)



})
