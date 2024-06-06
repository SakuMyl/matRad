function k = calc_k(f_0, f_inf, x_start, ref_distance, ref_dose)
    k = (log(f_0 - f_inf) - log(ref_dose - f_inf)) / (ref_distance - x_start);
end