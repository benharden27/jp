clear

foldRoot = '~/Documents/SEA/jp/';

% set upi save folder for plots
saveFold = [foldRoot 'plots/'];

% load the gridded data
load ../data/jpgrid/jpgrid.mat

%% Basic Plots of the mean and std

figure
subplot(3,2,1), hold on
contourf(xvec,dvec,squeeze(nanmean(T)),-2:0.5:30,'linestyle','none')
set(gca,'ydir','reverse')
fill(bfx,bfd,[.5 .5 .5])
axis([30 120 0 300])
title('Temperature mean')
colorbar

subplot(3,2,3), hold on
contourf(xvec,dvec,squeeze(nanmean(S)),30:0.2:36,'linestyle','none')
set(gca,'ydir','reverse')
fill(bfx,bfd,[.5 .5 .5])
axis([30 120 0 300])
title('Salinity mean')
colorbar

subplot(3,2,5), hold on
contourf(xvec,dvec,squeeze(nanmean(PD)),20:0.1:30,'linestyle','none')
set(gca,'ydir','reverse')
fill(bfx,bfd,[.5 .5 .5])
axis([30 120 0 300])
title('Density mean')
colorbar

subplot(3,2,2), hold on
contourf(xvec,dvec,squeeze(nanstd(T)),0:0.2:5,'linestyle','none')
set(gca,'ydir','reverse')
fill(bfx,bfd,[.5 .5 .5])
axis([30 120 0 300])
title('Temperature std')
colorbar

subplot(3,2,4), hold on
contourf(xvec,dvec,squeeze(nanstd(S)),0:0.05:1,'linestyle','none')
set(gca,'ydir','reverse')
fill(bfx,bfd,[.5 .5 .5])
axis([30 120 0 300])
title('Salinity std')
colorbar

subplot(3,2,6), hold on
contourf(xvec,dvec,squeeze(nanstd(PD)),0:0.01:.5,'linestyle','none')
set(gca,'ydir','reverse')
fill(bfx,bfd,[.5 .5 .5])
axis([30 120 0 300])
title('Density std')
colorbar

print_fig('meanSections',saveFold,1,1)

%% TS plots
for i = 1:2:size(T,1)
    Td((i+1)/2,:) = [T(i,:) T(i+1,:)];
    Sd((i+1)/2,:) = [S(i,:) S(i+1,:)];
end
figure
plotts(20:0.5:30);
plot(Sd,Td,'k.')
plot(Sd(2,:),Td(2,:),'r.')
plot(Sd(11,:),Td(11,:),'b.')
axis([31 37 4 23])

print_fig('allTS',saveFold,1,1)

%% Example sections
s1 = 1:3;
s2 = 9:11;
Tcax = [4 22];
Scax = [32 35.5];
PDcax = [22 27.3];

figure
subplot(3,2,1), hold on
contourf(xvec,dvec,squeeze(nanmean(Te(s1,:,:),1)),-2:0.5:30,'linestyle','none')
set(gca,'ydir','reverse')
fill(bfx,bfd,[.5 .5 .5])
axis([30 120 0 300])
title('Temperature 2004')
caxis(Tcax)
colorbar

subplot(3,2,3), hold on
contourf(xvec,dvec,squeeze(nanmean(Se(s1,:,:),1)),30:0.2:36,'linestyle','none')
set(gca,'ydir','reverse')
fill(bfx,bfd,[.5 .5 .5])
axis([30 120 0 300])
title('Salinity 2004')
caxis(Scax)
colorbar

subplot(3,2,5), hold on
contourf(xvec,dvec,squeeze(nanmean(PDe(s1,:,:),1)),20:0.1:30,'linestyle','none')
set(gca,'ydir','reverse')
fill(bfx,bfd,[.5 .5 .5])
axis([30 120 0 300])
title('Density 2004')
caxis(PDcax)
colorbar


subplot(3,2,2), hold on
contourf(xvec,dvec,squeeze(nanmean(Te(s2,:,:),1)),-2:0.5:30,'linestyle','none')
set(gca,'ydir','reverse')
fill(bfx,bfd,[.5 .5 .5])
axis([30 120 0 300])
title('Temperature 2013')
caxis([Tcax])
colorbar

