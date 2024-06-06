function ci = calcCi(dose, doseMask, ptvMask, prescribedDose, ref)
    vPtv = size(ptvMask, 1);
    ptvDose = dose(ptvMask);
    bodyDose = dose(doseMask);
    vPtvRef = sum(ptvDose >= ref * prescribedDose, 'all');
    vRef = sum(bodyDose >= ref * prescribedDose, 'all');

    if vPtvRef == 0
        ci = 0;
    else
        ci = vPtvRef ^ 2 / (vPtv * vRef);
    end
end