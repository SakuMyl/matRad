function metrics = calc_metrics(cst, dose, ptvMask, doseMask, prescDose, OARs)
   metrics.hi = calcHi(dose, ptvMask);
   metrics.ci95 = calcCi(dose, doseMask, ptvMask, PrescDose, 0.95);
   metrics.ci50 = calcCi(dose, doseMask, ptvMask, PrescDose, 0.5);
   [means, maxima] = calcOARMetrics(cst, dose, OARs);
   metrics.means = means;
   metrics.maxima = maxima;
end