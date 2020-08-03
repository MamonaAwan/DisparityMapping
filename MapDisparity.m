%% This Function Calculates the Disparity Map and Error in Disparity Map

function []=Disparity(left,right)

% Method Selection Input asked on Main Window
Method=input('\nEnter\n1 for SAD\n2 for SSD\n3 for NCC:\n');

% Window Size Selection Input asked on Main Window
WindowSize=input('Enter window size (3 or 5 or 7):\n');

% Reading and Converting Images
Im1=rgb2gray(imread(left));
Im2=rgb2gray(imread(right));
GroundTruth=im2double(imread('ground_truth.png'));
ImgL=im2double(Im1);
ImgR=im2double(Im2);

% Given Disparity Values
DispMin=0;
DispMax=60;

% Intializing
[row,col]=size(ImgL);
DispMap=zeros(size(ImgL));
ImgLD=[ImgL zeros(row,60)];
Win=(WindowSize-1)/2;

%% Disparity Calculation by SAD Method
if Method==1
    for i=1+Win:1:row-Win
        for j=1+Win:1:col-Win
            MaxSAD=256*(WindowSize^2);
            LeastDisp=DispMin;
            CurrentDisp=0.0;
            for DispRange=DispMin:1:DispMax
                SAD=0;
                for x=-Win:1:Win
                    for y=-Win:1:Win
                        CurrentDisp=abs(ImgLD(i+x,j+y+DispRange)-ImgR(i+x,j+y));
                        SAD=SAD+CurrentDisp;
                    end
                end
                if SAD<MaxSAD
                    MaxSAD=SAD;
                    LeastDisp=DispRange;
                end
            end
            DispMap(i,j)=LeastDisp;
        end
    end
    DispMapGray=mat2gray(DispMap);
    imshow(DispMapGray);
    Error=im2bw(GroundTruth-DispMapGray);
    figure;
    imshow(Error);
end

%% Disparity Calculation by SSD Method
if Method==2
    for i=1+Win:1:row-Win
        for j=1+Win:1:col-Win
            MaxSSD=(256*(WindowSize^2))^2;
            LeastDisp=DispMin;
            CurrentDisp=0.0;
            for DispRange=DispMin:1:DispMax
                SSD=0;
                for x=-Win:1:Win
                    for y=-Win:1:Win
                        CurrentDisp=(ImgLD(i+x,j+y+DispRange)-ImgR(i+x,j+y))^2;
                        SSD=SSD+CurrentDisp;
                    end
                end
                if SSD<MaxSSD
                    MaxSSD=SSD;
                    LeastDisp=DispRange;
                end
            end
            DispMap(i,j)=LeastDisp;
        end
    end
    DispMapGray=mat2gray(DispMap);
    imshow(DispMapGray);
    Error=im2bw(GroundTruth-DispMapGray);
    figure;
    imshow(Error);
end  

%% Disparity Calculation by NCC Method
if Method==3
    for i=1+Win:1:row-Win
        for j=1+Win:1:col-Win
            MinNCC=0.0;
            LeastDisp=DispMin;
            for DispRange=DispMin:1:DispMax
                CurrentNCC=0.0;
                NumNCC=0.0;
                DenNCC=0.0;
                RdenNCC=0.0;
                LdenNCC=0.0;
                Lmean=0.0;
                Rmean=0.0;
                 for x=-Win:1:Win
                    for y=-Win:1:Win
                        Lmean=Lmean+ImgLD(i+x,j+y+DispRange);
                        Rmean=Rmean+ImgR(i+x,j+y);
                    end
                 end
                Lmean=Lmean/(WindowSize^2);
                Rmean=Rmean/(WindowSize^2);
                for x=-Win:1:Win
                    for y=-Win:1:Win
                        NumNCC=NumNCC+((ImgLD(i+x,j+y+DispRange)-Lmean)*(ImgR(i+x,j+y)-Rmean));
                        RdenNCC=RdenNCC+((ImgR(i+x,j+y)-Rmean)^2);
                        LdenNCC=LdenNCC+((ImgLD(i+x,j+y+DispRange)-Lmean)^2);
                    end
                end
                DenNCC=sqrt(RdenNCC*LdenNCC);
                CurrentNCC=NumNCC/DenNCC;
                if MinNCC<CurrentNCC
                    MinNCC=CurrentNCC;
                    LeastDisp=DispRange;
                end
            end
            DispMap(i,j)=LeastDisp;
        end
    end
    DispMapGray=mat2gray(DispMap);
    imshow(DispMapGray);
    Error=im2bw(GroundTruth-DispMapGray);
    figure;
    imshow(Error);
end
end
%% End                  
