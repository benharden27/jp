% Read in csv files and export for Mia
clear


fold = '~/data/SEA/jpdata_edit/';

subfolds = dirr([fold 'C*']);

T = [];
PT = [];
S = [];
PD = [];
D = [];
P = [];
DEP = [];
LON = [];
LAT = [];

for i = 1:length(subfolds)

    T = [];
    PT = [];
    S = [];
    P = [];

    
    ID = subfolds(i,:);
    files = dirr([fold ID '/csv/*.csv']);
    ord = 1:size(files,1);
    if ID == 'C187B'
        w = [1 7];
        c = [7 12];
        e = [12 size(files,1)];
    end
    if ID == 'C193A'
        w = [1 9];
        c = [9,12];
        e = [12 size(files,1)];
    end
    if ID == 'C199A'
        w = [1,7];
        c = [7,11];
        e = [12,size(files,1)];
    end
    if ID == 'C205G'
        w = [1,7];
        c = [7,12];
        e = [12,size(files,1)];
        ord = [2,6:17,4,5,3,1];
    end
    if ID == 'C211A'
        ord = [1:12,14,13,15:19];
        ord = ord(end:-1:1);
        w = [1,8];
        c = [8,14];
        e = [14,size(files,1)];
    end
    if ID == 'C218A'
        w = [1,8];
        c = [8,13];
        e = [14,size(files,1)];
        ord = [2 1 3:size(files,1)];
    end
    if ID == 'C223A'
        w = [1,7];
        c = [7,12];
        e = [12,size(files,1)];
    end
    if ID == 'C230A'
        w = [];
        c = [];
        e = [1,size(files,1)];
    end
    if ID == 'C235A'
        w = [1,5];
        c = [5,9];
        e = [9,size(files,1)];
        ord = [1:13,15,14];
    end
    if ID == 'C241A'
        w = [1,9];
        c = [9,12];
        e = [12,size(files,1)];
    end
    if ID == 'C248B'
        w = [1,8];
        c = [8,13];
        e = [13,size(files,1)];
    end
    
    data = importdata([fold ID '/' ID 'lonlat.csv']);
    
%     figure, plot(data.data(:,1),data.data(:,2),'ko')
%     for i = 1:length(data.data(:,1))
%         text(data.data(i,1),data.data(i,2),num2str(i))
%     end
    lon = data.data(ord,1);
    lat = data.data(ord,2);
%     for i = 1:length(data.data(:,1))
%         text(lon(i),lat(i),num2str(i),'color','r')
%     end
    
    dep = importdata([fold ID '/' ID 'dep.csv']);
    dep = dep.data(ord);
    
    for j = 1:size(files,1)
        file = files(j,:);
        while file(end) == ' '
            file = file(1:end-1);
        end
        data = importdata([fold ID '/csv/' file]);
        data.data(data.data==-9999) = nan;
        
        loc = strfind(data.colheaders,'temperature');
        loc = find(not(cellfun('isempty', loc)));
        T = concat(T,data.data(:,loc(1)));
        loc = strfind(data.colheaders,'salinity');
        loc = find(not(cellfun('isempty', loc)));
        S = concat(S,data.data(:,loc(1)));
%         loc = strfind(data.colheaders,'sigmaTheta');
%         loc = find(not(cellfun('isempty', loc)));
%         PD = concat(PD,data.data(:,loc(1)));

