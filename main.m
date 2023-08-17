% main
%%%
% Press `s` key to open and close the door.
% That's all.
%%%

%%%
% Set Parameters
%%%
width = 200; % Box width
height = 100; % Box height
wallX = 110; % Wall's x-position from the left wall
doorH = 20; % Door height
doorY = 50; % Door's y-position from the floor

lBox = fieldBox(width,height,wallX,doorY,doorH);

loNum = 30; % Low-speed particles' num
hiNum = 30; % High-speed particles' num
speedLo = 20; % Low-speed particles' speed
speedHi = 40; % High-speed particles' speed

lParticle = particles(loNum,hiNum,speedLo,speedHi,lBox);

%%%
% Setup & Run game.
%%%
game = MaxwellDemonGame(lBox,lParticle);
game = game.run();