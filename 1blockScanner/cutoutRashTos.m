function [ rashContour ] = cutoutRashTos( im,isTos,isAmudAlef,gemPointsL,gemPointsR,secondbotY,topline,ttopline,botline,mid )
    imcloseCoef = -10;
    leftEdge = 1;
    rightEdge = size(im,2);
    edgeThresh = 3; %numPixels to edge that is considered 'at edge of image'
    
    if isequal(mid,[-1,-1,-1])
        hasmid = false;
    else
        hasmid = true;
    end
    
    midX = mid(2)+mid(1)/2;
    midY = botline(2)+botline(1)/2;
    midBottom = [midX,midY];
    %adjust bottom two points of contour so that you cut off 'hint' word
    gemPointsL(end,2) = midY;
    gemPointsR(end,2) = midY;
    %% RASHI / TOS ON RIGHT
    if (isAmudAlef && ~isTos) || (~isAmudAlef && isTos) %rashi/tos on right
        
        
        if ~hasmid
            midX = leftEdge;
        end
        
        if ~hasmid && isTos %tosfox is slightly on the side and below rashi
            rashContour = [size(im,2),topline(2)+topline(1)/2];
        else %add mid top 2 points
            rashContour = [size(im,2),ttopline(2)+ttopline(1)/2;...
                midX,ttopline(2)+ttopline(1)/2; ...
                midX,topline(2)+topline(1)/2];
        end
        if abs(gemPointsR(end,1) - rightEdge) < edgeThresh %you're at left edge. you're done
            rashContour = [rashContour;gemPointsR(2:end-1,:)];
        else 
            rashContour = [rashContour;gemPointsR(2:end,:)]; %leave out the first one which is the top left corner of daf
            
            %try going right...
            [corn,dim,start,dir] = nextJunctionFinder(im,botline,round(midBottom(1)),1,'r',imcloseCoef);
            
            if abs(corn(2)-rightEdge) < edgeThresh
                rashContour = [rashContour;corn(2)+corn(1)/2,midY];
            else %if no path, try going left...
                [corn,dim,start,dir] = nextJunctionFinder(im,botline,round(midBottom(1)),1,'l',imcloseCoef);
                if abs(corn(2)-leftEdge) < edgeThresh
                    rashContour = [rashContour;corn(2)+corn(1)/2,midY;...
                        corn(2)+corn(1)/2,secondbotY;...
                        rightEdge,secondbotY];
                else %take the middle road
                    [corn,dim,start,dir] = nextJunctionFinder(im,mid,round(midBottom(2)),2,'d',imcloseCoef);
                    
                    rashContour = [rashContour; midBottom;midBottom(1),corn(2)+corn(1)/2];
                    
                    %try to go right
                    [corn2,dim,start2,dir] = nextJunctionFinder(im,corn,start,1,'r',imcloseCoef);
                    if abs(corn2(2)-rightEdge) < edgeThresh
                        rashContour = [rashContour; corn2(2)+corn2(1)/2,corn(2)+corn(1)/2];
                    else
                       %go left and then down and then right
                       rashContour = [rashContour;...
                           leftEdge,corn(2)+corn(1)/2;...
                           leftEdge,secondbotY;...
                           rightEdge,secondbotY];
                    end
                end
            end
        end
        %now you're trying to get to the left edge of im anyway you can
    %% RASHI / TOS ON LEFT
    else %rashi/tos on left
        
        if ~hasmid
            midX = rightEdge;
        end
        
        if ~hasmid && isTos
            rashContour = [1,topline(2)+topline(1)/2];
        else
            rashContour = [1,ttopline(2)+ttopline(1)/2;...
                midX,ttopline(2)+ttopline(1)/2; ...
                midX,topline(2)+topline(1)/2];
        end
        if abs(gemPointsL(end,1) - leftEdge) < edgeThresh %you're at left edge. you're done
            rashContour = [rashContour;gemPointsL(1:end-1,:)];
        else 
            rashContour = [rashContour;gemPointsL];
            
            %try going left...
            [corn,dim,start,dir] = nextJunctionFinder(im,botline,round(midBottom(1)),1,'l',imcloseCoef);
            
            if abs(corn(2)-leftEdge) < edgeThresh
                rashContour = [rashContour;corn(2)+corn(1)/2,midY];
            else %if no path, try going right...
                [corn,dim,start,dir] = nextJunctionFinder(im,botline,round(midBottom(1)),1,'r',imcloseCoef);
                if abs(corn(2)-rightEdge) < edgeThresh
                    rashContour = [rashContour;corn(2)+corn(1)/2,midY;...
                        corn(2)+corn(1)/2,secondbotY;...
                        leftEdge,secondbotY];
                else %take the middle road
                    [corn,dim,start,dir] = nextJunctionFinder(im,mid,round(midBottom(2)),2,'d',imcloseCoef);
                    
                    rashContour = [rashContour; midBottom;midBottom(1),corn(2)+corn(1)/2];
                    
                    %try to go left and right. choose path that gets you
                    %closer to edge
                    [corn2,~,~,~] = nextJunctionFinder(im,corn,start,1,'l',imcloseCoef);
                    [corn3,~,~,~] = nextJunctionFinder(im,corn,start,1,'r',imcloseCoef);
                    if abs(corn2(2)-leftEdge) < abs(corn3(2)-rightEdge) && ~isequal(corn2,[-1,-1,-1])
                        rashContour = [rashContour; corn2(2)+corn2(1)/2,corn(2)+corn(1)/2];
                    else
                       %go right and then down and then left
                       rashContour = [rashContour;...
                           rightEdge,corn(2)+corn(1)/2;...
                           rightEdge,secondbotY;...
                           leftEdge,secondbotY];
                    end
                end 
            end
        end    
    end

end

