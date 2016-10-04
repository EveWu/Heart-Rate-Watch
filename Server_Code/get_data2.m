function get_data2( index )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
old_data = csvread('data.dat');
add_data = csvread('data_temp.dat');
%size(old_data)
if index <= 4
    new_data = [old_data add_data];
else
    new_data = [old_data(:,251:1000) add_data];
end
[m,n] = size(new_data);
fp = fopen('data.dat','w+');
for i = 1:4
    fprintf(fp,'%.4f,',new_data(i,1:n-1));
    fprintf(fp,'%.4f\n',new_data(i,n));
end
   fprintf(fp,'%.4f,',new_data(5,1:n-1));
   fprintf(fp,'%.4f',new_data(5,n)); 


end