subplot(3,2,4), hold on
contourf(xvec,dvec,squeeze(nanmean(Se(s2,:,:),1)),30:0.2:36,'linestyle','none')
set(gca,'ydir','reverse')
fill(bfx,bfd,[.5 .5 .5])
axis([30 120 0 300])
title('Salinity 2013')
caxis(Scax)
colorbar

subplot(3,2,6), hold on
contourf(xvec,dvec,squeeze(nanmean(PDe(s2,:,:),1)),20:0.1:30,'linestyle','none')
set(gca,'ydir','reverse')
fill(bfx,bfd,[.5 .5 .5])
axis([30 120 0 300])
title('Density 2013')
caxis(PDcax)
colorbar

print_fig('exampleSections',saveFold,1,1)

%% Process data for inshore trends
% for the shelf, loop through all sections and extract the innermost
% locations inshore of the 100m isobath
for i = 1:22
    % extract the locations inshore of the 100 m isobath for each section
    Tshelf = squeeze(T(i,:,1:13));
    Sshelf = squeeze(S(i,:,1:13));
    PDshelf = squeeze(PD(i,:,1:13));
    
    % depth average these 
    Tbar(i) = nanmean(Tshelf(:));
    Sbar(i) = nanmean(Sshelf(:));
    PDbar(i) = nanmean(PDshelf(:));
    
    % also create average profile inshore of 100 m for each section
    Tprof(:,i) = nanmean(Tshelf,2);
    Sprof(:,i) = nanmean(Sshelf,2);
    PDprof(:,i) = nanmean(PDshelf,2);
end

% combine profile from E and W sections to create one profile per year
for i = 1:11
    Tprofa(:,i) = nanmean(Tprof(:,[i*2-1 i*2]),2);
    Sprofa(:,i) = nanmean(Sprof(:,[i*2-1 i*2]),2);
    PDprofa(:,i) = nanmean(PDprof(:,[i*2-1 i*2]),2);
end


%% plot the time series of the shelf T, S and density 
% Two points per year
figure

subplot(3,1,1), hold on
plot(yr,Tbar,'k.')
goodi = ~isnan(Tbar);
P = polyfit(yr(goodi),Tbar(goodi),1);
plot([2003 2013],polyval(P,[2003,2013]),'r')
title('Depth mean Temperature inshore of 100 m Isobath') 

subplot(3,1,2), hold on
plot(yr,Sbar,'k.')
goodi = ~isnan(Sbar);
P = polyfit(yr(goodi),Sbar(goodi),1);
plot([2003 2013],polyval(P,[2003,2013]),'r')
title('Depth mean Salinity inshore of 100 m Isobath') 


subplot(3,1,3), hold on
plot(yr,PDbar,'k.')
goodi = ~isnan(PDbar);
P = polyfit(yr(goodi),PDbar(goodi),1);
plot([2003 2013],polyval(P,[2003,2013]),'r')
title('Depth mean Density inshore of 100 m Isobath') 
  
print_fig('shelfDepthMeanTrend',saveFold,1,1)

%% Plot the mean profiles as a time series
figure

subplot(3,1,1)
contourf(unique(yr),dvec,Tprofa)
axis([2003 2013 0 60])
set(gca,'ydir','reverse')
colorbar
title('Mean Temperature profile inshore of 100 m Isobath') 


subplot(3,1,2)
contourf(unique(yr),dvec,Sprofa)
axis([2003 2013 0 60])
set(gca,'ydir','reverse')
colorbar
title('Mean Salinity profile inshore of 100 m Isobath') 

subplot(3,1,3)
contourf(unique(yr),dvec,PDprofa)
axis([2003 2013 0 60])
set(gca,'ydir','reverse')
colorbar
title('Mean Density profile inshore of 100 m Isobath') 

%% Plot property trends for various depths

% choose the depths to plot trends from
deps = [0 20 40 60];
% choose plotting colors
col = {'k','r','b','g'};



