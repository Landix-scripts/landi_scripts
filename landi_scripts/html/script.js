let crafting = false;

window.addEventListener("message", function(e){
    let d = e.data;

    if(d.type === "open"){
        document.getElementById("menu").style.display = "block";
        document.getElementById("bg").style.display = "block";
    }

    if(d.type === "close"){
        document.getElementById("menu").style.display = "none";
        document.getElementById("bg").style.display = "none";
    }

    if(d.type === "data"){
        let list = document.getElementById("list");
        list.innerHTML = "";

        d.weapons.forEach(w => {

            let mats = "";
            for(let m in w.materials){
                mats += m + ": " + w.materials[m] + "<br>";
            }

            list.innerHTML += `
            <div class="card">
                <b>${w.label}</b><br>
                XP: ${w.xp}/${w.needXP}<br>
                ${mats}

                <button onclick="craft('${w.weapon}')">
                Craft
                </button>

                <div id="timer-${w.weapon}"></div>
            </div>`;
        });
    }
});

function craft(w){
    if(crafting) return;

    crafting = true;

    let timer = document.getElementById("timer-" + w);
    let time = 5;

    let interval = setInterval(() => {
        timer.innerHTML = "⏳ " + time + "s";
        time--;

        if(time < 0){
            clearInterval(interval);

            fetch(`https://${GetParentResourceName()}/craft`, {
                method:"POST",
                body:JSON.stringify({weapon:w})
            });

            timer.innerHTML = "Done";
            crafting = false;
        }

    }, 1000);
}

function closeMenu(){
    document.getElementById("menu").style.display = "none";
    document.getElementById("bg").style.display = "none";

    fetch(`https://${GetParentResourceName()}/close`, {
        method:"POST"
    });
}

document.addEventListener("keydown", function(e){
    if(e.key === "Escape"){
        closeMenu();
    }
});