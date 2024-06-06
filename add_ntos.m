function cst = add_ntos(cst, resolution, ptvBinaryMask, prescribedDose)
    x_start = 2; % X_start in millimiters
    x_end = 30;
    f_0 = 0.95 * prescribedDose;
    f_inf = 0.25 * prescribedDose;
    ring_width = 3;
    k = calc_k(f_0, f_inf, x_start, 20, 0.5 * prescribedDose);

    for i = 1:ceil((x_end - x_start) / ring_width)
        x = x_start + (i - 1) * ring_width;
        ring = createRing(ptvBinaryMask, x, ring_width, resolution);
        linearIndices = find(ring);
        objective = DoseObjectives.matRad_SquaredOverdosing;
        objective.penalty = 1;
        threshold = calc_nto_threshold(f_0, f_inf, x_start, k, x);
        objective.parameters = {threshold};
        nto = {size(cst, 1), ['NTO', num2str(i)], 'OAR', {linearIndices}, cst{size(cst, 1), 5}, {objective}};
        cst = [cst; nto];
    end