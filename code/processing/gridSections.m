clear

load '~/data/SEA/jp/jpbathy/bathy';
ddd = dd;

fold = '~/data/SEA/jp/jpmat/';
files = dirr([fold '*.mat']);

plotfold = "~/Documents/SEA/jp/plots/processing/gridding/";

% figure(100),clf

% depth
dd = 5;
mind = 0;
maxd = 300;
dvec = mind:dd:maxd;

% distance
dx = 5;
minx = 0;
maxx = 125;
xvec = minx:dx:maxx;

[X,D] = meshgrid(xvec,dvec);

tension = 5;
search = 10;
grd_command = [ '-R' num2str(minx) '/' num2str(maxx) ...
    '/' num2str(mind) '/' num2str(maxd) ...
    ' -I' num2str(dx) '/' num2str(dd) ...
    ' -T' num2str(tension) ...
    ' -S' num2str(search) ...
    ' -Mmaskjp.dat'...
    ];
smo_command = '-ENaN';    

%%
    
for i = 1:length(files)
    load([fold files(i,:)])

    [xall, dall] = meshgrid(data.xe,data.D);
    
    T_xyz = [xall(:) dall(:) data.Te(:)];
    goodi = ~isnan(data.Te(:));
    T_xyz = T_xyz(goodi,:);
    
    S_xyz = [xall(:) dall(:) data.Se(:)];
    goodi = ~isnan(data.Se(:));
    S_xyz = S_xyz(goodi,:);
    
    PD_xyz = [xall(:) dall(:) data.PDe(:)];
    goodi = ~isnan(data.PDe(:));
    PD_xyz = PD_xyz(goodi,:);
    
    
    % calculate bounding box
    xst = 5;
    x1 = min(data.xe);
    x2 = max(data.xe);
    xall = sort(data.xe);
    clear dm
    for j = 1:length(data.xe);
        dm(j) = find(~isnan(data.Te(:,j)),1,'last');
    end
    dm = dm;
    xe = data.xe;
    bbx = [x1-xst xe x2+xst x2+xst xe(end:-1:1) x1-xst x1-xst]';
    bbz = [zeros(1,length(data.xe)+2) dm(end) dm(end:-1:1) dm(1) 0]';
    
    bb = [bbx bbz];
    initdir = pwd;
    savedir = '~/documents/MATLAB';
    cd(savedir)
    save mask_jp.dat bb -ascii
    ! cat outside.dat mask_jp.dat > maskjp.dat
    cd(initdir)

    % DEPTH SPACE GRIDDING
    Tint = ppzinit(T_xyz,grd_command); % grid T in depth space
    Sint = ppzinit(S_xyz,grd_command);
    PDint = ppzinit(PD_xyz,grd_command);
    
    figure, hold on
    
    % plot temp
    subplot(3,2,1), hold on
    contourf(data.xe,data.D,data.Te,0:30)
    plot(bbx,bbz,'k')
    for n = 1:length(data.xe)
        plot(data.xe([n n]),[0 300],'k')
    end
    caxis([5 20])
    set(gca,'xlim',[0 150],'ylim',[0 400],'ydir','reverse')
    subplot(3,2,2), hold on
    contourf(xvec,dvec,Tint,0:30)
    plot(bbx,bbz,'k')
    caxis([5 20])
    set(gca,'xlim',[0 150],'ylim',[0 400],'ydir','reverse')
    plot(ddd.xst,ddd.dep,'k')
     % plot sal
    subplot(3,2,3), hold on
    contourf(data.xe,data.D,data.Se)
    plot(bbx,bbz,'k')
    for n = 1:length(data.xe)
        plot(data.xe([n n]),[0 300],'k')
    end
%     caxis([5 20])
    set(gca,'xlim',[0 150],'ylim',[0 400],'ydir','reverse')
    subplot(3,2,4), hold on
    contourf(xvec,dvec,Sint)
    plot(bbx,bbz,'k')