%         PT = concat(PT,data.data(:,1));
%         loc = strfind(data.colheaders,'depth');
%         loc = find(not(cellfun('isempty', loc)));
%         D = concat(D,data.data(:,loc(1)));
        loc = strfind(data.colheaders,'pressure');
        loc = find(not(cellfun('isempty', loc)));
        P = concat(P,data.data(:,loc(1)));
        
        
        
        
    end
    
    T = T(:,2:end);
    S = S(:,2:end);
    P = P(:,2:end);
   
    PD = sw_pden(S,T,P,1)-1000;
    D = sw_dpth(P,40);
    
    X = [0 cumsum(sw_dist(lat,lon,'km'))'];
    
    if(~isempty(w) && ~isempty(c))
        Tw = T(:,ord(w(1):w(2)));
        Tc = T(:,ord(c(1):c(2)));
        Sw = S(:,ord(w(1):w(2)));
        Sc = S(:,ord(c(1):c(2)));
        PDw = PD(:,ord(w(1):w(2)));
        PDc = PD(:,ord(c(1):c(2)));
        Xw = X(w(1):w(2));
        Xc = X(c(1):c(2));
        Xc = Xc - Xc(1);
        lonw = lon(w(1):w(2));
        lonc = lon(c(1):c(2));
        latw = lat(w(1):w(2));
        latc = lat(c(1):c(2));

    end
    
    Te = T(:,ord(e(1):e(2)));
    Se = S(:,ord(e(1):e(2)));
    PDe = PD(:,ord(e(1):e(2)));
    Xe = X(e(1):e(2));  
    Xe = Xe(end)-Xe;
    lone = lon(e(1):e(2));
    late = lat(e(1):e(2));
    
    Te = Te(:,size(Te,2):-1:1);
    Se = Se(:,size(Se,2):-1:1);
    PDe = PDe(:,size(PDe,2):-1:1);
    Xe = Xe(length(Xe):-1:1);
    lone = lone(length(lone):-1:1);
    late = late(length(late):-1:1);

%     PTe = PT(:,ord(e(1):e(2)));
%     PTw = PT(:,ord(w(1):w(2)));
%     PTc = PT(:,ord(c(1):c(2)));
%     

    T = T(:,ord);
    S = S(:,ord);
    PD = PD(:,ord);

    P = nanmean(P,2);
    D = nanmean(D,2);
    
    clear data
    data.T = T;
    data.S = S;
    data.PD = PD;
    data.X = X;
    data.P = P;
    data.D = D;
    data.lon = lon;
    data.lat = lat;
    data.Te = Te;
    data.Se = Se;
    data.PDe = PDe;
    data.Xe= Xe;
    data.lone = lone;
    data.late = late;
    
    if(~isempty(w) && ~isempty(c))
        data.Tw = Tw;
        data.Sw = Sw;
        data.PDw = PDw;
        data.Xw = Xw;
        data.lonw = lonw;
        data.latw = latw;
        data.Tc = Tc;
        data.Sc = Sc;
        data.PDc = PDc;
        data.Xc = Xc;
        data.lonc = lonc;
        data.latc = latc;
    end
    
    
    % looking at western portion
    lonl = -71.17;
    latl = [40.9 39.8];
    latvec = latl(1):-0.001:latl(2);
    lonvec = repmat(lonl,1,length(latvec));
    xvec = [0 cumsum(sw_dist(latvec,lonvec,'km'))];

    data.xe = [];
    for j = 1:length(data.late)
        ii = findnear(latvec,data.late(j));
        data.xe(j) = xvec(ii);
        if j == length(data.late) && i == 1
            data.xe(j) = data.xe(j-1)+1;
        end
    end

    if(isfield(data,'lonw'))
        data.xw = [];
        for j = 1:length(data.latw)
            ii = findnear(latvec,data.latw(j));
            data.xw(j) = xvec(ii);
        end
    end
    
    
%     ffpcolor(X,D,T)
% 
%     figure
%     subplot(3,1,1)
%     contourf(Xe,D,Te), caxis([5 20])
%     set(gca,'ylim',[0 200],'ydir','reverse')
%     colorbar
%     if(~isempty(w) && ~isempty(c))
%         subplot(3,1,2)
%         contourf(Xw,D,Tw), caxis([5 20])
%         set(gca,'ylim',[0 200],'ydir','reverse')
%         colorbar
%         subplot(3,1,3)
%         contourf(Xc,D,Tc), caxis([5 20])
%         set(gca,'ylim',[0 200],'ydir','reverse')
%         colorbar
%     end
    save(['~/data/SEA/jpmat/' ID],'data')
%    
   DEP = [DEP dep'];
   LON = [LON lon'];
   LAT = [LAT lat'];
    
end

DEP(DEP<0) = nan;

Xdep = [];
for j = 1:length(LAT)
    ii = findnear(latvec,LAT(j));
    Xdep(j) = xvec(ii);
end
DEP(Xdep>105&Xdep<108) = nan;


[Xdep,ii,jj] = unique(Xdep);
DEPi = DEP(ii);

xst = 0:120;
goodi = ~isnan(DEPi);
DEPi = interp1(Xdep(goodi),DEPi(goodi),xst);
figure, plot(xst,DEPi), hold on
plot(xst,smooth(DEPi,20),'r')

dd.xst = xst;
dd.dep = smooth(DEPi,20);
save(['~/data/SEA/jpbathy/bathy'],'dd')
