% gibt spec zurueck : uebergabe (sig, Fs)
function y = spec_plot(x,fs)

% Das SpeKtrum Berechnen 
x_spec = fftshift(fft(x));
% die Frequenz achse skalieren 
f = fs*(-(length(x_spec)/2):length(x_spec)/2-1)/length(x_spec);
% betrag das Spektrum heraus nehmen 
x_spec_1 = abs(x_spec/length(x_spec));


plot(f,x_spec_1)
xlabel('freq in Hz')
ylabel('Magnitude')
%axis([-2000 2000 0 inf])
end 