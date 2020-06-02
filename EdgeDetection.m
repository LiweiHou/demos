clear all;
close all;
%输入图像，预处理
image = imread('test6.jpg', 'jpg'); %读取图像
image=rgb2gray(image);  %RGB转灰度
% 加噪声
image=imnoise(image,'gaussian')
%确定阈值
thresh=graythresh(image);    %自动确定二值化阈值
I=im2bw(image,thresh);
%edge函数的实现
J1=edge(I,'Sobel');
J2=edge(I,'Prewitt');
J3=edge(I,'Roberts');
J4=edge(I,'LOG');
J5=edge(I,'Canny');

%自己实现sobel
% J1_self = my_sobel('C:\Users\86185\Desktop\bw053102\test4.jpg');
% J1_self = uint8(J1_self);

%作图
figure;
subplot(331),imshow(image);title('原图');
% subplot(332),imshow(I);title('二值化后图像');
subplot(333),imshow(J1);
subplot(334),imshow(J2);
subplot(335),imshow(J3);
subplot(336),imshow(J4);
subplot(337),imshow(J5);

%输出图片
% imwrite(J1_self, 'result5.jpg', 'jpg');