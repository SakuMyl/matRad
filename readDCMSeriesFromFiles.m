function [Serie,R,inf,Tr,SOPInstanceUIDList,spatial]=readDCMSeriesFromFiles(DICOMFiles)

Serie=[];
spatial=[];
jj=1;

for ii=1:numel(DICOMFiles)
    inf=dicominfo(DICOMFiles(ii));
    
    if ~isfield(inf,'RescaleSlope')
        inf.RescaleSlope=1;
    end
    if ~isfield(inf,'RescaleIntercept')
        inf.RescaleIntercept=0;
    end
    img=dicomread(inf);

    if ~isfield(inf,'SeriesDescription')
        inf.SeriesDescription='';
    end    
      if ~isfield(inf,'ImageType')
        inf.ImageType='';
    end   

    if sum(size(img))>0 && ~contains(upper(inf.ImageType),"LOCALIZER")
        Serie(:,:,jj)=double(img).*inf.RescaleSlope+inf.RescaleIntercept;
        in(jj)=inf.InstanceNumber;
        spatial.PatientPositions(jj,:)=inf.ImagePositionPatient;
        spatial.PixelSpacings(jj,:)=inf.PixelSpacing;
        spatial.PatientOrientations(jj,:)=inf.ImageOrientationPatient;
        spatial.RescaleInfo(jj,:)=[inf.RescaleSlope,inf.RescaleIntercept];
        spatial.Filenames(jj)=DICOMFiles(ii);
        SOPInstanceUIDList(ii)=string(inf.SOPInstanceUID);
        jj=jj+1;
    end
end

[~,ix]=sort(spatial.PatientPositions(:,3));
spatial.PatientPositions=spatial.PatientPositions(ix,:);
spatial.PixelSpacings=spatial.PixelSpacings(ix,:);
spatial.PatientOrientations=spatial.PatientOrientations(ix,:);
spatial.RescaleInfo=spatial.RescaleInfo(ix,:);
spatial.Filenames=spatial.Filenames(ix);
SOPInstanceUIDList=SOPInstanceUIDList(ix);
Serie=Serie(:,:,ix);

iop=uniquetol(spatial.PatientOrientations,1e-4,"ByRows",true,"DataScale",1);
ps=unique(spatial.PixelSpacings,"rows");
ipp=spatial.PatientPositions;

st=uniquetol(sqrt(sum(diff(ipp).^2,2)),1e-3,"lowest");

if size(ps,1)>1 || size(iop,1)>1 || numel(st)>1
    error("Error, variable pixel spacing or orientation across slices.");
end

% https://nipy.org/nibabel/dicom/dicom_orientation.html#dicom-slice-affine
T=[[iop(1:3)'.*ps(1);0], [iop(4:6)'.*ps(2);0],[(ipp(end,1)-ipp(1,1))/(size(ipp,1)-1);(ipp(end,2)-ipp(1,2))/(size(ipp,1)-1);(ipp(end,3)-ipp(1,3))/(size(ipp,1)-1);0],[ipp(1,:)';1]];
Tr=affinetform3d(T);
IsTransverse=sum(abs(iop)==[1 0 0 0 1 0])==6;

if IsTransverse
    [xd,yd,zd]=transformPointsForward(Tr,[1,size(Serie,2)]-1,[1,size(Serie,1)]-1,[1,size(Serie,3)]-1);
    R=imref3d(size(Serie),sort(xd+[-1,1].*ps(2)/2),sort(yd+[-1,1].*ps(1)/2),zd+[-1,1].*st/2);
else
    R=imref3d(size(Serie),ps(2),ps(1),st);
end