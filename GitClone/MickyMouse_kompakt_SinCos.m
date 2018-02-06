Fs = 48000; % abtast freq
Ts = 1/Fs; % abtast zeit
t = (0:Ts:100); % zeit skala

f1 = 4000; % schiebe freq 1 = 10kHz 
% wav datei einlesen
[file_name wav_path] = uigetfile('*.wav', 'MM');
[YY, FS] = audioread([wav_path file_name]);
datei = YY';
t = t(1:length(datei));

% Filter laden % beim laden werden SOS & G matrizen erstellt (G: verstaerkungen , SOS: Sectionskoeffizienten)
load('IIR_4K_cheby_ord_24.mat');


% Spektrum um 4k nach rechts verschieben 
datei_cos4k = datei .* cos(2*pi*f1*t);
datei_sin4k = datei .* sin(2*pi*f1*t);

% filtern
datei_cos4k_gefiltert = sosfilt(SOS,datei_cos4k);
datei_sin4k_gefiltert = sosfilt(SOS,datei_sin4k);

% zweite schieberei um minus 2.4 KHz 
f2 = 2400;
datei_cos4k_gefiltert_cos = datei_cos4k_gefiltert .* cos(2*pi*f2*t);
datei_sin4k_gefiltert_sin = datei_sin4k_gefiltert .* sin(2*pi*f2*t);

ergebnis = datei_cos4k_gefiltert_cos + datei_sin4k_gefiltert_sin ;
spec_plot(ergebnis,Fs)