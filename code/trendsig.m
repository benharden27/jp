function [trend,sig] = trendsig(x,y,n)
    trend = polyfit(x,y,1);
    trend = trend(1);
    for i = 1:n
        xi = x(randperm(length(x)));
        yi = y(randperm(length(y)));
        p = polyfit(xi,yi,1);
        pi(i) = p(1);
    end
    sigi = quantile(abs(pi),.95);
    if(abs(trend) > sigi)
        sig = 1;
    else
        sig = 0;
    end
end