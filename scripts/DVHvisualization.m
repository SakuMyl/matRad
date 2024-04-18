Data=readtable(TempFile{1},"FileType","text","Delimiter",",","NumHeaderLines",3,"ExpectedNumVariables",2);
x=Data.Var1;%dose
y=Data.Var2;%volume

y=y(~isnan(x));
x=x(~isnan(x));

y=flip(cumsum(flip(y)));
RoiVolume=y(1);
y=y./RoiVolume*100; 


x=x(y>0.2);
y=y(y>0.2);