figure
subplot(3,1,1), hold on
for i = 1:length(deps)
    depi = findnear(dvec,deps(i));
    h(i) = plot(unique(yr),Tprofa(depi,:),'.','color',col{i});
    P = polyfit(unique(yr),Tprofa(depi,:),1);
    plot([2003 2013],polyval(P,[2003,2013]),col{i})
    legendtext{i} = [num2str(deps(i)) ' m: ' num2str(P(1)) ' degC/yr'];
end
legend(h,legendtext)
title('Temperature trends')

subplot(3,1,2), hold on
for i = 1:length(deps)
    depi = findnear(dvec,deps(i));
    h(i) = plot(unique(yr),Sprofa(depi,:),'.','color',col{i});
    P = polyfit(unique(yr),Sprofa(depi,:),1);
    plot([2003 2013],polyval(P,[2003,2013]),col{i})
    legendtext{i} = [num2str(deps(i)) ' m: ' num2str(P(1)) ' PSU/yr'];
end
legend(h,legendtext)
title('Salinity trends')

subplot(3,1,3), hold on
for i = 1:length(deps)
    depi = findnear(dvec,deps(i));
    h(i) = plot(unique(yr),PDprofa(depi,:),'.','color',col{i});
    P = polyfit(unique(yr),PDprofa(depi,:),1);
    plot([2003 2013],polyval(P,[2003,2013]),col{i})
    legendtext{i} = [num2str(deps(i)) ' m: ' num2str(P(1)) ' kg/m-3/yr'];
end
legend(h,legendtext)
title('Density trends')


print_fig('shelfDepthTrends',saveFold,1,1)

%% plot the property trends as a function of depth

% Calculates the property trends inshore of the 100 m isobath as a function
% of depth
for i = 1:length(dvec)
    P = polyfit(unique(yr),Tprofa(i,:),1);
    gradT(i) = P(1);
    P = polyfit(unique(yr),Sprofa(i,:),1);
    gradS(i) = P(1);
    P = polyfit(unique(yr),PDprofa(i,:),1);
    gradPD(i) = P(1);
end

figure

subplot(1,3,1)
plot(gradT,dvec)
set(gca,'ydir','reverse')
ylim([0 50])
ylabel('Depth (m)')
xlabel('degC/yr')
title('Trend in temperature over time with depth')

subplot(1,3,2)
plot(gradS,dvec)
set(gca,'ydir','reverse')
ylim([0 50])
xlabel('PSU/yr')
title('Trend in salinity over time with depth')


subplot(1,3,3)
plot(gradPD,dvec)
set(gca,'ydir','reverse')
ylim([0 50])
xlabel('kg/m-3/yr')
title('Trend in density over time with depth')

print_fig('TrendsAsDepth',saveFold,1,1)


%% Plot property trends for all locations in section

% Set value for minimum number of data points for any location needed in order to plot the trend 
minN = 9;

% plotsig?
sigFL = 0;

% calculates the trend at every location in section
% sets to nan if number of data points for trend is less than minN
if(sigFL)
    n = 1000;
else
    n = 1;
end

for i = 1:length(xvec)
    i
    for j = 1:length(dvec)
        goodi = ~isnan(T(:,j,i));
        if(length(find(goodi==1))) > minN
