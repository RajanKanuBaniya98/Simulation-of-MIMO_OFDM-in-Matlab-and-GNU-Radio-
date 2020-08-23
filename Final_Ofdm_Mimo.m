clear;
clc;
%Simulation of OFDM + 2*2 Mimo 
%Consider 2 Channel Taps so the cyclix prefix of length 1

%%%Consider H tilda
H=[1 2;3 4];
%%% SVD of each sub carrier matices
[U,S,V]=svd(H);

%%% Generation of random QPSK symbols
Data=[1+1j -1-1j -1+1j 1+1j 1-1j -1-1j 1+1j 1-1j];

%IFFT AND CYCLIC PREFIX ADDITION
X1=ifft([Data(1) Data(3) Data(5) Data(7)]);
%X1_CP = [Data(7) Data(1) Data(3) Data(5) Data(7)];
X1_CP=[X1(4) X1];
X2=ifft([Data(2) Data(4) Data(6) Data(8)]);
X2_CP=[X2(4) X2];

%%% Precoding of QPSK symbols with respective sub carriers
Tx_sym_7_8= [X1(4) X2(4)].';
X_prime_7_8= V*Tx_sym_7_8;

Tx_sym_1_2=[X1(1) X2(1)].';
X_prime_1_2=V*Tx_sym_1_2;

Tx_sym_3_4=[X1(2) X2(2)].';
X_prime_3_4=V*Tx_sym_3_4;

Tx_sym_5_6=[X1(3) X2(3)].';
X_prime_5_6=V*Tx_sym_5_6;

Tx_sym_7_8=[X1(4) X2(4)].';
X_prime_7_8=V*Tx_sym_7_8;

%%% Passing through channel
%First Time Instant
Rx_Ant_1_T1=1*X_prime_7_8(1)+2*X_prime_7_8(2);
Rx_Ant_2_T1=3*X_prime_7_8(1)+4*X_prime_7_8(2);

%Second Time Instant
Rx_Ant_1_T2=1*X_prime_1_2(1)+2*X_prime_1_2(2);
Rx_Ant_2_T2=3*X_prime_1_2(1)+4*X_prime_1_2(2);

%Third Time Instant
Rx_Ant_1_T3=1*X_prime_3_4(1)+2*X_prime_3_4(2);
Rx_Ant_2_T3=3*X_prime_3_4(1)+4*X_prime_3_4(2);

%Fourth Time Instant
Rx_Ant_1_T4=1*X_prime_5_6(1)+2*X_prime_5_6(2);
Rx_Ant_2_T4=3*X_prime_5_6(1)+4*X_prime_5_6(2);

%Fifth Time Instant
Rx_Ant_1_T5=1*X_prime_7_8(1)+2*X_prime_7_8(2);
Rx_Ant_2_T5=3*X_prime_7_8(1)+4*X_prime_7_8(2);

%MUILTIPLYING WITH COMBINER MATRIX
X_hat_7_8=U.'*[Rx_Ant_1_T1 Rx_Ant_2_T1].';
X_hat_1_2=U.'*[Rx_Ant_1_T2 Rx_Ant_2_T2].';
X_hat_3_4=U.'*[Rx_Ant_1_T3 Rx_Ant_2_T3].';
X_hat_5_6=U.'*[Rx_Ant_1_T4 Rx_Ant_2_T4].';
X_hat_7_8=U.'*[Rx_Ant_1_T5 Rx_Ant_2_T5].';

X_Tilda=[X_hat_7_8 X_hat_1_2 X_hat_3_4 X_hat_5_6 X_hat_7_8]

%%SPLITTING MATIX INTO 2 ROWS
Data_Matrix_hat_cp1=X_Tilda(1,:);
Data_Matrix_hat_cp1
Data_Matrix_hat_cp2=X_Tilda(2,:);
Data_Matrix_hat_cp2

%Cyclic Prefix Removal and FFT and dividing by sigmas
Rx_Ant_1_DFT=fft(Data_Matrix_hat_cp1(2:end))./S(1);
Rx_Ant_2_DFT=fft(Data_Matrix_hat_cp2(2:end))./S(4);

%%Transmittd and Received Symbols
Transmitted_Input=[Data(1) Data(3) Data(5)  Data(7); Data(2) Data(4) Data(6) Data(8)]
%%Estimated Transmitted Symbols in Receiver
Decoded_output=[Rx_Ant_1_DFT;Rx_Ant_2_DFT]



