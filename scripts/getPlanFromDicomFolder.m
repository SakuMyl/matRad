function [ct, cst, dose] = getPlanFromDicomFolder(path, prescDose)
    [fileList, patientList] = matRad_scanDicomImportFolder(path);
    res_x = unique(fileList(strcmp(fileList(:,2), 'CT'), 9));
    res_y = unique(fileList(strcmp(fileList(:,2), 'CT'), 10));
    res_z = unique(fileList(strcmp(fileList(:,2), 'CT'), 11));
    resolution.x = str2double(res_x{1});
    resolution.y = str2double(res_y{1});
    resolution.z = str2double(res_z{1});
    ctFiles = fileList(strcmp(fileList(:, 2), 'CT'), :);
    ct = matRad_importDicomCt(ctFiles, resolution, true);
    structureFiles = fileList(strcmp(fileList(:, 2), 'RTSTRUCT'), :);
    structures = matRad_importDicomRtss(structureFiles{1}, ct.dicomInfo);
    for i = 1:numel(structures)
        structures(i).indices = matRad_convRtssContours2Indices(structures(i),ct);
    end
    cst = matRad_createCst(structures, prescDose);
    doseFiles = fileList(strcmp(fileList(:, 2), 'RTDOSE'), :);
    dose = matRad_importDicomRTDose(ct, doseFiles);
end