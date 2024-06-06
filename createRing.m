function obj = createRing(mask, distance, width, resolution)
    larger = dilateMask(mask, distance + width, resolution);
    smaller = dilateMask(mask, distance, resolution);
    obj = larger & not(smaller);
end

function obj=dilateMask(obj, margin, resolution)
    se=strel("cuboid",fix([margin / resolution.y, margin / resolution.x, margin / resolution.z]) + 1);
    obj = imdilate(obj, se);
end