close all;
clear all;

%% Change this to look at other datasets
load testdata1;

%% Constants
LINELENGTH = 10;

%% Creates a figure handle for the plotting
figurehandle = figure(1);

%% Plot the stuff on the left
subplot(2,2,1); plot(VarName4)
subplot(2,2,3); plot(VarName18)

%% Request a start point from the user
defaultstart = {num2str(find(VarName4 > 1000, 1 ) - 2*LINELENGTH )};
answer = inputdlg('Enter start point','Start point',1,defaultstart);
STARTPOINT = str2double(answer{1});
if STARTPOINT <=0
    STARTPOINT = LINELENGTH+1;
end

%% Request an end point from the user
defaultend = {num2str(find(VarName4 > 1000, 1, 'last' ) + 2*LINELENGTH )};
answer = inputdlg('Enter end point','End point',1,defaultend);
ENDPOINT = str2double(answer{1});

%% Update left hand plot axes 
subplot(2,2,1); axis([STARTPOINT ENDPOINT 0 max(VarName4)*1.2]); grid minor;
rpmline = line([STARTPOINT,STARTPOINT],[0,max(VarName4)*1.2],'Color','k');

subplot(2,2,3); 
hold on;
afrstoichline = line([0,ENDPOINT],[14.7,14.7],'Color','r');
afrline = line([STARTPOINT,STARTPOINT],[10,20],'Color','k');
hold off;
axis([STARTPOINT ENDPOINT 10 20]); grid minor;

%% Set up the plotting to update the fuel map plot
subplot(1,2,2);
xd = VarName4(STARTPOINT-LINELENGTH:STARTPOINT);
yd = VarName16(STARTPOINT-LINELENGTH:STARTPOINT);
maplinehandle = plot(xd,yd); axis([0 13000 0 100]); grid minor
hold on; mapdothandle = plot(xd(end),yd(end),'r+');
mapax = gca;
set(maplinehandle,'xdata',xd,'ydata',yd)
    
%% The main plotting loop
loopindex = STARTPOINT;
while loopindex < ENDPOINT
    loopindex = loopindex +1;
    
    % Update the fuel mapping plot
    xd = VarName4(loopindex-LINELENGTH:loopindex);
    yd = VarName16(loopindex-LINELENGTH:loopindex);
    set(maplinehandle,'xdata',xd,'ydata',yd)
    set(mapdothandle,'xdata',xd(end),'ydata',yd(end))
    
    
    % This draws the lines on the plots on the left
    set(rpmline,'xdata',[loopindex,loopindex])
    set(afrline,'xdata',[loopindex,loopindex])
    
    drawnow
    pause(0.02)

     % This lets you pause the program and set a new point by hitting space
     % then clicking on the left mouse to select a new point. Right mouse
     % button continues from where you are
     isKeyPressed = ' ' == get(figurehandle,'CurrentCharacter');
     if isKeyPressed
         set(gcf,'currentch',char(1)) 
         while 1
            [newx,~, button] = ginput(1);
            if button == 2
                break
            end
            if gca ~= mapax
                loopindex = round(newx);
                break;
            end
        end
     end

end