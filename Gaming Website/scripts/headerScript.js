window.onscroll = scrollFunction;
window.onload = scrollFunction;

function scrollFunction() {
    var scrollDistance = document.body.scrollTop;
    if (scrollDistance <= 15) {
        document.getElementById("title").style.fontSize = "4vw";
        document.getElementById("title").style.padding = "1vw";
    } else {
        document.getElementById("title").style.fontSize = "2vw";
        document.getElementById("title").style.padding = "0.5vw";
    }
}
