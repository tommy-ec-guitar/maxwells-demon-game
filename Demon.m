function [lBox, lParticle] = Demon(lBox,lParticle)
arguments
    lBox (1,1) fieldBox
    lParticle (1,1) particles
end
% デーモンを召喚する

% 扉に向かってくる粒子を抽出
% 粒子の位置
pos = lParticle.position;
% 粒子の速度ベクトル
vel = lParticle.velocity;
% 粒子の速度絶対値
speed = lParticle.speed;

% 扉の起点
doorHinge = [lBox.wallXPos, lBox.doorYPos - lBox.doorHeight/2];
% 扉の起点から終端まで
doorVec = [0, lBox.doorHeight];

%%%
% 粒子の壁上の衝突位置は、時間をtとして
% hitPoint = pos + vel * t = doorHinge + doorVec * s;
% 0 < s < 1
% x座標から
% pos(:,1) + vel(:,1) * t = lBox.wallXPos;
% -> t = (lBox.wallXPos - pos(:,1)) ./ vel(:,1);
% -> s = (pos(:,2) + vel(:,2) * t - doorHinge(:,2)) ./ doorVec(:,2)
%%%
t = (lBox.wallXPos - pos(:,1)) ./ vel(:,1);
s = (pos(:,2) + vel(:,2) .* t - doorHinge(:,2)) ./ doorVec(:,2);

% 0 < s < 1の粒子をフィルタリング
filt = s > 0 & s < 1 & t > 0;

t = t(filt);
pos = pos(filt,:);
speed = speed(filt);

% 一番早く衝突するものを選択
[tmin,it] = min(t);
pos = pos(it,:);
speed = speed(it);
isLoSpeed = speed < lParticle.speed(end);

% 現在の扉の状態
nowDoorOpened = lBox.isOpenDoor;

% ドアを開けるべき粒子かどうか
isNeedToOpen = (isLoSpeed & pos(:,1) > lBox.wallXPos) | (~isLoSpeed & pos(:,1) < lBox.wallXPos);

% 今、ドアが開いていて、ドアを閉めるべきならスイッチする。
if (nowDoorOpened & ~isNeedToOpen) | (~nowDoorOpened & isNeedToOpen)
    lBox.DoorSwitch();
end
end