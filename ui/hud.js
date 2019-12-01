function SetGamemodeData(name, players){
    document.getElementById("gamemodes-"+name+"-players").innerText = players+" Players";
}

function SetGamemodePlaying(name){
    document.getElementById("gamemodes-playing").innerText = name;
}

ue.game.callevent("_freeroam_hud_ready", "[]");