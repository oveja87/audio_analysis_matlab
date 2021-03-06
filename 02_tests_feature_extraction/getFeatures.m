function [ peak1F, peak1A, peak2F, peak2A, peak3F, peak3A, numPeaks, meanPeakF, meanPeakA, meanA, maxFI1, maxAI1, meanFI1, meanAI1, meanAI2, IRate, peakW1F, peakW1A, peakW2F, peakW2A, peakW3F, peakW3A, maxS, meanS ] = getFeatures( w, w1, w2, w3, fs )
%Analyse Window
%   Analyses frequency characteristics of a window in a soundfile

    %get absolute values for w
    w = abs(w);    

    %find frequency peaks
    [pks,locs] = findpeaks(w, 'MinPeakHeight', max(w)/20); 
    
    %sorts peaks descendending
    P = sortrows([locs;pks]',-2); % sort peaks descendending to pick the three lagest of them, afterwards
   
    numPeaks = length(P(:,1));
    
    if numPeaks > 0  
        peak1F = P(1,1);   
        peak1A = P(1,2);
    else
        peak1F = 0;
        peak1A = 0;
    end    
    if numPeaks > 1 
        peak2F = P(2,1);
        peak2A = P(2,2);
    else
        peak2F = 0;
        peak2A = 0;
    end    
    if numPeaks > 2 
        peak3F = P(3,1);
        peak3A = P(3,2);       
    else
        peak3F = 0;
        peak3A = 0;
    end    
        
    %mean peak frequency and amplitude 
    meanPeakATmp = 0;
    meanPeakFTmp = 0;
    for i=1:length(pks)
      meanPeakATmp = meanPeakATmp + abs(pks(i)^2);
      meanPeakFTmp = meanPeakFTmp + (abs(pks(i)^2) * locs(i));
    end
    meanPeakF = meanPeakFTmp/meanPeakATmp;
    meanPeakA = meanPeakATmp/length(pks);
     
    %root mean sqare energy of F
    meanATmp = 0;
    for i=1:length(w)
      meanATmp = meanATmp + abs(w(i)^2); 
    end
    meanA = meanATmp/length(w);    
    
    
    %% intervals 1-2000 Hz, 2000-22,050Hz
    ws = length(w)*2;
    numBinsI1 = round(ws/fs*2000);
    
    % maximum amplitude of w - Interval 1
    [maxAI1, maxFI1] = max(w(1:numBinsI1));
    
    %root mean sqare energy of w - Interval 1
    meanAI1Tmp = 0;
    meanFI1Tmp = 0;
    for i=1:numBinsI1
      meanAI1Tmp = meanAI1Tmp + abs(w(i)^2);
      meanFI1Tmp = meanPeakFTmp + (abs(w(i)^2) * i);
    end
    meanFI1 = meanFI1Tmp/meanAI1Tmp;    
    meanAI1 = meanAI1Tmp/numBinsI1;     
    
    %root mean sqare energy of w - Interval 2
    meanAI2 = 0;
    for i=numBinsI1+1:length(w)
      meanAI2 = meanAI2 + abs(w(i)^2);  
    end
    
    meanAI2 = meanAI2/(length(w)-numBinsI1);
 
    %interval rate
    IRate = meanAI2-meanAI1;
  
    % max frame peaks   
    [peakW1A, peakW1F] = max(abs(w1));
    [peakW2A, peakW2F] = max(abs(w2));
    [peakW3A, peakW3F] = max(abs(w3));    

    %steadiness     
     S = angle(w2.*w2./w1./w3); 
     S(find(isnan(S)))=0;
   
     meanS = mean(abs(S(1:length(w)/10)));     
     maxS = abs(S(peakW1F));
end

