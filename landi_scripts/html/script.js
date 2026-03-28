let crafting = false;

window.addEventListener("message", function(e){
    let d = e.data;

    if(d.type === "open"){
        menu.style.display = "block";
        bg.style.display = "block";
    }

    if(d.type === "data"){
        list.innerHTML = "";

        d.weapons.forEach(w => {

            let locked = !w.unlocked;

            list.innerHTML += `
            <div class="card">
                <b>${w.label}</b><br>

                XP: ${w.xp} / ${w.needXP}<br>

                <button id="btn-${w.weapon}"
                ${locked ? "disabled" : ""}
                onclick="craft('${w.weapon}')">

                ${locked ? "🔒 Locked" : "Craft"}

                </button>

                <div id="timer-${w.weapon}" style="color:orange;"></div>
            </div>`;
        });
    }
});

function craft(w){
    if(crafting) return;

    crafting = true;

    let btn = document.getElementById("btn-" + w);
    let timer = document.getElementById("timer-" + w);

    let time = 5;

    btn.disabled = true;

    let interval = setInterval(() => {
        timer.innerHTML = "⏳ " + time + "s";
        time--;

        if(time < 0){
            clearInterval(interval);

            fetch(`https://${GetParentResourceName()}/craft`, {
                method:"POST",
                body:JSON.stringify({weapon:w})
            });

            timer.innerHTML = "✅ Done";
            btn.disabled = false;
            crafting = false;
        }

    }, 1000);
}

function closeMenu(){
    menu.style.display = "none";
    bg.style.display = "none";

    fetch(`https://${GetParentResourceName()}/close`, {
        method:"POST"
    });
}