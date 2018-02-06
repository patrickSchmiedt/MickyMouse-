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
verschobene_datei = datei .* exp(j*2*pi*f1*t);

% filtern das verschobene signal 
gefilterte_datei = sosfilt(SOS,verschobene_datei);

% gefiltertes Spektrum nocheinmal um 10k nach rechts verschieben 
f2= -2400;
komplexe_signal = gefilterte_datei .* exp(j*2*pi*f2*t);
reelles_signal = real(komplexe_signal); % reelles signal 

reelles_signal = reelles_signal /(2*max(reelles_signal)); % Amplitude Normierung



% ergebnissignal im Zeitbereich darstellen
subplot(7,1,7)
plot(t,reelles_signal)
xlabel('fertiges Signal')

audiowrite('MM_fertiges_sig.wav',reelles_signal,Fs)
