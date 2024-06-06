function [Serie,R,inf,Tr]=readDCMRTDoseFromFile(DICOMFile)

inf=dicominfo(DICOMFile,"UseDictionaryVR",true,"UseVRHeuristic",false);
img=dicomread(inf);

Serie=double(squeeze(img)).*inf.DoseGridScaling;
iop=inf.ImageOrientationPatient';
ps=inf.PixelSpacing;
ipp=inf.ImagePositionPatient';
ipp(3)=ipp(3)+inf.GridFrameOffsetVector(1);
ipp(2,:)=ipp;
ipp(2,end)=ipp(2,end)+inf.GridFrameOffsetVector(end);
st=uniquetol(diff(inf.GridFrameOffsetVector),1e-2,"DataScale",1);

% https://nipy.org/nibabel/dicom/dicom_orientation.html#dicom-slice-affine
T=[[iop(1:3)'.*ps(1);0], [iop(4:6)'.*ps(2);0],[(ipp(end,1)-ipp(1,1))/(size(Serie,3)-1);(ipp(end,2)-ipp(1,2))/(size(Serie,3)-1);(ipp(end,3)-ipp(1,3))/(size(Serie,3)-1);0],[ipp(1,:)';1]];
Tr=affinetform3d(T);
IsTransverse=sum(abs(iop)==[1 0 0 0 1 0])==6;
if IsTransverse
    [xd,yd,zd]=transformPointsForward(Tr,[1,size(Serie,2)]-1,[1,size(Serie,1)]-1,[1,size(Serie,3)]-1);
    R=imref3d(size(Serie),xd+[-1,1].*ps(2)/2,yd+[-1,1].*ps(1)/2,zd+[-1,1].*st/2);
else
    R=imref3d(size(Serie),ps(2),ps(1),st);
end