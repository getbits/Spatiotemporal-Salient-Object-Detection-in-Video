function optwCtr = SaliencyOptimization(adjcMatrix, bdIds, colDistM, neiSigma, bgWeight, fgWeight)
% Solve the least-square problem in Equa(9) in our paper

adjcMatrix_nn = LinkNNAndBoundary(adjcMatrix, bdIds);
colDistM(adjcMatrix_nn == 0) = Inf;
Wn = Dist2WeightMatrix(colDistM, neiSigma);      %smoothness term
mu = 0.1;                                        %small coefficients for regularization term
W = Wn + adjcMatrix * mu;                        %add regularization term
D = diag(sum(W));

bgLambda = 5;                                    %global weight for background term, bgLambda > 1 means we rely mo on bg cue than fg cue.5
E_bg = diag(bgWeight * bgLambda);                %background term
E_fg = diag(fgWeight);                           %foreground term

spNum = length(bgWeight);
optwCtr =(D - W + E_bg + E_fg) \ (E_fg * ones(spNum, 1));