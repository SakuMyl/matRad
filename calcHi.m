function hi = calcHi(dose, ptvMask)
    ptvDose = dose(ptvMask);
    d2ptv = quantile(ptvDose, 0.98, "all");
    d98ptv = quantile(ptvDose, 0.02, "all");
    d50ptv = quantile(ptvDose, 0.5, "all");
    hi = (d2ptv - d98ptv) / d50ptv;
end