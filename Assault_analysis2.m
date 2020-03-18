close all
%import assault counts and reshape back into 3d array
assault2d = csvread('F:/Rprojects/RaleighCrime/AssaultCounts2.csv', 1,1);
size(assault2d);
assault=zeros(625,7,24);
size(assault);
for i = 1:625;
    for j= 1:7;
        for k=1:24;
            assault(i,j,k) = assault2d(i, j+7*(k-1));
        end
    end
end

%create tensor of assault counts
assault = tensor(assault);

rng('default');
rng(1);
A= cp_apr(assault, 4, 'alg', 'mu', 'init',{'random'});
B= cp_als(assault,4, 'init','random');
ATen= tensor(A);
msz=5

%APR firat tensor components
%space
subplot(4,3,1)
% bar([1:625],A.U{1}(:,1))
space= reshape(A.U{1}(:,1), 25, 25);
%space =space.'
space=rot90(space)
imagesc(space)

%day
subplot(4,3,2)
ylabs= ["Sunday","Monday","Tuesday","Wednesday", "Thursday","Friday","Saturday"];
bar([1:7], A.U{2}(:,1))

%hour
subplot(4,3,3)
xlabs =string(["00:00","01:00","02:00","03:00","04:00","05:00","06:00","07:00","08:00","09:00","10:00","11:00","12:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00","20:00","21:00","22:00","23:00"]);
bar([1:24], A.U{3}(:,1))


%second component
subplot(4,3,4)
%bar([1:625],A.U{1}(:,2))
space2= reshape(A.U{1}(:,2), 25, 25);
space2=rot90(space2)
imagesc(space2)
subplot(4,3,5)
ylabs= ["Sunday","Monday","Tuesday","Wednesday", "Thursday","Friday","Saturday"];
bar([1:7], A.U{2}(:,2))

subplot(4,3,6)
xlabs =string(["00:00","01:00","02:00","03:00","04:00","05:00","06:00","07:00","08:00","09:00","10:00","11:00","12:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00","20:00","21:00","22:00","23:00"]);
bar([1:24], A.U{3}(:,2))

%third component
subplot(4,3,7)
%bar([1:625],A.U{1}(:,3))
space3= reshape(A.U{1}(:,3), 25, 25);
space3=rot90(space3)
imagesc(space3)

subplot(4,3,8)
ylabs= ["Sunday","Monday","Tuesday","Wednesday", "Thursday","Friday","Saturday"];
bar([1:7], A.U{2}(:,3))

subplot(4,3,9)
xlabs =string(["00:00","01:00","02:00","03:00","04:00","05:00","06:00","07:00","08:00","09:00","10:00","11:00","12:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00","20:00","21:00","22:00","23:00"]);
bar([1:24], A.U{3}(:,4))

%fourth component
subplot(4,3,10)
%bar([1:625],A.U{1}(:,4))
space4= reshape(A.U{1}(:,4), 25, 25);
space4=rot90(space4)
imagesc(space4)

subplot(4,3,11)
ylabs= ["Sunday","Monday","Tuesday","Wednesday", "Thursday","Friday","Saturday"];
bar([1:7], A.U{2}(:,4))

subplot(4,3,12)
xlabs =string(["00:00","01:00","02:00","03:00","04:00","05:00","06:00","07:00","08:00","09:00","10:00","11:00","12:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00","20:00","21:00","22:00","23:00"]);
bar([1:24], A.U{3}(:,4))


%%%%%%%
%weighted sum of all space components
lambda=[1.5921,0.7749,0.3740,0.3413]
figure(1)
space=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];

for i=(1:625);
    space(i)= A.U{1}(i,1)*lambda(1)+ A.U{1}(i,2)*lambda(2)+ A.U{1}(i,3)*lambda(3)+ A.U{1}(i,4)*lambda(4);
end
space5= reshape(space, 25, 25);
space5=rot90(space5)
imagesc(space5)
figure(2)

%weighted sum of all day components
day_of_week=[0,0,0,0,0,0,0];
for i=(1:7);
    day_of_week(i)= A.U{2}(i,1)*lambda(1)+ A.U{2}(i,2)*lambda(2)+ A.U{2}(i,3)*lambda(3)+ A.U{2}(i,4)*lambda(4);
end
xlabs= ["Sunday","Monday","Tuesday","Wednesday", "Thursday","Friday","Saturday"];
bar([1:7], day_of_week)
xticklabels(xlabs)
title("Day of the Week vs. Crime Probablility")

figure(3)

%weighted sum of all hour components
time_of_day=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
for i=(1:24);
    time_of_day(i)= A.U{3}(i,1)*lambda(1)+ A.U{3}(i,2)*lambda(2)+ A.U{3}(i,3)*lambda(3)+ A.U{3}(i,4)*lambda(4);
end
bar([0:23], time_of_day)
%xlabs =["00:00","01:00","02:00","03:00","04:00","05:00","06:00","07:00","08:00","09:00","10:00","11:00","12:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00","20:00","21:00","22:00","23:00"];
%xticklabels(xlabs)
title("Time of Day vs. Crime Probablility")

% figure
% subplot(4,3,1)
% plot([1:625],B.U{1}(:,1), 'o')
% 
% subplot(4,3,4)
% plot([1:625],B.U{1}(:,2), 'o')
% 
% subplot(4,3,7)
% plot([1:625],B.U{1}(:,3), 'o')
% 
% subplot(4,3,10)
% plot([1:625],B.U{1}(:,4), 'o')
% figure(2)
% 

%export for further analysis in Rstudio
csvwrite("F://Rprojects/RaleighCrime/25x25 assault model.csv", A.U{1});
