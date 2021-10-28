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
    scc.css("height", (parseFloat($(".scrolltextl").css("width")) * 1.4))
    if (screen.width <= 992) {
        $(".slidingcol").css("margin-top", 1 + "vh")
    }
    var popoverTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="popover"]'))
    var popoverList = popoverTriggerList.map(function (popoverTriggerEl) {
        return new bootstrap.Popover(popoverTriggerEl)
    })
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
    if (distance < screen && parseFloat(slidingcol.css("margin-top")) > 0 && (vh(25) - pxh(vh(100) - 2 * distance)) > 0) {
        if (screen.width >= 992) {
            slidingcol.css("margin-top", (vh(25) - pxh(vh(100) - 2 * distance)) + "px");
        } else {
            slidingcol.css("margin-top", (vh(10) - pxh(vh(100) - 2 * distance)) + "px");
        }

    }
    if ($("#triangle").offset().top-scrollTop < screen) {
        let temp = 150 - 0.5 * (screen - $("#triangle").offset().top+scrollTop);
        $("#exp_to_ed_poly").attr("points", `0 150, 500 150, 500 ${temp}, 0 0`)
    }


})

function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

async function navi(button_id, nav_id) {
    $(button_id).click();
    await sleep(300);
    $('html, body').animate({
        scrollTop: $(nav_id).offset().top-100
      }, 500)
}


