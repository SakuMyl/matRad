function [x,y,z,dose] = read_PinnacleDose(file)
% READ_PINDOSE.
% [x,y,z,matrix]=read_Pindose(file). Reads exported from Pinnacle. 
% x, y, z = coordinate vectors.
% dose = dose matrix.

[folder, baseFileNameNoExt, ~] = fileparts(file);
pathAndFileNoExt = fullfile(folder, baseFileNameNoExt);
img = dir(file);
header = dir([pathAndFileNoExt,'.header']);
if (isempty(img) || isempty(header))        %Checks if files exist.
    error('Files not found')
end

fidh=fopen(header.name);        %Open header file.

if(fidh<0)
    error(['Error opening ',header.name]);
end

txt=textscan(fidh,'%s','Delimiter','\n');
txt=txt{1};
tag={'x_pixdim','y_pixdim','z_pixdim','x_dim','y_dim','z_dim','x_start','y_start','z_start'};
tagtype={'f','f','f','f','f','f','f','f','f'};
for ii=1:numel(tag)
    tf=strncmp(tag{ii},txt,numel(tag{ii}));
    tf=find(tf==1);        
    if ~isempty(tf)
                tf=tf(1);
                temp=textscan(txt{tf},['%s%' tagtype{ii}],'delimiter','=');
                if char(tagtype{ii})=='s'
                    s=[char(tag{ii}) '=''' char(temp{2}) ''';'];
                else
                   s=[char(tag{ii}) '=' num2str(temp{2}) ';'];
                end
                eval(s);
    else
                s=[char(tag{ii}) '=' num2str(0) ';'];
                eval(s);
    end
end
fclose(fidh);

matsize=[x_dim,y_dim,z_dim];
voxsize=[x_pixdim,y_pixdim,z_pixdim];
origin=[x_start,y_start,z_start];

%fidi=fopen(img.name);                   %Open image file.
fidi=fopen(img.name,'r','l');
if(fidi<0)
    error(['Error opening ',header.name])
end

dose(x_dim,y_dim,z_dim)=single(0);

for i=1:z_dim
    dose(:,:,i)=fread(fidi,[x_dim y_dim],'single');     %Read doses.
end

x=origin(1):voxsize(1):origin(1)+voxsize(1)*(matsize(1)-1);
y=origin(2):voxsize(2):origin(2)+voxsize(2)*(matsize(2)-1);
z=origin(3):voxsize(3):origin(3)+voxsize(3)*(matsize(3)-1);

%Pinnacle coordinate system is negative defined.
y=y(matsize(2):-1:1);

fclose(fidi);