%     caxis([5 20])
    set(gca,'xlim',[0 150],'ylim',[0 400],'ydir','reverse')
    
     % plot density
    subplot(3,2,5), hold on
    contourf(data.xe,data.D,data.PDe)
    plot(bbx,bbz,'k')
    for n = 1:length(data.xe)
        plot(data.xe([n n]),[0 300],'k')
    end
%     caxis([5 20])
    set(gca,'xlim',[0 150],'ylim',[0 400],'ydir','reverse')
    subplot(3,2,6), hold on
    contourf(xvec,dvec,PDint)
    plot(bbx,bbz,'k')
%     caxis([5 20])
    set(gca,'xlim',[0 150],'ylim',[0 400],'ydir','reverse')
    
    outname = char(strjoin([strrep(files(i,:),".mat","") '_e'],''));
    print_fig(outname,char(plotfold),1,.7)
    
%     figure
%     plot(data.lon,data.lat,'ko')
%     axis([-72 -70 39 41])

%     figure(100), hold on
%     plot(data.lone,data.late,'ko')
    
%     pause

    Tall_e(i,:,:) = Tint;
    Sall_e(i,:,:) = Sint;
    PDall_e(i,:,:) = PDint;
end

%% grid section west

for i = 1:length(files)
    load([fold files(i,:)])
    if(~isfield(data,'Tw'))
        continue
    end
    
    [xall, dall] = meshgrid(data.xw,data.D);
    
    T_xyz = [xall(:) dall(:) data.Tw(:)];
    goodi = ~isnan(data.Tw(:));
    T_xyz = T_xyz(goodi,:);
    
    S_xyz = [xall(:) dall(:) data.Sw(:)];
    goodi = ~isnan(data.Sw(:));
    S_xyz = S_xyz(goodi,:);
    
    PD_xyz = [xall(:) dall(:) data.PDw(:)];
    goodi = ~isnan(data.PDw(:));
    PD_xyz = PD_xyz(goodi,:);
    
    
%    calculate bounding box
    xst = 5;
    x1 = min(data.xw);
    x2 = max(data.xw);
    xall = sort(data.xw);
    clear dm
    for j = 1:length(data.xw);
        dm(j) = find(~isnan(data.Tw(:,j)),1,'last');
    end
    dm = dm;
    xw = data.xw;
    bbx = [x1-xst xw x2+xst x2+xst xw(end:-1:1) x1-xst x1-xst]';
    bbz = [zeros(1,length(data.xw)+2) dm(end) dm(end:-1:1) dm(1) 0]';
    
    bb = [bbx bbz];
    initdir = pwd;
    savedir = '~/documents/MATLAB';
    cd(savedir)
    save mask_jp.dat bb -ascii
    ! cat outside.dat mask_jp.dat > maskjp.dat
    cd(initdir)

    % DEPTH SPACE GRIDDING
    Tint = ppzinit(T_xyz,grd_command); % grid T in depth space
    Sint = ppzinit(S_xyz,grd_command);
    PDint = ppzinit(PD_xyz,grd_command);
    
    figure, hold on
    
    % plot temp
    subplot(3,2,1), hold on
    contourf(data.xw,data.D,data.Tw,0:30)
    plot(bbx,bbz,'k')
    for n = 1:length(data.xw)
        plot(data.xw([n n]),[0 300],'k')
    end
    caxis([5 20])
    set(gca,'xlim',[0 150],'ylim',[0 400],'ydir','reverse')
    subplot(3,2,2), hold on
    contourf(xvec,dvec,Tint,0:30)
    plot(bbx,bbz,'k')
    caxis([5 20])
    set(gca,'xlim',[0 150],'ylim',[0 400],'ydir','reverse')
    plot(ddd.xst,ddd.dep,'k')
     % plot sal
    subplot(3,2,3), hold on
    contourf(data.xw,data.D,data.Sw)
    plot(bbx,bbz,'k')
    for n = 1:length(data.xw)
        plot(data.xw([n n]),[0 300],'k')
    end
