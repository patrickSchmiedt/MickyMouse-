Fs = 48000; % Abtast Frequenz
Ts = 1/Fs; % Abtast Zeit
t = (0:Ts:100); % Zeit Skala

% Frequenzen um das Spektrum zu verschieben 
% (Bei Änderung der Schiebefrequqnz muss auch ein anderer Filter verwendet werden) 
% f1 = 10000;
f1 = 4000;
% f1 = 2000;
% f1 = 1000;
% f1 = 500;


% Audio Datei datei einlesen (nur .wav möglich)
[file_name, wav_path] = uigetfile('*.wav', 'MM');
[YY, FS] = audioread([wav_path file_name]);

datei = YY';
t = t(1:length(datei));
% Um die ausgewählte Audio Datei anzuhören:
% sound(datei,Fs)

% Filter laden % beim laden werden SOS & G matrizen erstellt (G: verstaerkungen , SOS: Sectionskoeffizienten)
%load('IIR_10K_cheby_ord_31.mat');
%load('IIR_500_cheby_ord_17.mat');
%load('IIR_2K_cheby_ord_24.mat');
load('IIR_4K_cheby_ord_24.mat');

% filter design
% fdatool

%Größe des Plot Fenster einstellen (Position am Monitor und Pixel) 
f = figure;
set(f, 'Position', [300, 150, 1024, 768]);

% wav sig plotten
subplot(7,1,1)
plot(t(1:length(datei)),datei)
xlabel('Time in sec')
ylabel('Amplitude')

subplot(7,1,2)
spec_plot(datei,Fs)


% Spektrum um f1 nach rechts verschieben 
verschobene_datei = datei .* exp(1i*2*pi*f1*t);
subplot(7,1,3)
spec_plot(verschobene_datei,Fs)

% Verschobenes Signal filtern: 
gefilterte_datei = sosfilt(SOS,verschobene_datei);
subplot(7,1,4)
spec_plot(gefilterte_datei,Fs)

% gefiltertes Spektrum um f2 ein Stück zurück schieben 
f2= -2400;
komplexe_signal = gefilterte_datei .* exp(1i*2*pi*f2*t);
subplot(7,1,5)
spec_plot(komplexe_signal,Fs)

% Wieder reelles Spektrum bilden (Spiegelung an der Y-Achse)  
reelles_signal = real(komplexe_signal);
% Amplitude normieren
reelles_signal = reelles_signal/(2*max(reelles_signal));
subplot(7,1,6)
spec_plot(reelles_signal,Fs)

% das Ergebnis anhoeren
sound(reelles_signal,Fs)
% ergebnissignal im Zeitbereich darstellen
subplot(7,1,7)
%plot(t,reelles_signal)
xlabel('fertiges Signal')

audiowrite('fertiges_sig.wav',reelles_signal,Fs)
