%%%
% GetMouseTransientTouchscreenDemo
%
% Gilles Rautureau
% gilles DOT rautureau AT icm-institute DOT org
%%%

% Sample file to show usage of GetMouseTransient() function
% Need custom version of psychtoolbox
% This add the ability to store very short click or touch which is frequent
% on touchscreen
%
% display rectangle at random positions
% wait for user touch or click
%  if click is inside, the rectangle become green
%  if outside, red
% reaction time using both left click (M) and touch (T) are displayed
%
% while the green or red rectangle is displayed, user can exit the loop by
% pressing any key on keyboard

% October 2017  first
% June 2018     Some edit
% October 2020  Display both reaction time

useStandard = 0; % if 1, use standard GetMouse

fprintf('\nAppuyer sur une touche du clavier entre les essais pour sortir\n');
fprintf('\nPress a key between trials to exit\n');
WaitSecs(2);

%if psychtoolbox have synctrouble try this :
Screen('Preference','SyncTestSettings', 0.004, 50, 0.1, 5); %allow Screen('OpenWindow',..) to be more tolerent with performance refresh test and avoid VBL trouble Warning/Error
                                                            %values can be tweeked (maxStddev, minSamples,maxDeviation, maxDuration)
%Screen('Preference','SkipSyncTests', 1); %if above line does not help for sync trouble, uncomment this line to disable sync test

%open screen
%full screen
[windowPtr,windowRect]=Screen('OpenWindow', 0, [255 255 255]);
%window
%[windowPtr,windowRect]=Screen('OpenWindow',0, [255 255 255], [50, 50, 760, 450]); 

% Get the size of the on screen window in pixels  
% For help see: Screen WindowSize?
[screenXpixels, screenYpixels] = Screen('WindowSize', windowPtr);

%define a small rectangle
baseRect = round(windowRect/15,0);

%calculate min/max position on screen
sizeRect = SizeOfRect(baseRect);
xPosMin = round(windowRect(1)+sizeRect(1)/2,0);
xPosMax = round(windowRect(1)+windowRect(3)-sizeRect(1)/2,0);
yPosMin = round(windowRect(2)+sizeRect(2)/2,0);
yPosMax = round(windowRect(2)+windowRect(4)-sizeRect(2)/2,0) ;



exit = 0;
while(exit == 0)
    
    %define position of rectangle
    xPos = randi([xPosMin xPosMax]);
    yPos = randi([yPosMin yPosMax]);

    while 1 %reset clics counters and wait for release all buttons
        if(useStandard)
            [xClick,yClick,buttons] = GetMouse(windowPtr);
        else
            [xClick,yClick,buttons] = GetMouseTransient(windowPtr,1); 
        end
        if  ~any(buttons)
            break;
        end
    end
    
    ShowCursor(0,windowPtr);
    
    %display rectangle
    Screen('FillRect', windowPtr,0); % clear screen
    rect=CenterRectOnPoint(baseRect,xPos,yPos); %create a rect at position xPos,yPos based on baseRect
    Screen('Framerect', windowPtr, [127 127 127], rect, 5 ); %display a small rectangle
    Screen('Flip', windowPtr);
    
    % t0
    start = GetSecs( );
        
    touchResponseTime = realmax;
    mouseResponseTime = realmax;
    
    while (1)
        %get current status of mouse and touchscreen
        if(useStandard)
            [xClick,yClick,buttons] = GetMouse(windowPtr);
        else
            [xClick,yClick,buttons] = GetMouseTransient(windowPtr,1); %
        end
        timenow = GetSecs();
        if buttons(1) %check left mouse button.
            mouseResponseTime = timenow;
        end
        if (~useStandard) && buttons(4) %check touch. 
            touchResponseTime = timenow;
        end
        
        if mouseResponseTime - start < 5 
            if useStandard || touchResponseTime - start < 5 %got both responses
                break;
            end
        end
        
        if timenow > mouseResponseTime + 0.5 || ( (~useStandard) && timenow > touchResponseTime + 0.5) %second response take too much time
            break
        end
        
        % 5 seconds timeout
        if (timenow - start) > 5
            fprintf('timeOut\n');
            break
        end
    end
    
    %substract t0 and convert to ms
    if (~useStandard) && touchResponseTime - start < 5
        touchResponseTime = round((touchResponseTime - start)*1000);
    else
        touchResponseTime = NaN;
    end
    if mouseResponseTime - start < 5
        mouseResponseTime = round((mouseResponseTime - start)*1000);
    else
        mouseResponseTime = NaN;
    end
    
    %result
    % display the rectangle in green color if click inside. red otherwise
    
    HideCursor(windowPtr);
    
    %red by default
    color = [255 0 0];
    %green if click before timeout and position inside rectangle
    if (touchResponseTime < 5000 || mouseResponseTime < 5000) && IsInRect(xClick, yClick, rect) 
        color = [0 255 0];
    end
    Screen('FillRect', windowPtr,0); % clear screen
    Screen('Framerect', windowPtr, color, rect, 5 ); %display rectangle with result color
    
    %display reaction time
    if useStandard
        rTstring = [sprintf('\nM: %dms', mouseResponseTime)];
    else
        rTstring = [sprintf('T: %dms\nM: %dms', touchResponseTime, mouseResponseTime)];
    end
    DrawFormattedText(windowPtr, rTstring, 'center', 'center', color, [], [], [], [], [], rect);
    Screen('Flip', windowPtr);
    
    %check keyboard to exit
    delay = 1.5 + (randi([0 10]))/10;
    start = GetSecs();
    while(GetSecs()<start+delay)
        WaitSecs(.05);
        [ keyIsDown, ~, ~ ] = KbCheck;
        if keyIsDown
            exit = 1;
            break;
        end
    end
    
end
ShowCursor(0,windowPtr);
Screen('CloseAll');
