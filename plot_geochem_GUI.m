function plot_geochem_GUI
%  This function sets up the GUI figure window for plot_geochem program.
%   November 09, 2016.
%   Last Modified: November 29, 2016.
%   Written by: Yaray Ku

%% pre-defined variables
global cfileList cdir cCompList nComp rpos R WR_indx R_indx GL_indx csample coast

if ismac
    rfont = 2;  % font scaling value for different screen size (Mac Workstation)
    scatSize = 30.0;  % scatter symbol size (use
    CompMarkerSize = 8.0;  % Comparison plot symbol size
else
    rfont = 0.9;  % font scaling value for different screen size (Windows)
    scatSize = 5.0;  % scatter symbol size (use
    CompMarkerSize = 5.0;  % Comparison plot symbol size
end  % if ismac ...
titleFontSize = floor(5*rfont);  % font size for titles
labelFontSize = floor(4*rfont);  % label font size

csample = {'Whole Rock','Rock','Glass'};  % different samples available
coldef = {'red' 'blue' 'green'};  % default colors
cstype = {'WR','ROCK','GL'};  % different sample types available

fmax = 0.98;  % fraction of data kept, those with values above fmax*100% of
% elements will be discarded
%---------properties for setting up ui and axes objects------

% Figure Window
pScreen = get(0,'ScreenSize');  % get screen size
pwidth = 3*pScreen(3)/4;  % initial width for the figure window
pheight = pwidth/2;  % initial height for the figure window (width:height = 2:1)
% check to make sure the width and height fit in
if (pheight>0.9*pScreen(4))  % if height is more than 90% of the screen
    pheight = 3*pScreen(4)/4;  % set everything based upon height
    pwidth = 2.0*pheight;
end  % if (pheight>0.8*pScreen(4))
pF(1) = (pScreen(3)-pwidth)/2.0;  % position from left to make figure appear
% at the centre of the screen
pF(2) = (pScreen(4)-pheight)/2.0; % position from bottom to make figure
% appear at the centre of the screen
pF(3) = pwidth;
pF(4) = pheight;
% width:height = 2

% File Selection Component (1 text, 1 list)
pFStext = [0.039 0.875 0.04 0.024];  % position of the text (normalized)
pFSlist = [0.039 0.59 0.165 0.284];   % position of the list box (normalized)
parFStext.FontSize = titleFontSize;  % font size for FStext
parFStext.HorizontalAlignment = 'left';  % horizontal alignment for FStext
parFStext.String = 'File';  % string "File"
parFSlist.String = cfileList;  % filelist available (default)
parFSlist.ListboxTop = 1;  % position of file to be on top
parFSlist.FontSize = labelFontSize;  % font size

% Type of Samples (1 panel objects, 3 radial buttons)
pTSpanel = [0.039 0.231 0.165 0.271];  % position of the panel object (normalized)
pTScb1 = [0.17 0.6872 0.639 0.211];  % position of check box 1 (normalized wrt panel)
pTScb2 = [0.17 0.4162 0.639 0.211];   % position of check box 2 (normalized wrt panel)
pTScb3 = [0.17 0.1452 0.639 0.211];  % position of check box 3 (normalized wrt panel)
parTSpanel.Title = 'Sample Type';  % string for title
parTSpanel.FontSize = titleFontSize;  % font size for title
parTScb.FontSize = labelFontSize;  % font size for sample selection
parTScb.Max = 1;        % value when the checkbox is selected
parTScb.Min = 0;        % value when the checkbox is not selected
parTScb.Value = parTScb.Min;        % initial value (set to Min, i.e., not checked)
parTScb.visible = 'on';

% Quit button (1 pushbutton object)
pQ = [0.083 0.058 0.077 0.064];     % position of Quit button (normalized)
parQ.FontSize = titleFontSize;  % font size for string
parQ.String = 'QUIT';  % string for push button

% Data Subset Selection (1 slider object, 1 edit object)
pDSslider = [0.235 0.266 0.024 0.499];  % position of slider (normalized)
pDSedit = [0.23 0.771 0.05 0.04];     % positin of editably text (normalized)
parDSslider.min = 0.05;  % minimum value
parDSslider.max = 1.0;  % maximum value
parDSslider.value = fmax;  % position of the slider
parDSslider.SliderStep = [0.01 0.05];  % slider step
parDSedit.string = parDSslider.value;  % value for editable text
parDSedit.FontSize = labelFontSize;  % font size

% Map Plotting Component (2x(popup menu + axes))
% each axes object (i.e., map) contains 2 objects, one line object
% (coastline) and another scatter group object (plot of sample locations
% with their concentration shown in color)
pM1pop = [0.313 0.857 0.1 0.069];  % position of popup menu for map 1 (normalized)
pM1ax = [0.313 0.534 0.324 0.364];  % position of map for map 1 (normalized)
pM2pop = [0.313 0.402 0.1 0.069]; % position of popup menu for map 2 (normalized)
pM2ax = [0.313 0.08 0.324 0.364];   % position of map for map 2 (normalized)
parMpop.FontSize = labelFontSize;  % font size for popup menu
parMpop.string = {'none'};  % list of items available (default):cell
parMpop.value = 1;  % initial value selected (initial compound)
parM1pop.tag = 'pop1';  % tag for top popup menu
parM2pop.tag = 'pop2';  % tag for bottom popup menu
parMax.xlim = [-180 180];  % x value range for map
parMax.ylim = [-80 80];    % y value range for map
parMax.view = [0 90];  % view angle (2-D view)
parMax.gridlinestyle = 'none';  % no grid lines
parM1ax.tag = 'map1';   % tag for top map
parM2ax.tag = 'map2';   % tag for bottom map
parMaxLine.color = [0.4 0.4 0.4];  % color for coastline
parMaxScat.xdata = [];  % default x value for scatter3 plot
parMaxScat.ydata = [];  % default y value for scatter3 plot
parMaxScat.zdata = [];  % default z value for scatter3 plot
parMaxScat.cdata = parMaxScat.zdata;  % default colour value for scatter3 plot
parMaxScat.sizeData = scatSize;  % default marker size for scatter3 plot

% zoom out button
pz1 = [0.59 0.89 0.052 0.05];
pz2 = [0.59 0.44 0.052 0.05];
pz.FontSize = labelFontSize;
pz.string = 'Zoom out';
pz.visible = 'off';

% Comparison Plot (1 axes object, 3 text objects, 3 push buttons)
% Note: axes object should contain 3 line objects corresponding to three
% types of samples to be plotted
pCax = [0.685 0.237 0.292 0.596];   % position of plot (normalized)
pCtex1 = [0.76 0.132 0.107 0.03]; % position of top text (normalized)
pCtex2 = [0.76 0.095 0.107 0.03]; % position of middle text (normalized)
pCtex3 = [0.76 0.059 0.107 0.03]; % position of bottom text (normalized)
pCpb1 = [0.865 0.131 0.018 0.035];  % position of top push button (normalized)
pCpb2 = [0.865 0.094 0.018 0.035];  % position of middle push button (normalized)
pCpb3 = [0.865 0.058 0.018 0.035];  % position of bottom push button (normalized)
parCtex(1).FontSize = labelFontSize;  % font size for text
parCtex(2).FontSize = labelFontSize;
parCtex(3).FontSize = labelFontSize;
parCtex(1).visible = 'off';  % initially have the texts invisible
parCtex(2).visible = 'off';
parCtex(3).visible = 'off';
parCtex(1).tag = 'Ctex1';
parCtex(2).tag = 'Ctex2';
parCtex(3).tag = 'Ctex3';
[parCpb(1:3).backgroundcolor] = coldef{1:3};  % colors for pushbutton
parCpb(1).visible = 'off';  % initially have the push buttons invisible
parCpb(2).visible = 'off';
parCpb(3).visible = 'off';
parCpb(1).tag = 'Cpb1';
parCpb(2).tag = 'Cpb2';
parCpb(3).tag = 'Cpb3';
parCpb(1).position = pCpb1;
parCpb(2).position = pCpb2;
parCpb(3).position = pCpb3;
[parCtex(1:3).string] = csample{1:3};  % sample labels
parCax_title.FontSize = titleFontSize;  % font size for title
parCax_title.String = [parMpop.string{parMpop.value}, ' against ', ...
    parMpop.string{parMpop.value}];  % title for axes
parCax_xlabel.String = parMpop.string{parMpop.value};  % xlabel string
parCax_xlabel.FontSize = labelFontSize;
parCax_ylabel.String = parMpop.string{parMpop.value};  % ylabel string
parCax_ylabel.FontSize = labelFontSize;
parCaxLine.xdata = [];     % initial x data value
parCaxLine.ydata = [];     % initial y data value
parCaxLine.marker = 'o';
parCaxLine.markerSize = CompMarkerSize;
parCaxLine.linestyle = 'none';
parCaxLine.visible = 'off'; % initial visibility of the line object
parCaxLine_tagString = {'lineWR','lineR','lineGL'};  % tag for three different sample sets
[parCaxLine2(1:3).markerfacecolor] = coldef{1:3};
[parCaxLine2(1:3).markeredgecolor] = coldef{1:3};

% plot/setup objects
% Map Plotting Component (2x(popup menu + axes))
% each axes object (i.e., map) contains 2 objects, one line object
% (coastline) and another scatter group object (plot of sample locations
% with their concentration shown in color)
% open figure window
hf = figure;
set(hf,'Name','plot_geochem','NumberTitle','off','Position',pF);
% file selection component
% "File" text
hbtext = uicontrol(hf,'style','pushbutton');
set(hbtext,'Units','normalized','position',pFStext,parFStext);

% Quit button
hbQ = uicontrol(hf,'style','pushbutton');
set(hbQ,'Units','normalized','position',pQ,parQ);
set(hbQ,'callback',@quit);

% Map Plotting: Top map
M1a = axes('Units','normalized','Position',pM1ax,'ButtonDownFcn',@zoom);
set(M1a,parMax,'Tag',parM1ax.tag)
hcoast1 = line(coast(:,1),coast(:,2),'Parent',M1a);
set(hcoast1,parMaxLine)
hold on
% plot compuond 1
hscatter1 = scatter3([],[],[],5,[],'fill');
set(hscatter1,parMaxScat,'Tag','scatter1')
view(2);
colormap('jet')
caxis auto

% Map Plotting: Bottom map
M2a = axes('Units','normalized','Position',pM2ax,'ButtonDownFcn',@zoom);
set(M2a,parMax,'Tag',parM2ax.tag)
hcoast2 = line(coast(:,1),coast(:,2),'Parent',M2a);
set(hcoast2,parMaxLine)
axis tight
hold on
% plot compuond 2
hscatter2 = scatter3([],[],[],5,[],'fill');
set(hscatter2,parMaxScat,'Tag','scatter2')
view(2);
colormap('jet')
caxis auto

% Comparison Plot (1 axes object, 3 text objects, 3 push buttons)
Ca = axes('Units','normalized','Position',pCax,'Tag','ComparisonAxes');
set(Ca.XLabel,parCax_xlabel)
set(Ca.YLabel,parCax_ylabel)
set(Ca.Title,parCax_title)
fracX_0 = Ca.XLim;
fracY_0 = Ca.YLim;

% set up pairs of text/pushbutton for controlling the colour of different
% sets of symbols
% text
hbtext_top = uicontrol(hf,'style','text');
set(hbtext_top,'Units','normalized','position',pCtex1,parCtex(1));
hbtext_middle = uicontrol(hf,'style','text');
set(hbtext_middle,'Units','normalized','position',pCtex2,parCtex(2));
hbtext_bottom = uicontrol(hf,'style','text');
set(hbtext_bottom,'Units','normalized','position',pCtex3,parCtex(3));

% color bottom
hpbc_top = uicontrol(hf,'style','pushbutton','Units','Normalized');
set(hpbc_top,parCpb(1),'callback',@colorchange)
hpbc_middle = uicontrol(hf,'style','pushbutton','Units','Normalized');
set(hpbc_middle,parCpb(2),'callback',@colorchange)
hpbc_bottom = uicontrol(hf,'style','pushbutton','Units','Normalized');
set(hpbc_bottom,parCpb(3),'callback',@colorchange)

% add 3 line objects
% Note: axes object should contain 3 line objects corresponding to three
% types of samples to be plotted
hlineWR = line(parCaxLine);
set(hlineWR,parCaxLine2(1),'Tag',parCaxLine_tagString{1})
hold on
hlineR = line(parCaxLine);
set(hlineR,parCaxLine2(2),'Tag',parCaxLine_tagString{2})
hlineGL = line(parCaxLine);
set(hlineGL,parCaxLine2(3),'Tag',parCaxLine_tagString{3})

% slide bar
hslider = uicontrol(hf,'style','slider','Units','normalized','position',pDSslider);
set(hslider,parDSslider,'Tag','hslider');
set(hslider,'callback',@frac)

% edit box
hedit = uicontrol(hf,'style','edit','Units','normalized','position',pDSedit);
set(hedit,parDSedit,'Tag','hedit');
set(hedit,'callback',@frac)

% check box
hpanel_cb = uipanel(hf,'Units','normalized','Position',pTSpanel);
set(hpanel_cb,parTSpanel)
hcb_WR = uicontrol(hpanel_cb,'style','checkbox','Units','normalized','Position',pTScb1);
set(hcb_WR,parTScb,'visible','on','String','Whole Rock','Tag','checkWR','callback',@check)
hcb_R = uicontrol(hpanel_cb,'style','checkbox','Units','normalized','Position',pTScb2);
set(hcb_R,parTScb,'visible','on','String','Rock','Tag','checkR','callback',@check)
hcb_GL = uicontrol(hpanel_cb,'style','checkbox','Units','normalized','Position',pTScb3);
set(hcb_GL,parTScb,'visible','on','String','Glass','Tag','checkGL','callback',@check)

% file lists
hlist_text = uicontrol(hf,'style','text','Units','normalized','Position',pFStext);
set(hlist_text,parFStext)
hlist = uicontrol(hf,'style','listbox','Units','normalized','Position',pFSlist,'String',cfileList);
set(hlist,'Tag','fileList','callback',@file);

% popmenu
hpop1 = uicontrol(hf,'style','popupmenu','Units','normalized','Position',pM1pop);
set(hpop1,parM1pop,parMpop,'callback',@compo);
hpop2 = uicontrol(hf,'style','popupmenu','Units','normalized','Position',pM2pop);
set(hpop2,parM2pop,parMpop,'callback',@compo);

% zoom out
hz1 = uicontrol(hf,'style','pushbutton');
set(hz1,'Units','normalized','position',pz1,pz,'Tag','zoomout1','callback',@zoomoutclick);
hz2 = uicontrol(hf,'style','pushbutton');
set(hz2,'Units','normalized','position',pz2,pz,'Tag','zoomout2','callback',@zoomoutclick);

end

% Callback function when click on filename
function file(hObj,eventdata)
global cfileList cdir cCompList nComp rpos R WR_indx R_indx GL_indx csample
hf = gcbf;
hlist = hObj;
nhr = 0;  % number of header lines
ntail = 3;  % number of tail lines

% read file and update the indx of WR ROCK GL
if ~strcmpi('None',cfileList{get(hlist,'Value')})
    cfile = cfileList{get(hlist,'Value')};
    filename = [cdir,'/',cfile];
    cinfo = read_csvGUI(filename,nhr,ntail);
    [cCompList nComp rpos R] = extract_compounds(cinfo);
    WR_indx = find(~cellfun('isempty',strfind(R(:,3),'WR')));
    R_indx = find(~cellfun('isempty',strfind(R(:,3),'ROCK')));
    GL_indx = find(~cellfun('isempty',strfind(R(:,3),'GL')));
else
    cCompList = {'None'};
    R = []; % empty
end

% set up the checkbox
checkWR = findobj(hf,'Tag','checkWR');
checkR = findobj(hf,'Tag','checkR');
checkGL = findobj(hf,'Tag','checkGL');
if ~isempty(WR_indx)
    set(checkWR,'String',[csample{1},' (',num2str(numel(WR_indx)),')'],'visible','on');
else
    set(checkWR,'visible','off')
end
if ~isempty(R_indx)
    set(checkR,'String',[csample{2},' (',num2str(numel(R_indx)),')'],'visible','on');
else
    set(checkR,'visible','off')
end
if ~isempty(GL_indx)
    set(checkGL,'String',[csample{3},' (',num2str(numel(GL_indx)),')'],'visible','on');
else
    set(checkGL,'visible','off')
end

% set up the popupmenu
hpop1 = findobj('Tag','pop1');
hpop2 = findobj('Tag','pop2');
set(hpop1,'Value',1,'String',cCompList);
set(hpop2,'Value',1,'String',cCompList);

% set up the comparison plot
Ca = findobj(hf,'Tag','ComparisonAxes');
set(Ca.Children,'XData',[],'YData',[]);
set(Ca.XLabel,'String',cCompList(get(hpop1,'Value')));
set(Ca.YLabel,'String',cCompList(get(hpop2,'Value')));
set(Ca.Title,'String',[cCompList{get(hpop1,'Value')},' against ',cCompList{get(hpop2,'Value')}])

% set up the scatter plot
scatter1 = findobj('Tag','scatter1');
scatter2 = findobj('Tag','scatter2');
set(scatter1,'XData',[],'YData',[],'ZData',[],'CData',[1 1 1]);
set(scatter2,'XData',[],'YData',[],'ZData',[],'CData',[1 1 1]);

% back to normal size
map1 = findobj(hf,'Tag','map1');
map2 = findobj(hf,'Tag','map2');
set(map1,'XLim',[-180 180],'YLim',[-80 80]);
set(map2,'XLim',[-180 180],'YLim',[-80 80]);

% get zoomout icon off
hz1 = findobj(hf,'Tag','zoomout1');
hz2 = findobj(hf,'Tag','zoomout2');
set(hz1,'visible','off');
set(hz2,'visible','off');
end

% callback functin when changing color
function colorchange(hObj,eventdata)
hf = gcbf;
hpbc = hObj;

if strcmpi(get(hpbc,'Tag'),'Cpb1')
    hline = findobj(hf,'Tag','lineWR');
elseif strcmpi(get(hpbc,'Tag'),'Cpb2')
    hline = findobj(hf,'Tag','lineR');
elseif strcmpi(get(hpbc,'Tag'),'Cpb3')
    hline = findobj(hf,'Tag','lineGL');
end

C = uisetcolor;
set(hpbc,'Backgroundcolor',C);
set(hline,'MarkerFaceColor',C);
set(hline,'MarkerEdgeColor',C);

end

% callback function when choosing fraction of data
function frac(hObj,eventdata)
global  R iposComp WR_indx R_indx GL_indx rpos
hf = gcbf;
hfrac = hObj;

if get(findobj(hf,'Tag','fileList'),'Value') > 1 % for valid file
    
    if strcmpi(get(hfrac,'Tag'),'hslider')
        V = get(hfrac,'value');
        Ob = findobj(hf,'Tag','hedit');
        set(Ob,'string',num2str(V));
    elseif strcmpi(get(hfrac,'Tag'),'hedit')
        V = str2num(get(hfrac,'string'));
        Ob = findobj(hf,'Tag','hslider');
        set(Ob,'value',V);
    end
    
    % sort the data size
    X = str2num(char(R(:,iposComp(1))));
    [x,xindx]= sort(X);
    Valx = find(x>=0);
    XINDX = [Valx(1:floor(length(Valx).*V));(Valx(end)+1:length(xindx))'];
    
    Y = str2num(char(R(:,iposComp(2))));
    [y,yindx]= sort(Y);
    Valy = find(y>=0);
    YINDX = [Valy(1:floor(length(Valy).*V));(Valy(end)+1:length(yindx))'];
    
    % define the range of lat and lon
    map1 = findobj(hf,'Tag','map1');
    Xlim = get(map1,'XLim');
    Ylim = get(map1,'YLim');
    x1 = Xlim(1);
    x2 = Xlim(2);
    y1 = Ylim(1);
    y2 = Ylim(2);
    
    % screen the data
    lat = find(rpos.lat > x1 & rpos.lat < x2);
    lon = find(rpos.lon > y1 & rpos.lon < y2);
    region = intersect(lat,lon);
    zoomWR = intersect(region,WR_indx);
    zoomR = intersect(region,R_indx);
    zoomGL = intersect(region,GL_indx);
    
    % find the comparison plot and update the data using globle variables
    % indx of zoomWR zoomR zoomGL
    hlineWR = findobj('Tag','lineWR');
    hlineR = findobj('Tag','lineR');
    hlineGL = findobj('Tag','lineGL');
    
    % plot the WR data
    X_WR_INDX = intersect(xindx(XINDX),zoomWR);
    Y_WR_INDX = intersect(yindx(YINDX),zoomWR);
    INDXWR = intersect(X_WR_INDX,Y_WR_INDX);
    set(hlineWR,'XData',X(INDXWR),'YData',Y(INDXWR));
    
    % plot the ROCK data
    X_R_INDX = intersect(xindx(XINDX),zoomR);
    Y_R_INDX = intersect(yindx(YINDX),zoomR);
    INDXR = intersect(X_R_INDX,Y_R_INDX);
    set(hlineR,'XData',X(INDXR),'YData',Y(INDXR));
    
    % plot the GL data
    X_GL_INDX = intersect(xindx(XINDX),zoomGL);
    Y_GL_INDX = intersect(yindx(YINDX),zoomGL);
    INDXGL = intersect(X_GL_INDX,Y_GL_INDX);
    set(hlineGL,'XData',X(INDXGL),'YData',Y(INDXGL));
end
end


% callback function when click checkbox
function check(hObj,eventdata)
hf = gcbf;
hcb = hObj;

% define the variable for changing visible
if get(findobj(hf,'Tag','fileList'),'Value') > 1 % only happens for valid file
    if strcmpi(get(hcb,'Tag'),'checkWR')
        hcheck1 = findobj(hf,'Tag','Cpb1');
        hcheck2 = findobj(hf,'Tag','lineWR');
        hcheck3 = findobj(hf,'Tag','Ctex1');
    elseif strcmpi(get(hcb,'Tag'),'checkR')
        hcheck1 = findobj(hf,'Tag','Cpb2');
        hcheck2 = findobj(hf,'Tag','lineR');
        hcheck3 = findobj(hf,'Tag','Ctex2');
    elseif strcmpi(get(hcb,'Tag'),'checkGL')
        hcheck1 = findobj(hf,'Tag','Cpb3');
        hcheck2 = findobj(hf,'Tag','lineGL');
        hcheck3 = findobj(hf,'Tag','Ctex3');
    end
    if get(hcb,'value')
        set(hcheck1,'visible','on')
        set(hcheck2,'visible','on')
        set(hcheck3,'visible','on')
    else
        set(hcheck1,'visible','off')
        set(hcheck2,'visible','off')
        set(hcheck3,'visible','off')
    end
end
end

% callback function when chossing compound
function compo(hObj,eventdata)
global nComp rpos R cCompList parMpop  WR_indx R_indx GL_indx iposComp
hf = gcbf;
hpop = hObj;

% define the range of lat and lon
map1 = findobj(hf,'Tag','map1');
Xlim = get(map1,'XLim');
Ylim = get(map1,'YLim');
x1 = Xlim(1);
x2 = Xlim(2);
y1 = Ylim(1);
y2 = Ylim(2);

% screen the data
lat = find(rpos.lat > x1 & rpos.lat < x2);
lon = find(rpos.lon > y1 & rpos.lon < y2);
region = intersect(lat,lon);
zoomWR = intersect(region,WR_indx);
zoomR = intersect(region,R_indx);
zoomGL = intersect(region,GL_indx);

% find all change objects
scatter1 = findobj('Tag','scatter1');
scatter2 = findobj('Tag','scatter2');
pop1 = findobj('Tag','pop1');
pop2 = findobj('Tag','pop2');
Ca = findobj('Tag','ComparisonAxes');
hlineWR = findobj('Tag','lineWR');
hlineR = findobj('Tag','lineR');
hlineGL = findobj('Tag','lineGL');

if get(findobj(hf,'Tag','fileList'),'Value') > 1 % only  happens for valid file
    if strcmpi(get(hpop,'Tag'),'pop1')
        V = get(pop1,'Value');
        if V>1
            iposComp(1) = nComp(V);  % position of the column containing compound 1
            set(scatter1,'XData',rpos.lon,'YData',rpos.lat,'ZData',str2num(char(R(:,iposComp(1)))),'CData',str2num(char(R(:,iposComp(1)))));
            if get(pop2,'Value')>1 % when having another compound (case: when at zoomin window)
                set(hlineWR,'XData',str2num(char(R(zoomWR,iposComp(1)))),'YData',str2num(char(R(zoomWR,iposComp(2)))));
                set(hlineR,'XData',str2num(char(R(zoomR,iposComp(1)))),'YData',str2num(char(R(zoomR,iposComp(2)))));
                set(hlineGL,'XData',str2num(char(R(zoomGL,iposComp(1)))),'YData',str2num(char(R(zoomGL,iposComp(2)))));
            else % only have one compound/can only change one compound so get unavoidable warning
                set(hlineWR,'XData',str2num(char(R(zoomWR,iposComp(1)))));
                set(hlineR,'XData',str2num(char(R(zoomR,iposComp(1)))));
                set(hlineGL,'XData',str2num(char(R(zoomGL,iposComp(1)))));
            end
        else % none
            set(scatter1,'XData',[],'YData',[]);  % the plotting is seperate, so will have unavoidable warning
            set(hlineWR,'XData',[])
            set(hlineR,'XData',[])
            set(hlineGL,'XData',[])
        end
        set(Ca.XLabel,'String',cCompList{V});
        title = char(get(Ca.Title,'String'));
        indx = strfind(title,'against');
        set(Ca.Title,'String',[cCompList{V},' ', title(indx:end)]);
    elseif strcmpi(get(hpop,'Tag'),'pop2')
                V = get(pop2,'Value');
        if V>1
            iposComp(2) = nComp(V);  % position of the column containing compound 2
            set(scatter2,'XData',rpos.lon,'YData',rpos.lat,'ZData',str2num(char(R(:,iposComp(2)))),'CData',str2num(char(R(:,iposComp(2)))));
            if get(pop1,'Value')>1 % when having another compound (case: when at zoomin window)
                set(hlineWR,'XData',str2num(char(R(zoomWR,iposComp(1)))),'YData',str2num(char(R(zoomWR,iposComp(2)))));
                set(hlineR,'XData',str2num(char(R(zoomR,iposComp(1)))),'YData',str2num(char(R(zoomR,iposComp(2)))));
                set(hlineGL,'XData',str2num(char(R(zoomGL,iposComp(1)))),'YData',str2num(char(R(zoomGL,iposComp(2)))));
            else % only have one compound/can only change one compound so get unavoidable warning
                set(hlineWR,'YData',str2num(char(R(zoomWR,iposComp(2)))));
                set(hlineR,'YData',str2num(char(R(zoomR,iposComp(2)))));
                set(hlineGL,'YData',str2num(char(R(zoomGL,iposComp(2)))));
            end
        else % none
            set(scatter2,'XData',[],'YData',[])
            set(hlineWR,'YData',[])
            set(hlineR,'YData',[])
            set(hlineGL,'YData',[])
        end
        set(Ca.YLabel,'String',cCompList{V});
        title = char(get(Ca.Title,'String'));
        indx = strfind(title,'against');
        set(Ca.Title,'String',[title(1:indx+7),cCompList{V}]); % length of ('against') = 7
    end
end
end

% callback function when zoomin
function zoom(hObj,eventdata)
global R rpos iposComp WR_indx R_indx GL_indx zoomWR zoomR zoomGL
hf = gcbf;
hax = hObj;

% get location
prect = getrect(hax);
x1 = prect(1);
y1 = prect(2);
x2 = prect(1) + prect(3);
y2 = prect(2) + prect(4);

% get axes info
map1 = findobj(hf,'Tag','map1');
map2 = findobj(hf,'Tag','map2');
set(map1,'XLim',[x1 x2],'YLim',[y1 y2]);
set(map2,'XLim',[x1 x2],'YLim',[y1 y2]);

% get zoomout icon
hz1 = findobj(hf,'Tag','zoomout1');
hz2 = findobj(hf,'Tag','zoomout2');
set(hz1,'visible','on');
set(hz2,'visible','on');

% screen the data
lat = find(rpos.lat > x1 & rpos.lat < x2);
lon = find(rpos.lon > y1 & rpos.lon < y2);
region = intersect(lat,lon);
zoomWR = intersect(region,WR_indx);
zoomR = intersect(region,R_indx);
zoomGL = intersect(region,GL_indx);

% update the line data
hlineWR = findobj('Tag','lineWR');
hlineR = findobj('Tag','lineR');
hlineGL = findobj('Tag','lineGL');

set(hlineWR,'XData',str2num(char(R(zoomWR,iposComp(1)))),'YData',str2num(char(R(zoomWR,iposComp(2)))));
set(hlineR,'XData',str2num(char(R(zoomR,iposComp(1)))),'YData',str2num(char(R(zoomR,iposComp(2)))));
set(hlineGL,'XData',str2num(char(R(zoomGL,iposComp(1)))),'YData',str2num(char(R(zoomGL,iposComp(2)))));

end

% callback function when zoomout
function zoomoutclick(hObj,eventdata)
global R iposComp WR_indx R_indx GL_indx
hf = gcbf;
hax = hObj;

% when click set button invisible
hz1 = findobj(hf,'Tag','zoomout1');
hz2 = findobj(hf,'Tag','zoomout2');
set(hz1,'visible','off');
set(hz2,'visible','off');

% when click go back to the original point (reduce using global, so make it hardwritten)
map1 = findobj(hf,'Tag','map1');
map2 = findobj(hf,'Tag','map2');
set(map1,'XLim',[-180 180],'YLim',[-80 80]);
set(map2,'XLim',[-180 180],'YLim',[-80 80]);

% screen the data
hlineWR = findobj('Tag','lineWR');
hlineR = findobj('Tag','lineR');
hlineGL = findobj('Tag','lineGL');

set(hlineWR,'XData',str2num(char(R(WR_indx,iposComp(1)))),'YData',str2num(char(R(WR_indx,iposComp(2)))));
set(hlineR,'XData',str2num(char(R(R_indx,iposComp(1)))),'YData',str2num(char(R(R_indx,iposComp(2)))));
set(hlineGL,'XData',str2num(char(R(GL_indx,iposComp(1)))),'YData',str2num(char(R(GL_indx,iposComp(2)))));
end

%callback funcitn when click quit
function quit(hObj,eventdata)
close all
end

