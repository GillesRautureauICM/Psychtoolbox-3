%%%
% GetMouseTransiantDemo
%
% Gilles Rautureau
% gilles DOT rautureau AT icm-institute DOT org
%%%
% Record number of clic/touch inside Psych window between polling

% polling period (s)
period = 1/60;

% record length (s)
duration = 10;

%if psychtoolbox have synctrouble try this :
Screen('Preference','SyncTestSettings', 0.004, 50, 0.1, 5); %allow Screen('OpenWindow',..) to be more tolerent with performance refresh test and avoid VBL trouble Warning/Error
                                                            %values can be tweeked (maxStddev, minSamples,maxDeviation, maxDuration)
%Screen('Preference','SkipSyncTests', 1); %if above line does not help for sync trouble, uncomment this line to disable sync test

[windowPtr,windowRect]=Screen('OpenWindow',0, [255 255 255], [50, 50, 760, 450]);

startSecs = GetSecs;

timeNow = 0;

data = [];
while timeNow < (startSecs + duration)
    WaitSecs(period);
    timeNow = GetSecs;
    [xClick,yClick,buttons] = GetMouseTransient([],1);
    data = [data; [timeNow - startSecs, xClick, yClick, buttons(1), buttons(2), buttons(3), buttons(4)] ];
end

Screen('CloseAll');

data
