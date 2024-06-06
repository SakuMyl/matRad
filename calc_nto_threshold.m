function f = calc_nto_threshold(f_0, f_inf, x_start, k, x)
    if x < x_start
        f = f_0;
    else
        f = f_0 * exp(-k * (x - x_start)) + f_inf * (1 - exp(-k * (x - x_start)));
    end
end