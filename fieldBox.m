classdef fieldBox < handle
    % Box クラス
    % 箱の状態とパラメータを格納します。
    % 箱と粒子の衝突は粒子クラスでやります。

    properties(SetAccess=private)
        width (1,1) single = 100 % 箱の横サイズ
        height (1,1) single = 100 % 箱の縦サイズ
        wallXPos (1,1) single = 50 % 壁の横位置
        doorYPos (1,1) single = 50 % 扉の縦位置
        doorHeight (1,1) single = 10 % 扉の高さ
        isOpenDoor (1,1) logical = false % 扉が開いているかどうか
    end

    methods(Access=public)
        function obj = fieldBox(width,height,wallXPos,doorYPos,doorHeight)
            % このクラスのインスタンスを作成
            % 現在は箱サイズと扉高さのみの指定
            obj.width = width;
            obj.height = height;
            obj.doorHeight = doorHeight;

            obj.wallXPos = wallXPos;
            obj.doorYPos = doorYPos;
            obj.isOpenDoor = false;

        end

        function DoorSwitch(obj)
            obj.isOpenDoor = ~obj.isOpenDoor;
        end
    end
end