%     caxis([5 20])
    set(gca,'xlim',[0 150],'ylim',[0 400],'ydir','reverse')
    subplot(3,2,4), hold on
    contourf(xvec,dvec,Sint)
    plot(bbx,bbz,'k')
%     caxis([5 20])
    set(gca,'xlim',[0 150],'ylim',[0 400],'ydir','reverse')
    
     % plot density
    subplot(3,2,5), hold on
    contourf(data.xw,data.D,data.PDw)
    plot(bbx,bbz,'k')
    for n = 1:length(data.xw)
        plot(data.xw([n n]),[0 300],'k')
    end
%     caxis([5 20])
    set(gca,'xlim',[0 150],'ylim',[0 400],'ydir','reverse')
    subplot(3,2,6), hold on
    contourf(xvec,dvec,PDint)
    plot(bbx,bbz,'k')
%     caxis([5 20])
    set(gca,'xlim',[0 150],'ylim',[0 400],'ydir','reverse')
    
    outname = char(strjoin([strrep(files(i,:),".mat","") '_w'],''));
    print_fig(outname,char(plotfold),1,.7)
    
%     figure(100), hold on
%     plot(data.lone,data.late,'ko')
    
%     pause

    

    Tall_w(i,:,:) = Tint;
    Sall_w(i,:,:) = Sint;
    PDall_w(i,:,:) = PDint;
    
    
end
Tall_w(8,:,:) = nan;
Sall_w(8,:,:) = nan;
PDall_w(8,:,:) = nan;

Tall_w(1,:,:) = nan;
Sall_w(1,:,:) = nan;
PDall_w(1,:,:) = nan;




%% mean sections

figure
subplot(3,1,1), hold on
contourf(xvec,dvec,squeeze(nanmean([Tall_w;Tall_e])),'linestyle','none')
set(gca,'ydir','reverse')
fill([ddd.xst ddd.xst(end:-1:1)]',[ddd.dep;repmat(3000,length(ddd.xst),1)],[.5 .5 .5])
axis([0 125 0 300])

subplot(3,1,2), hold on
contourf(xvec,dvec,squeeze(nanmean([Sall_w;Sall_e])),'linestyle','none')
set(gca,'ydir','reverse')
fill([ddd.xst ddd.xst(end:-1:1)]',[ddd.dep;repmat(3000,length(ddd.xst),1)],[.5 .5 .5])
axis([0 125 0 300])

subplot(3,1,3), hold on
contourf(xvec,dvec,squeeze(nanmean([PDall_w;PDall_e])),'linestyle','none')
set(gca,'ydir','reverse')
fill([ddd.xst ddd.xst(end:-1:1)]',[ddd.dep;repmat(3000,length(ddd.xst),1)],[.5 .5 .5])
axis([0 125 0 300])


%% save
dim = size(Tall_w);
dim(1) = dim(1)+2;
Tall = nan(dim);
Sall = nan(dim);
PDall = nan(dim);

for i = 1:size(Tall_w,1)
    Tall(i*2-1,:,:) = Tall_w(i,:,:);
    Tall(i*2,:,:) = Tall_e(i,:,:);
    Sall(i*2-1,:,:) = Sall_w(i,:,:);
    Sall(i*2,:,:) = Sall_e(i,:,:);
    PDall(i*2-1,:,:) = PDall_w(i,:,:);
    PDall(i*2,:,:) = PDall_e(i,:,:); 
end

T = Tall; 
S = Sall;
PD = PDall;
Tw = Tall_w;
Sw = Sall_w;
PDw = PDall_w;
Te = Tall_e;
Se = Sall_e;
PDe = PDall_e;
yr = sort([2003:2013 2003:2013]);
sec = repmat(['w';'e'],length(yr)/2,1);


bx = ddd.xst';
bd = ddd.dep;
bfx = [ddd.xst ddd.xst(end:-1:1)]';
bfd = [ddd.dep;repmat(3000,length(ddd.xst),1)];


save '~/data/SEA/jp/jpgrid/jpgrid' T S PD Tw Sw PDw Te Se PDe xvec dvec yr sec bx bd bfx bfd