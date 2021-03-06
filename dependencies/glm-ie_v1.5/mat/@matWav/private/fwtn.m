%  FWTN - Periodized Wavelet Transform and its Inverse Transform
%    The wavelet transform is orthonormal i.e. norm(x(:))==norm(y(:)) 
%    with linear computational complexity O(numel(x)).
% 
%    The calling syntax is:
% 
% 			y = FWTN(x,l,f,transp,square);
%   
%    x        data whose size is l times divisable by 2 i.e. size(x) = sz*2^l
%    l        number of levels in the pyramid, 0 means FWTN reduces to y=x;
%    f        1d quadrature mirror filter coefficients
%    transp   0 for Fast Wavelet Transform and [default]
%             1 for Inverse Fast Wavelet Transform 
%    square   0 for the usual wavelet transfom with filter f [default]
%             1 for the wavelet transform with filter f.*f
%    y        output data of same size (and norm) as input data x
%   
%   
%   Examples for f corresponding to well-known kinds of wavelets
%       [ 1, 1 ]/sqrt(2)                                                  (Haar)
%       [-0.075765714789341, -0.029635527645954,                     (Symmlet,4)
%         0.497618667632458,  0.803738751805216, 0.297857795605542,
%        -0.099219543576935, -0.012603967262261, 0.032223100604071]
%       [ 1+sqrt(3), 3+sqrt(3), 3-sqrt(3), 1-sqrt(3) ]/sqrt(32)  (Daubechies, 4)
% 
%   Written by Hannes Nickisch, 17 June 2010; last modified, 19 Aug 2012.

function y = fwtn(x,l,f,varargin)

% check for a valid executable and compile
if exist('fwtn','file')~=3
  if exist('OCTAVE_VERSION') ~= 0             % check if we run Matlab or Octave
    fprintf('##############################################################\n');
    fprintf('\n  BEGIN GLM-IE MESSAGE\n\n\n')
    fprintf('you need to compile a MEX file via\n');
    fprintf('>> cd ~/glm-ie/mat/@matWav/private\n');
    fprintf('>> mkoctfile --mex fwtn.c wavelet.c\n');
    fprintf('>> delete fwtn.o\n');
    fprintf('>> delete wavelet.o\n');
    fprintf('>> cd ../../..\n');
    fprintf('\n\n  END GLM-IE MESSAGE\n\n')
    fprintf('##############################################################\n');
    error
  end
  
  me = mfilename; % what is my filename
  mydir = which(me); mydir = mydir(1:end-2-numel(me));      % where am I located
  mycd = pwd;
  eval(['cd ',mydir])
  mex -O fwtn.c wavelet.c
  clear functions
  if nargin<5, square = 0; else square = varargin(2); end
  if nargin<4, transp = 0; else transp = varargin(1); end
  y = fwtn(x,l,f,transp,square);
  eval(['cd ',mycd])
end
