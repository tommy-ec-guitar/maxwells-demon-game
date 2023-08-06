classdef particles < handle
    % 粒子クラス
    % 粒子の状態とパラメータを保管する。

    properties(SetAccess=private)
        velocity (:,2) single
        position (:,2) single
        loParticleNum (1,1) int32
        hiParticleNum (1,1) int32
        speed (:,1) single
    end

    methods
        function obj = particles(hiParticleNum, loParticleNum, speedLo, speedHi, iBox)
            arguments
                hiParticleNum (1,1) int32
                loParticleNum (1,1) int32
                speedLo (1,1) single
                speedHi (1,1) single
                iBox (1,1) fieldBox
            end
            
            obj.loParticleNum = loParticleNum;
            obj.hiParticleNum = hiParticleNum;
            totalNum = hiParticleNum + loParticleNum;

            % 粒子を生成する。
            angLo = rand(obj.loParticleNum,1) * 2 * pi;
            angHi = rand(obj.hiParticleNum,1) * 2 * pi;
            velLo = [cos(angLo), sin(angLo)] .* speedLo;
            velHi = [cos(angHi), sin(angHi)] .* speedHi;
            obj.velocity = [velLo; velHi];
            obj.speed = [zeros(obj.loParticleNum,1) + speedLo;
                zeros(obj.hiParticleNum,1) + speedHi];
            
            % 箱の領域内の点の位置を計算する.箱の左下が原点。
            obj.position = (rand(totalNum,2)*0.99 + 0.005) .* [iBox.width, iBox.height];
        end

        function bound(obj,iBox,dt)
            arguments
                obj (1,1) particles
                iBox (1,1) fieldBox
                dt (1,1) single
            end
            
            % 速度に応じて移動
            diffPos = obj.velocity * dt;
            obj.position = obj.position + diffPos;

            % 右の壁から外に行ったやつを反射
            isRightBound = obj.position(:,1) >= iBox.width;
            obj.position(isRightBound,1) = -obj.position(isRightBound,1) + 2 * iBox.width;

            % 左の壁から外に行ったやつを反射
            isLeftBound = obj.position(:,1) <= 0;
            obj.position(isLeftBound,1) = -obj.position(isLeftBound,1);

            % 上の壁から外に行ったやつを反射
            isRoofBound = obj.position(:,2) >= iBox.height;
            obj.position(isRoofBound,2) = -obj.position(isRoofBound,2) + 2 * iBox.height;

            % 下の壁から外に行ったやつを反射
            isFloorBound = obj.position(:,2) <= 0;
            obj.position(isFloorBound,2) = -obj.position(isFloorBound,2);

            % 真ん中の壁にヒットしたやつ
            xFromWall = obj.position(:,1) - iBox.wallXPos;
            isWallBound = xFromWall .* (xFromWall - diffPos(:,1)) <= 0;
            
            % ドアが開いてたらドア通り抜けるので反射判定をオフる。
            if iBox.isOpenDoor
                % ドアを通り抜けないやつを計算
                posOnTheWall = obj.position(:,2) - diffPos(:,2) .*...
                    ((obj.position(:,1) - iBox.wallXPos) ./ diffPos(:,1));
                isNotThroughDoor = abs(posOnTheWall-iBox.doorYPos) > iBox.doorHeight/2;
                isWallBound = isWallBound & isNotThroughDoor;
            end

            % 壁ヒット反射
            obj.position(isWallBound,1) = -obj.position(isWallBound,1) + 2 * iBox.wallXPos;

            % 水平方向の反射の速度更新
            % 反射方向のせいで永遠にドアに来ない粒子が出ないように、進行方向をずらす。
            isHRef = isRightBound | isLeftBound | isWallBound;
            newVel = obj.velocity(isHRef,:) .* [-1,1];
            newVel = newVel + obj.speed(isHRef) .* (2*single(newVel >= 0)-1) .* rand(size(newVel,1),2);
            newVel = obj.speed(isHRef) .* newVel ./ vecnorm(newVel,2,2);
            obj.velocity(isHRef,:) = newVel;

            % 垂直方向の反射の速度更新
            isVRef = isRoofBound | isFloorBound;
            newVel = obj.velocity(isVRef,:) .* [1,-1];
            newVel = newVel + obj.speed(isVRef) .* (2*single(newVel >= 0)-1) .* rand(size(newVel,1),2);
            newVel = obj.speed(isVRef) .* newVel ./ vecnorm(newVel,2,2);
            obj.velocity(isVRef,:) = newVel;
        end
    end
end