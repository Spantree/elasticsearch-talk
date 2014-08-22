var svg = null;

function init(e) {
    console.log("You are on a slide that will one day have an illustration");
}

function onShow(e) {
    init(e);  
}

document.addEventListener( 'shard-illustration-show', onShow, false );