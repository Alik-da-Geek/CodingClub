var side = innerHeight * 0.836;
var platformHeight = side / 4;
var obsWidth = 30,
    obsHeight = 30,
    pHeight = obsHeight * 2;
var player = {
    x: side / 8,
    y: side - platformHeight - pHeight,
    w: 30,
    h: pHeight,
    velY: 0,
    accY: 0
};
var obstacles = [];
var speed = 7;
var counter = 0,
    score = 0,
    a = (Math.round(Math.random() * 30) + 70);
var alive = true;

function setup() {
    //use createCanvas() instead of size()
    let cnv = createCanvas(side, side);
    cnv.parent("gameCanvas")
    fill("black");
    obstacles.push(new obstacle(side - obsWidth, side - platformHeight - obsHeight, obsWidth, obsHeight));
}

function draw() {
    paint();
    if (alive) {
        moveObstacle();
        player.y += player.velY;
        player.velY += player.accY;
        move();
        spawnObstacle();
        dead();
    } else replay();
}

function moveObstacle() {
    for (var i = 0; i < obstacles.length; i++) {
        obstacles[i].x -= speed;
        if (obstacles[i].x <= 0) {
            obstacles.splice(i, 1);
            score++;
            i--;
        }
    }
}

function spawnObstacle() {
    counter++;
    if (counter % a == 0) {
        if (Math.round(Math.random()) == 0) obstacles.push(new obstacle(side - obsWidth, side - platformHeight - obsHeight * 2, obsWidth + 5, obsHeight));
        else obstacles.push(new obstacle(side - obsWidth, side - platformHeight - obsHeight, obsWidth, obsHeight))
        counter = 0;
        a = (Math.round(Math.random() * 75) + 35)
        speed += 0.2;
    }

}

function dead() {
    for (var i = 0; i < obstacles.length; i++) {
        var difY = Math.abs(obstacles[i].y + obstacles[i].h / 2 - (player.y + player.h / 2));
        var sizeY = (player.h + obstacles[i].h) / 2
        var difX = Math.abs(obstacles[i].x + obstacles[i].w / 2 - (player.x + player.w / 2))
        var sizeX = (player.w + obstacles[i].w) / 2
        if (difY < sizeY && difX < sizeX) {
            speed = 0;
            console.log("alive")
            alive = false;
        }
    }
}

function paint() {
    background(242, 117, 50);
    noStroke();
    textAlign(CENTER, CENTER);
    fill("black");
    textSize(40);
    text(score, width / 2, height / 8);
    stroke("white");
    rect(player.x, player.y, player.w, player.h);
    for (var i = 0; i < obstacles.length; i++) {
        fill("green");
        rect(obstacles[i].x, obstacles[i].y, obstacles[i].w, obstacles[i].h);
    }
    fill("brown")
    rect(0, side - platformHeight, side, platformHeight);
}

function keyPressed() {
    if (player.y >= side - platformHeight - pHeight) {
        if (keyCode == UP_ARROW) {
            player.velY = -12;
            player.accY = 1;
        }
    }
    if (!alive && keyCode == 32) {
        location.reload();
    }
}

function move() {
    if (player.y >= side - platformHeight - pHeight) {
        if (keyIsDown(DOWN_ARROW)) {
            player.h = pHeight / 2;
            player.y += player.h;
        } else if (player.h == pHeight / 2) {
            player.h = pHeight;
            player.y -= pHeight / 2;

        }
    }
    if (player.y > side - platformHeight - player.h) {
        player.y = side - platformHeight - player.h;
        player.accY = 0;
        player.velY = 0;
    }
}

function replay() {
    noStroke();
    textAlign(CENTER, CENTER);
    fill("black");
    textSize(20);
    text("press SPACE to play again", width / 2, 25);
}
