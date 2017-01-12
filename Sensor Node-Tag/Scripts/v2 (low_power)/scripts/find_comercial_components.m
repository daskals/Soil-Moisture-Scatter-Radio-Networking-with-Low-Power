function [ comersial_com ] = find_comercial_components(comp, val)

%res comp=1 cap comp=0
if comp==1
    
% Import the data from excel 
[~, ~, raw] = xlsread('resistors_caps.xlsx','Sheet1','A1:A191');
resistorscaps_res = reshape([raw{:}],size(raw));
clearvars raw;
comersial_com=resistorscaps_res* [1,10 ,100,1000,10000];

               
        tmp=abs(comersial_res-val);
        [id idxs] = min(tmp(:));%index of closest value
        closest = comersial_res(idxs); %closest value
   
         
    
end

else

[~, ~, raw] = xlsread('resistors_caps.xlsx','Sheet1','B1:B23');
resistorscaps_caps = reshape([raw{:}],size(raw));
clearvars raw;
comersial_com=resistorscaps_caps* [1,10 ,100,1000,10000];
         tmp=abs(comersial_res-val);
        [id idxs] = min(tmp(:));%index of closest value
        closest = comersial_res(idxs); %closest value

end

end