%             trend = polyfit(yr(goodi)',T(goodi,j,i),1);
%             Tall(j,i) = trend(1);
            [trend,sig] = trendsig(yr(goodi)',T(goodi,j,i),n);
            Tsig(j,i) = sig;
            Tall(j,i) = trend;
        else
            Tall(j,i) = nan;
        end
        goodi = ~isnan(S(:,j,i));
        if length(find(goodi==1)) > minN
%             P = polyfit(yr(goodi)',S(goodi,j,i),1);
%             Sall(j,i) = P(1);
            [trend,sig] = trendsig(yr(goodi)',S(goodi,j,i),n);
            Ssig(j,i) = sig;
            Sall(j,i) = trend;
        else
            Sall(j,i) = nan;
        end
        goodi = ~isnan(PD(:,j,i));
        if length(find(goodi==1)) > minN
%             P = polyfit(yr(goodi)',PD(goodi,j,i),1);
%             PDall(j,i) = P(1);
            [trend,sig] = trendsig(yr(goodi)',PD(goodi,j,i),n);
            PDsig(j,i) = sig;
            PDall(j,i) = trend;
        else
            PDall(j,i) = nan;
        end
        
    end
end

figure

subplot(3,1,1), hold on
contourf(xvec,dvec,Tall,-1:0.05:1,'linestyle','none')
if(sigFL)
    contour(xvec,dvec,Tsig,[.5 .5],'k')
end
set(gca,'ydir','reverse')
fill(bfx,bfd,[.5 .5 .5])
caxis([-.75 .75])
title('Temperature Trend (degC/yr)')
axis([30 120 0 300])

colorbar

subplot(3,1,2), hold on
contourf(xvec,dvec,Sall,-1:0.01:1,'linestyle','none')
if(sigFL)
    contour(xvec,dvec,Ssig,[.5 .5],'k')
end
set(gca,'ydir','reverse')
fill(bfx,bfd,[.5 .5 .5])
caxis([-.2 .2])
title('Salinity Trend (PSU/yr)')
axis([30 120 0 300])

colorbar

subplot(3,1,3), hold on
contourf(xvec,dvec,PDall,-1:0.01:1,'linestyle','none')
if(sigFL)
    contour(xvec,dvec,PDsig,[.5 .5],'k')
end
set(gca,'ydir','reverse')
fill(bfx,bfd,[.5 .5 .5])
caxis([-.2 .2])
axis([30 120 0 300])

title('Density Trend (kg/m3/yr)')
colorbar

load('cm_midwhite')
colormap(cm_midwhite)

print_fig('trendsAllLocs',saveFold,1,1)


%% Change in density gradient over time
di = find(dvec==70);
for i = 1:size(PD,1)
    nai = find(~isnan(PD(i,di,:)));
    if(~isempty(nai))
        p(i,:) = polyfit(xvec(nai),squeeze(PD(i,di,nai))',1);
    else
        p(i,:) = [nan nan];
    end
end

figure
plot(yr,p(:,1),'k.','markersize',20)

%% cold pool temp
for i = 1:size(T,1)
    Tcp(i) = nanmin(T(i,:));
    if(isnan(Tcp(i)))
        Scp(i) = nan;
        PDcp(i) = nan;
    else
        Scp(i) = S(i,T(i,:)==nanmin(T(i,:)));
        PDcp(i) = PD(i,T(i,:)==nanmin(T(i,:)));

    end
end
figure

subplot(3,1,1), hold on
plot(yr,Tcp,'k.')
goodi = ~isnan(Tcp);
P = polyfit(yr(goodi),Tcp(goodi),1);
plot([2003 2013],polyval(P,[2003,2013]),'r')
title('Cold Pool Temperature') 

subplot(3,1,2), hold on
plot(yr,Scp,'k.')
goodi = ~isnan(Scp);
P = polyfit(yr(goodi),Scp(goodi),1);
plot([2003 2013],polyval(P,[2003,2013]),'r')
title('Cold Pool Salinity') 


subplot(3,1,3), hold on
plot(yr,PDcp,'k.')
goodi = ~isnan(PDcp);
P = polyfit(yr(goodi),PDcp(goodi),1);
plot([2003 2013],polyval(P,[2003,2013]),'r')
title('Cold Pool Density') 
  
print_fig('coldPoolTrend',saveFold,1,1)

%% Cold pool temp more general
Tthr = 10;
Sthr = 34;

for i = 2:size(T,1)
    Ti = squeeze(T(i,:,:));
    Si = squeeze(S(i,:,:));
    PDi = squeeze(PD(i,:,:));
    if(isnan(nanmean(Ti(:))))
        Tcp(i) = nan;
        Scp(i) = nan;
        PDcp(i) = nan;
    end
    loci = Ti<12 & Si <34;
    Scp(i) = nanmean(Si(loci));
    Tcp(i) = nanmean(Ti(loci));
    PDcp(i) = nanmean(PDi(loci));
end
figure

subplot(3,1,1), hold on
plot(yr,Tcp,'k.')
goodi = ~isnan(Tcp);
P = polyfit(yr(goodi),Tcp(goodi),1);
plot([2003 2013],polyval(P,[2003,2013]),'r')
title('Cold Pool Temperature') 

subplot(3,1,2), hold on
plot(yr,Scp,'k.')
goodi = ~isnan(Scp);
P = polyfit(yr(goodi),Scp(goodi),1);
plot([2003 2013],polyval(P,[2003,2013]),'r')
title('Cold Pool Salinity') 


subplot(3,1,3), hold on
plot(yr,PDcp,'k.')
goodi = ~isnan(PDcp);
P = polyfit(yr(goodi),PDcp(goodi),1);
plot([2003 2013],polyval(P,[2003,2013]),'r')
title('Cold Pool Density') 
  

%% Slope water
d1 = find(dvec==100);
d2 = find(dvec==200);

TSL = T(:,d1:d2,:);
SSL = S(:,d1:d2,:);
PDSL = S(:,d1:d2,:);

for i = 1:size(T,1)
    Tsl(i) = nanmin(TSL(i,:));
    if(isnan(Tsl(i)))
        Ssl(i) = nan;
        PDsl(i) = nan;
    else
        Ssl(i) = SSL(i,TSL(i,:)==nanmin(TSL(i,:)));
        PDsl(i) = PDSL(i,TSL(i,:)==nanmin(TSL(i,:)));

    end
end


figure

subplot(3,1,1), hold on
plot(yr,Tsl,'k.')
goodi = ~isnan(Tsl);
P = polyfit(yr(goodi),Tsl(goodi),1);
plot([2003 2013],polyval(P,[2003,2013]),'r')
title('Slope Water Temperature') 

subplot(3,1,2), hold on
plot(yr,Ssl,'k.')
goodi = ~isnan(Ssl);
P = polyfit(yr(goodi),Ssl(goodi),1);
plot([2003 2013],polyval(P,[2003,2013]),'r')
title('Slope Water Salinity') 


subplot(3,1,3), hold on
plot(yr,PDsl,'k.')
goodi = ~isnan(PDsl);
P = polyfit(yr(goodi),PDsl(goodi),1);
plot([2003 2013],polyval(P,[2003,2013]),'r')
title('Slope Water Density') 
  
print_fig('slopeWaterTrend',saveFold,1,1)


%% slope and cold pool on same plot

figure

subplot(3,1,1), hold on
plot(yr,Tcp,'k.')
goodi = ~isnan(Tcp);
P = polyfit(yr(goodi),Tcp(goodi),1);
plot([2003 2013],polyval(P,[2003,2013]),'k')
plot(yr,Tsl,'r.')
goodi = ~isnan(Tsl);
P = polyfit(yr(goodi),Tsl(goodi),1);
plot([2003 2013],polyval(P,[2003,2013]),'r')

title('Temperature (CP = black, Slope = red)') 

subplot(3,1,2), hold on
plot(yr,Scp,'k.')
goodi = ~isnan(Scp);
P = polyfit(yr(goodi),Scp(goodi),1);
plot([2003 2013],polyval(P,[2003,2013]),'k')
plot(yr,Ssl,'r.')
goodi = ~isnan(Ssl);
P = polyfit(yr(goodi),Ssl(goodi),1);
plot([2003 2013],polyval(P,[2003,2013]),'r')

title('Salinity (CP = black, Slope = red)') 


subplot(3,1,3), hold on
plot(yr,PDcp,'k.')
goodi = ~isnan(PDcp);
P = polyfit(yr(goodi),PDcp(goodi),1);
plot([2003 2013],polyval(P,[2003,2013]),'k')
plot(yr,PDsl,'r.')
goodi = ~isnan(PDsl);
P = polyfit(yr(goodi),PDsl(goodi),1);
plot([2003 2013],polyval(P,[2003,2013]),'r')

title('Density (CP = black, Slope = red)') 

print_fig('slopeColdPoolTrend',saveFold,1,1)


%% test trend sig

% %%
% function [trend,sig] = trendsig(x,y,n)
%     trend = polyfit(x,y,1);
%     trend = trend(1);
%     for i = 1:length(n)
%         xi = x(randperm(length(x)));
%         yi = y(randperm(length(x)));
%         p = polyfit(xi,yi,1);
%         pi(i) = p(1);
%     end
%     
%         
% end

