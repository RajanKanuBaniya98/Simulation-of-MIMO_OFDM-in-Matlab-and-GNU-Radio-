clear;
clc;
%%% Simple OFDM + 2*2 mimo system with cp
%%Consider 2 Channel Taps so the cyclix prefix of length 1


%%% H-tilda matrix of carrier
H_tilda=[1 2;3 4];
%%% SVD of each sub carrier matices
[U,S,V]=svd(H_tilda);

%%% Generation of random QPSK symbols
Data=[1+1j -1-1j -1+1j 1+1j 1-1j -1-1j 1+1j 1-1j];

%%% serial to 2 parallel arms with alternative symbols start from sym 1
Data_1=Data(1:2:end);
%%% ofdm (tx section) on upper branch
Data_1_g=ifft(Data_1);
%%Adding cp in upper branch
Data_1_g_cp=[Data_1_g(4) Data_1_g];
%%%serial to 2 parallel arms with alternative symbols start from sym 2
Data_2=Data(2:2:end);
%%% ofdm (tx section) on lower branch
Data_2_m=ifft(Data_2);
%%Adding cp IN lower branch
Data_2_m_cp=[Data_2_m(4) Data_2_m];

%%Combined upper and lower brach symbol which is input symbol matrix to mimo
Data_Matrix=[Data_1_g_cp;Data_2_m_cp];

%%Precoding with Symbols
for ii=1:length(Data_1_g_cp)
Data_Matrix_pre(:,ii)=V*Data_Matrix(:,ii);
end


Data_Matrix_Rx=Data_Matrix_pre;

%%At Rx after multiplication with H matrix and Combiner i.e Mimo Decoder
for ii=1:length(Data_1_g_cp)  
Data_Matrix_Dec(:,ii)=U.'*H_tilda*Data_Matrix_Rx(:,ii);
end

%Initialization of Matrixs to put the symbols
Data_Matrix_hat=zeros(2,4);
Data_Matrix_hat_cp=zeros(2,5);

%%Putting upper and lower decode mimo symbols in Vector
Data_Matrix_hat_cp(1:2:end)=Data_Matrix_Dec(1:2:end);
Data_Matrix_hat_cp(2:2:end)=Data_Matrix_Dec(2:2:end);

%%Removing Cyclix prefix and Performed FFTand Finally Dividing with sigmas       

Data_Matrix_hat(1:2:end)=fft(Data_Matrix_hat_cp(3:2:end))./S(1);%% removing cp on upper branch & ofdm decoder
Data_Matrix_hat(2:2:end)=fft(Data_Matrix_hat_cp(4:2:end))./S(4);%% removing cp on lower branch & ofdm decoder

%%Transmitted Symbol
Data_Matrix_Transmitted=reshape(Data,2,4)
%%Estimated Transmitted Symbols at Receiver
Data_Matrix_Received=Data_Matrix_hat 

