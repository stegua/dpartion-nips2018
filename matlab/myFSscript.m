clear
close all
format short

rand('seed', 0);

if 1 == 1
    % SET YOUR LOCAL PATH TO THE BENCHMARKS
    %b = "C:\Users\Gualandi\Google Drive";
    b = "D:\GoogleDrive";
    base = b + "\Ricerca\DOTA\data\DOTmark_1.0\Data\";
    
    imsize = "\data32_";
    images = ["CauchyDensity", "ClassicImages", "GRFmoderate", "GRFrough", "GRFsmooth", "LogGRF", "LogitGRF", "MicroscopyImages", "Shapes", "WhiteNoise"];
    fs = ["1001.csv","1002.csv","1003.csv","1004.csv","1005.csv","1006.csv","1007.csv","1008.csv","1009.csv","1010.csv"];
    nh = 32;
else
    % BASIC TEST
    base = "./";
    images = "";
    imsize = "";
    fs = ["test1.csv","test2.csv"];%,"1003.csv","1004.csv","1005.csv","1006.csv","1007.csv","1008.csv","1009.csv","1010.csv"];
    nh = 4;
end

d1 = nh*nh;
d2 = nh*nh;

C = zeros(d1,d2);

for i = 1:nh
    for j = 1:nh
        for v = 1:nh
            for w = 1:nh
                C(nh*(i-1)+j,nh*(v-1)+w) = (i-v)^2 + (j-w)^2;
            end
        end
    end
end

    
A = zeros(nh, nh);
for i = 1:nh
    for j = 1:nh
        A(i,j) = (i-j)^2;
    end
end

k = length(fs);
ni = length(images);

for fi = 1:ni
    for f1 = 1:(k-1)
        a = csvread(base+images(fi)+imsize+fs(f1));
        a = a(:);
        for f2 = (f1+1):k
            b = csvread(base+images(fi)+imsize+fs(f2));
            b = b(:);
            % IT IS HARD TO FIND A GOOD VALUE OF LAMBDA FOR ALL CLASS OF
            % IMAGES
            for lambda = [0.125]%0.75,1.0,1.25,1.5]
                H1 = a;
                H2 = b;
                
                % Measure time
                tStart = tic;
                D = myFS(H1, H2, A, lambda, 2000, [], false, C);
                tElapsed = toc(tStart);

                disp(join([images(fi),fs(f1),fs(f2),'lambda',num2str(lambda),'runtime', num2str(tElapsed), 'UB', num2str(D)]));
            end
        end
    end
end
