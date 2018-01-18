clear

dataFold = '~/data/SEA/jp/jpmat/';

files = dirr([dataFold '*.mat']);

% [A, R] = geotiffread('~/data/SEA/jp/jpbathy/crm.tif');
% A(A==-32768) = nan;
% 
% 
% latlim = R.LatitudeLimits;
% dlat = R.CellExtentInLatitude;
% lat = latlim(1)+dlat/2:dlat:latlim(2)-dlat/2;
% lonlim = R.LongitudeLimits;
% dlon = R.CellExtentInLongitude;
% lon = lonlim(1)+dlon/2:dlon:lonlim(2)-dlon/2;
% 
% figure
% contour(lon,lat,A,30)

% % Load and process bathymetry
% bathnc = '~/data/SEA/jp/jpbathy/ETOPO2v2g_f4.nc';
% lon = ncread(bathnc,'x');
% lat = ncread(bathnc,'y');
% z = ncread(bathnc,'z');
% z = z';
% lon1 = -75;
% lon2 = -65;
% lat1 = 35;
% lat2 = 45;
% z = z(findnear(lat,lat1):findnear(lat,lat2),findnear(lon,lon1):findnear(lon,lon2));
% lon = lon(findnear(lon,lon1):findnear(lon,lon2));
% lat = lat(findnear(lat,lat1):findnear(lat,lat2));

% load coastline
coastnc = '~/data/SEA/jp/jpbathy/etopo1.nc';
z = ncread(coastnc,'Band1')';
lon = ncread(coastnc,'lon');
lat = ncread(coastnc,'lat');



figure
cont = [-6000 -4000 -3000 -2000:500:-1000 -500:50:-100 -90:10:0 10];

% plot close up map
lonran = [-72 -70];
latran = [39.5 41.25];
% format the domain to be the right scale
lambda = mean(latran);
dx = sw_dist([lambda lambda],lonran);
dy = sw_dist(latran,lonran([1 1]));
ratio = dx/dy;
subplot(1,2,2), hold on
contourf(lon,lat,z,cont,'linestyle','none')
contour(lon,lat,z,[0 0],'k')
contour(lon,lat,z,[-100 -100],'k')
for i = 1:length(files)
    load([dataFold files(i,:)])
    plot(data.lon,data.lat,'ko')
end
caxis([-3000 0])
axis([lonran latran])
demcmap([min(z(:)) max(z(:))])
% load invgray
% colormap(gray)
set(gca,'plotboxaspectratio',[ratio 1 1])

lonranreg = lonran;
latranreg = latran;



% plot close up map
lonran = [-80 -65];
latran = [32 45];
% format the domain to be the right scale
lambda = mean(latran);
dx = sw_dist([lambda lambda],lonran);
dy = sw_dist(latran,lonran([1 1]));
ratio = dx/dy;
subplot(1,2,1), hold on
contourf(lon,lat,z,cont,'linestyle','none'), hold on
contour(lon,lat,z,[0 0],'k')
caxis([-3000 0])
demcmap([min(z(:)) max(z(:))])
plot(lonranreg([1 1 2 2 1]),latranreg([1 2 2 1 1]),'k')
set(gca,'plotboxaspectratio',[ratio 1 1])

