close all
assault2d = csvread('/Users/astaicu/Desktop/RaleighCrime/AssaultCounts.csv', 1,1);
size(assault2d);
assault=zeros(100,7,24);
size(assault);
for i = 1:100;
    for j= 1:7;
        for k=1:24;
            assault(i,j,k) = assault2d(i, j+7*(k-1));
        end
    end
end
 %assault(33,:,:);
assault = tensor(assault);

rng('default');
rng(1);
A= cp_apr(assault, 4, 'alg', 'mu', 'init',{'random'});
B= cp_als(assault,4, 'init','random');
%assaultTen= tensor(assault);
ATen= tensor(A);
% ATen
% plot(assault(:), ATen(:), 'o')
% hold on
% refline(1, 0)
% figure(1)

%APR Space first component
subplot(4,3,1)
plot([1:100],A.U{1}(:,1), 'o')

%APR Space first component

subplot(4,3,2)
ylabs= ["Sunday","Monday","Tuesday","Wednesday", "Thursday","Friday","Saturday"];
plot([1:7], A.U{2}(:,1), 'o')

subplot(4,3,3)
xlabs =string(["00:00","01:00","02:00","03:00","04:00","05:00","06:00","07:00","08:00","09:00","10:00","11:00","12:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00","20:00","21:00","22:00","23:00"]);
plot([1:24], A.U{3}(:,1), 'o')



subplot(4,3,4)
plot([1:100],A.U{1}(:,2), 'o')

subplot(4,3,5)
ylabs= ["Sunday","Monday","Tuesday","Wednesday", "Thursday","Friday","Saturday"];
plot([1:7], A.U{2}(:,2), 'o')

subplot(4,3,6)
xlabs =string(["00:00","01:00","02:00","03:00","04:00","05:00","06:00","07:00","08:00","09:00","10:00","11:00","12:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00","20:00","21:00","22:00","23:00"]);
plot([1:24], A.U{3}(:,2), 'o')


subplot(4,3,7)
plot([1:100],A.U{1}(:,3), 'o')

subplot(4,3,8)
ylabs= ["Sunday","Monday","Tuesday","Wednesday", "Thursday","Friday","Saturday"];
plot([1:7], A.U{2}(:,3), 'o')

subplot(4,3,9)
xlabs =string(["00:00","01:00","02:00","03:00","04:00","05:00","06:00","07:00","08:00","09:00","10:00","11:00","12:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00","20:00","21:00","22:00","23:00"]);
plot([1:24], A.U{3}(:,4), 'o')

subplot(4,3,10)
plot([1:100],A.U{1}(:,4), 'o')

subplot(4,3,11)
ylabs= ["Sunday","Monday","Tuesday","Wednesday", "Thursday","Friday","Saturday"];
plot([1:7], A.U{2}(:,4), 'o')

subplot(4,3,12)
xlabs =string(["00:00","01:00","02:00","03:00","04:00","05:00","06:00","07:00","08:00","09:00","10:00","11:00","12:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00","20:00","21:00","22:00","23:00"]);
plot([1:24], A.U{3}(:,4), 'o')

figure(1)

figure
subplot(4,3,1)
plot([1:100],B.U{1}(:,1), 'o')

subplot(4,3,4)
plot([1:100],B.U{1}(:,2), 'o')

subplot(4,3,7)
plot([1:100],B.U{1}(:,3), 'o')

subplot(4,3,10)
plot([1:100],B.U{1}(:,4), 'o')
figure(2)

space= reshape(A.U{1}(:,1), 10, 10);
%space =space.'
space=rot90(space)
imagesc(space)

space2= reshape(A.U{1}(:,2), 10, 10);
space2=rot90(space2)
imagesc(space2)

space3= reshape(A.U{1}(:,3), 10, 10);
space3=rot90(space3)
imagesc(space3)

space4= reshape(A.U{1}(:,4), 10, 10);
space4=rot90(space4)
imagesc(space4)

csvwrite("/Users/astaicu/Desktop/RaleighCrime/10x10 assault model.csv", A.U{1});
