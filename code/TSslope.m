% plot TS and find slope of mixing line

clear

dataFold = '~/data/SEA/jp/jpmat/';

files = dirr([dataFold '*.mat']);
figure
for i = 1:length(files)
    load([dataFold files(i,:)])
    subplot(4,3,i), hold on
    plot(data.S,data.T,'k.')
    axis([31 36 0 20])
end
    
    
% loc = ginput(22);
% for i = 1:11
%     loc2(i,:) = [loc(i*2-1,:) loc(i*2,:)];
% end
% loc = loc2;
loc = [35.5416   13.0939   32.6565    8.0110;
       35.5171   12.3204   32.9988    5.5801;
       35.6646   14.4199   31.8476    6.9061;
       35.7249   15.5249   32.9254    8.2320;
       35.4315   12.8729   32.9010    5.5801;
       35.5671   13.3149   32.8720    6.5746;
       35.7372   14.0884   33.0599    7.3481;
       35.9572   16.4088   32.7421    8.2320;
       35.7500   14.6409   32.6159    7.5691;
       35.7983   14.7802   32.8521    7.9670;
       35.7249   13.6813   33.1699    8.4066];

Twin = 2;
x = 30:36;
for i = 1:11
   load([dataFold files(i,:)])
   ppT = [loc(i,2)+Twin/2 loc(i,4)+Twin/2 loc(i,4)-Twin/2 loc(i,2)-Twin/2 loc(i,2)+Twin/2];
   ppS = [loc(i,1) loc(i,3) loc(i,3) loc(i,1) loc(i,1)];
   ii = inpolygon(data.S,data.T,ppS,ppT);
   subplot(4,3,i)
   plot(data.S(ii),data.T(ii),'r.')
   plot(ppS,ppT,'r')
   P(i,:) = polyfit(data.S(ii),data.T(ii),1);
   plot(x,polyval(P(i,:),x),'g')
   T36(i) = polyval(P(i,:),36);
   T32(i) = polyval(P(i,:),32);
end

yr = 2003:2013;
figure
subplot(3,1,1)
plot(yr,P(:,1),'k+')
title('Gradient')
subplot(3,1,2)
plot(yr,T32,'k+')
title('Cold Pool')
subplot(3,1,3)
plot(yr,T36,'k+')
title('Slope')

