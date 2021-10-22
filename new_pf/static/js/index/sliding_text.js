function vh(v) {
    var h = Math.max(document.documentElement.clientHeight, window.innerHeight || 0);
    return (v * h) / 100;
}

function vw(v) {
    var w = Math.max(document.documentElement.clientWidth, window.innerWidth || 0);
    return (v * w) / 100;
}

$(document).on("scroll", function () {
    let stl = $(".scrolltextl");
    stl.css("right", Math.max(80 - 200 * window.scrollY / window.innerHeight) + "vw");
    let str = $(".scrolltextr");
    str.css("left", Math.max(80 - 200 * window.scrollY / window.innerHeight) + "vw");
    let sci = $(".scrollindicator");
    sci.css("opacity", Math.max(100 - 200 * window.scrollY / window.innerHeight) + "%");
    let apl = $(".appearlater");
    apl.css("opacity", Math.max(-200 + 200 * window.scrollY / window.innerHeight) + "%");
    let welcomesection = $(".welcomesection");
    let scrollTop = window.scrollY;
    let elementOffset = welcomesection.offset().top;
    let distance = (elementOffset - scrollTop);
    if (distance > vh(50)) {
        welcomesection.css("opacity", Math.max(-200 + 200 * window.scrollY / window.innerHeight) + "%");
    } else if (distance < vh(40)) {
        welcomesection.css("opacity", Math.max(100 - 100 * window.scrollY / window.innerHeight) + "%");

    }
})
