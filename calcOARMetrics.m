function [means, maxima] = calcOARMetrics(cst, dose, OARs)
    means = zeros(size(OARs, 1), 1);
    maxima = zeros(size(OARs, 1), 1);
    for i = 1:size(means, 1)
        oarName = OARs(i);
        cstEntry = strcmp(cst(:, 2), oarName);
        mask = cst{cstEntry, 4}{1};
        means(i) = mean(dose(mask), 'all');
        maxima(i) = quantile(dose(mask), 0.99, 'all');
    end
end