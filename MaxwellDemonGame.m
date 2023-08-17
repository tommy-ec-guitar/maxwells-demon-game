classdef MaxwellDemonGame < handle
    %UNTITLED このクラスの概要をここに記述
    %   詳細説明をここに記述

    properties
        lBox
        lParticle
        fig
        doorPlot
        pScatter
        figStatus
        gameStatus
    end

    methods(Access=private)
        function SetFigure(obj)
            obj.fig = figure;
            obj.fig.WindowKeyPressFcn = @obj.figureCallBack;
            obj.fig.CloseRequestFcn = @obj.figureClosed;
            ax = gca(obj.fig);
            rectangle(ax,"Position",[0,0,obj.lBox.width,obj.lBox.height],"LineWidth",2,"EdgeColor","k");
            xlim(ax,[0,obj.lBox.width])
            ylim(ax,[0,obj.lBox.height])
            axis(ax,"equal")
            hold(ax,'on')
            plot(ax,[obj.lBox.wallXPos,obj.lBox.wallXPos],[obj.lBox.height,obj.lBox.doorYPos+obj.lBox.doorHeight/2],...
                "LineWidth",2,"Color","k")
            plot(ax,[obj.lBox.wallXPos,obj.lBox.wallXPos],[0,obj.lBox.doorYPos-obj.lBox.doorHeight/2],...
                "LineWidth",2,"Color","k")
            obj.doorPlot = plot(ax,[obj.lBox.wallXPos,obj.lBox.wallXPos],[obj.lBox.doorYPos-obj.lBox.doorHeight/2,obj.lBox.doorYPos+obj.lBox.doorHeight/2],...
                "LineWidth",2,"Color","r");
            obj.pScatter = scatter(ax,obj.lParticle.position(:,1), obj.lParticle.position(:,2), 20, vecnorm(obj.lParticle.velocity,2,2), "filled");
            colormap(ax,"flag")
            axis off
        end

                function judge(obj)
            loPosJudge = obj.lParticle.position(1:obj.lParticle.loParticleNum,1) < obj.lBox.wallXPos;
            hiPosJudge = obj.lParticle.position(obj.lParticle.loParticleNum+1:obj.lParticle.loParticleNum+obj.lParticle.hiParticleNum,1) < obj.lBox.wallXPos;
            loJudge = nnz(hiPosJudge) == 0 & nnz(loPosJudge) == obj.lParticle.loParticleNum;
            hiJudge = nnz(loPosJudge) == 0 & nnz(hiPosJudge) == obj.lParticle.hiParticleNum;
            obj.gameStatus = and(or(loJudge,hiJudge),~obj.lBox.isOpenDoor);
        end

        function figureCallBack(obj,~,event)
            if event.Character == "s"
                obj.lBox.DoorSwitch();
            end
        end

        function figureClosed(obj,~,~)
            obj.figStatus = false;
            delete(gcf)
        end
    end

    methods
        function obj = MaxwellDemonGame(iBox, iParticle)
            obj.lBox = iBox;
            obj.lParticle = iParticle;
            
            obj.SetFigure();

            obj.figStatus = true;
            obj.gameStatus = false;
        end

        function res = run(obj)
            
            dt = 1/60;

            while obj.figStatus && ~obj.gameStatus
                preTime = cputime;
                obj.doorPlot.Visible = ~obj.lBox.isOpenDoor;
                obj.lParticle.bound(obj.lBox, dt);
                obj.pScatter.XData = obj.lParticle.position(:,1);
                obj.pScatter.YData = obj.lParticle.position(:,2);
                drawnow
                % 判定
                obj.judge();

                % Demon(obj.lBox,obj.lParticle);

                dt = cputime - preTime;
            end
            
            if obj.gameStatus
                ax = gca(obj.fig);
                text(ax,obj.lBox.width/2,obj.lBox.height/2,"CLEAR!! You Are Demon!!","FontSize",30,"Color","r","HorizontalAlignment","center","VerticalAlignment","middle");
            end

            res = true;
        end
    end
end