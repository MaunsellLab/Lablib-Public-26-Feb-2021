//
//  LablibQuest.m
//  
//
//  Created by John Maunsell on 2/24/18.
//

#import "LablibQuest.h"

@implementation LablibQuest

- (id)initWithGuess:(double)guess guessSD:(double)guessSD pThreshold:(double)pThreshold beta:(double)beta
delta:(double)delta gamma:(double)gamma grain:(double)grain range:(double)range;
{
    if ((self = [super init]) != nil) {
        self.grain = (grain == 0) ? 0.01 : grain;
        self.dim = (range == 0) ? 500.0 : 2 * ceil(range / grain / 2);
        self.updatePdf = YES;
        self.warnPdf = YES;
        self.normalizedPdf = YES;
        self.guess = guess;
        self.guessSD = guessSD;
        self.pThreshold = pThreshold;
        self.beta = beta;
        self.delta = delta;
        self.gamma = gamma;
        self.grain = grain;
        self.dim = self.dim;
        [self recompute];
    }
    return self;
}

- (void)recompute;
{
    long index;
    double x[], x2[], p2[], pdf[], sumPDF;

    if (!self.updatePdf) {
        return;
    }
    if (self.gamma > self.pThreshold) {
        NSLog(@"LablibQuest: Reducing gamma from %.2f to 0.5", self.gamma);
        self.gamma = 0.5;
    }

    for (index = -self.dim / 2, pdfSum = 0; index < self.dim / 2; index++) {
        x[index] = index * self.grain;
        pdf[index] = exp(-0.5 * (x[index] * x[index] / self.guessSD / self.guessSD));
        pdfSum += pdf[index];
    }
    for (index = -self.dim / 2, pdfSum = 0; index < self.dim / 2; index++) {
        pdf[index] /= pdfSum;
    }
    for (index = -self.dim; index < self.dim; index++) {
        x2[index] = index * self.grain;
        p2[index] = self.delta * self.gamma + (1 - self.delta) * (1 - (1 - self.gamma) *
                                                                  exp(-exp(log(10.0) * (self.beta * x2)));
    }
//    q.i=-q.dim/2:q.dim/2;
//    q.x=q.i*q.grain;
//    q.pdf=exp(-0.5*(q.x/q.tGuessSd).^2);
//    q.pdf=q.pdf/sum(q.pdf);
//    i2=-q.dim:q.dim;
//    q.x2=i2*q.grain;
//    q.p2=q.delta*q.gamma+(1-q.delta)*(1-(1-q.gamma)*exp(-10.^(q.beta*q.x2)));


    if q.p2(1)>=q.pThreshold || q.p2(end)<=q.pThreshold
        error(sprintf('psychometric function range [%.2f %.2f] omits %.2f threshold',q.p2(1),q.p2(end),q.pThreshold))
        end
        if any(~isfinite(q.p2))
            error('psychometric function p2 is not finite')
            end
            index=find(diff(q.p2));         % subset that is strictly monotonic
    if length(index)<2
        error(sprintf('psychometric function has only %g strictly monotonic point(s)',length(index)))
        end
        q.xThreshold=interp1(q.p2(index),q.x2(index),q.pThreshold);
    if ~isfinite(q.xThreshold)
        q %#ok<NOPRT>
        error(sprintf('psychometric function has no %.2f threshold',q.pThreshold))
        end
        q.p2=q.delta*q.gamma+(1-q.delta)*(1-(1-q.gamma)*exp(-10.^(q.beta*(q.x2+q.xThreshold))));
    if any(~isfinite(q.p2))
        q %#ok<NOPRT>
        error('psychometric function p2 is not finite')
        end
        q.s2=fliplr([1-q.p2;q.p2]);
    if ~isfield(q,'intensity') || ~isfield(q,'response')
        % Preallocate for 10000 trials, keep track of real useful content in
            % q.trialCount. We allocate such large chunks to reduce memory
            % fragmentation that would be caused by growing the arrays one element
            % per trial. Fragmentation has been shown to cause severe out-of-memory
            % problems if one runs many interleaved quests. 10000 trials require/
                % waste about 157 kB of memory, which is basically nothing for todays
                    % computers and likely sufficient for even the most tortorous experiment
                        % sessions.
                        q.trialCount = 0;
    q.intensity=zeros(1,10000);
    q.response=zeros(1,10000);
    end

    if any(~isfinite(q.s2(:)))
        error('psychometric function s2 is not finite')
        end

        % Best quantileOrder depends only on min and max of psychometric function.
        % For 2-interval forced choice, if pL=0.5 and pH=1 then best quantileOrder=0.60
            % We write x*log(x+eps) in place of x*log(x) to get zero instead of NaN when x is zero.
            pL=q.p2(1);
    pH=q.p2(size(q.p2,2));
    pE=pH*log(pH+eps)-pL*log(pL+eps)+(1-pH+eps)*log(1-pH+eps)-(1-pL+eps)*log(1-pL+eps);
    pE=1/(1+exp(pE/(pL-pH)));
    q.quantileOrder=(pE-pL)/(pH-pL);

    if any(~isfinite(q.pdf))
        error('prior pdf is not finite')
        end
        % recompute the pdf from the historical record of trials
        for k=1:q.trialCount
            inten=max(-1e10,min(1e10,q.intensity(k))); % make intensity finite
    ii=size(q.pdf,2)+q.i-round((inten-q.tGuess)/q.grain);
    if ii(1)<1
        ii=ii+1-ii(1);
    end
    if ii(end)>size(q.s2,2)
        ii=ii+size(q.s2,2)-ii(end);
    end
    q.pdf=q.pdf.*q.s2(q.response(k)+1,ii); % 4 ms
    if q.normalizePdf && mod(k,100)==0
        q.pdf=q.pdf/sum(q.pdf);    % avoid underflow; keep the pdf normalized    % 3 ms
    end
    end
    if q.normalizePdf
        q.pdf=q.pdf/sum(q.pdf);        % keep the pdf normalized    % 3 ms
    end
    if any(~isfinite(q.pdf))
        error('pdf is not finite')
        end

}
@end
