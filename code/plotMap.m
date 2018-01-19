clear

% set up source directory locations
dataFold = '../data/';
saveFold = '../plots/';

% extract all mat files in directory
files = dirr([dataFold 'jpmat/*.mat']);

% load coastline and bathymetry
coastnc = [dataFold 'jpbathy/etopo1.nc'];
z = ncread(coastnc,'Band1')';
lon = ncread(coastnc,'lon');
lat = ncread(coastnc,'lat');

%% Plotting
% Setup plotting parameter

% bathymetry contours
cont = [-10000 -6000 -4000 -3000 -2000:500:-1000 -500:100:-100 -50];

% current locations and colors
sbjeti = [-64.6047   42.5436;
          -65.67     41.95;
          -66.7359   40.7276;
          -68.2      40.28;
          -69.6578   39.9234;
          -71.5828   39.9234;
          -72.27     39.4;
          -73.2672   38.4965];
gsi = [-73.5     36;
       -73   37.0045;
       -68.7206   38.3363;
       -66.1912   38.9578];

% current colors
sbjetcol = [2,56,88]/255;
gscol = [239,101,72]/255;
alph = .5; % transparency of currents

% should figure show current loc dots (0 for final figure)
showDots = 0;

% begin figure
figure

for i = 1:2
    switch i
        case 1
            lonran = [-72 -70];
            latran = [39.5 41.1];
        case 2
            lonranreg = lonran;
            latranreg = latran;
            lonran = [-75.3 -65];
            latran = [37 45];
    end
    
    %set raio for graph
    lambda = mean(latran);
    dx = sw_dist([lambda lambda],lonran);
    dy = sw_dist(latran,lonran([1 1]));
    ratio = dx/dy;
    xscale = sw_dist([lambda lambda],[1 2]);
    yscale = sw_dist([1 2],lonran([1 1]));
    
    % start subplot
    h(i) = subplot(1,2,isodd(i)+1), hold on
    contourf(lon,lat,z,[-1.5 -1.5],'k')
    colormap([1 1 1;0 0 0])
    contour(lon,lat,z,cont,'color',[.5 .5 .5])

    
    if i == 1
        
        % plot major currents
         % shelfbreak jet
         xpred = -71.5:0.1:-64;
         sbjets = spline(sbjeti(:,1),sbjeti(:,2));
         ypred = ppval(sbjets,xpred);
         plot(xpred,ypred,'linewidth',15,'color',[sbjetcol alph]);
         if(showDots)
             plot(sbjeti(:,1),sbjeti(:,2),'k+')
         end
         tht = 25;
         sc = 20;
         fill(xpred(1) - [sc/2*cosd(90-tht) sc*cosd(tht) -sc/2*cosd(90-tht)]/xscale,...
                ypred(1) - [-sc/2*sind(90-tht) sc*sind(tht) sc/2*sind(90-tht)]/yscale,...
                sbjetcol,'facealpha',alph,'linestyle','none') 
         text(-68.4,42.5,'sbJet','fontsize',14,'color',sbjetcol,'fontweight','bold')   
         
         % plot station locations
         for j = 1:length(files)
         	load([dataFold 'jpmat/' files(j,:)])
         	plot(data.lon,data.lat,'ko')
         end 
    else
         % plot region box
         plot(lonranreg([1 1 2 2 1]),latranreg([1 2 2 1 1]),'k')
         
         % plot major currents
         % shelfbreak jet
         xpred = -73:0.1:-64;
         sbjets = spline(sbjeti(:,1),sbjeti(:,2));
         ypred = ppval(sbjets,xpred);
         plot(xpred,ypred,'linewidth',7,'color',[sbjetcol alph]);
         if(showDots)
             plot(sbjeti(:,1),sbjeti(:,2),'k+')
         end
         tht = 50;
         sc = 42;
         fill(xpred(1) - [sc/2*cosd(90-tht) sc*cosd(tht) -sc/2*cosd(90-tht)]/xscale,...
                ypred(1) - [-sc/2*sind(90-tht) sc*sind(tht) sc/2*sind(90-tht)]/yscale,...
                sbjetcol,'facealpha',alph,'linestyle','none') 
         text(-68,42.5,'sbJet','fontsize',14,'color',sbjetcol,'fontweight','bold')   

         % Gulf Stream    
         xpred = -66:-0.1:-73;
         gss = spline(gsi(:,1),gsi(:,2));
         ypred = ppval(gss,xpred);
         plot(xpred,ypred,'linewidth',12,'color',[gscol alph]);
         if(showDots)
             plot(gsi(:,1),gsi(:,2),'k+')
         end
         tht = 180+57;
         sc = 60;
         fill(xpred(1) - [sc/2*cosd(90-tht) sc*cosd(tht) -sc/2*cosd(90-tht)]/xscale,...
                ypred(1) - [-sc/2*sind(90-tht) sc*sind(tht) sc/2*sind(90-tht)]/yscale,...
                gscol,'facealpha',alph,'linestyle','none') 
         text(-66.5,38,'GS','fontsize',14,'color',gscol,'fontweight','bold')   

                 
    end
    
    pause(0.1)
    % change the labels to deg W and N
    h(i).XTickLabel
    get(h(i),'yticklabel')
    
% Complete axis bounds
    axis([lonran latran])
    set(gca,'plotboxaspectratio',[ratio 1 1],'box','on')
end

for i = 1:2
    Nlabs = [char(get(h(i),'yticklabel')) repmat('^oN',[length(get(h(i),'yticklabel')) 1])];
    absW = num2str(abs(str2num(char(h(i).XTickLabels))));
    Wlabs = [absW repmat('^oW',[length(get(h(i),'xticklabel')) 1])];
    set(h(i),'xticklabels',Wlabs,'yticklabels',Nlabs)
end
print_fig('mapFig',saveFold,1,0.3)
