
function varargout = XGEQP3(A)
%XGEQP3 A wrapper for calling lapack routines for QR factorization
%
% Output stores info for QR factorization in terms of 
% elementary reflectors.
%
% Examples:
%
%   >> C = XGEQP3(A) % get LAPACK output as cell structure
%   >> [AOUT,JPVT,TAU] = XGEQP3(A) % get description sufficient for 
%                                  % XORMQR
%
% See also XORMQR, LAPACK

[m,n] = size(A);

if (nargout ~= 1 && nargout ~= 3)
    error('Only 1 or 3 output arguments supported');
end

if (isa(A,'double'))
    if (isreal(A))
        s = 'D';
        funstr = [s, 'GEQP3'];
        lwork = -1;
        C = lapack(funstr,m,n,A,m,zeros(max(m,n),1), ...
            zeros(max(m,n),1),zeros(10,1),lwork,0);
        lwork = C{7}(1);
        C = lapack(funstr,m,n,A,m,zeros(max(m,n),1), ...
           zeros(max(m,n),1),zeros(lwork,1),lwork,0);
    else
        s = 'Z';
        funstr = [s, 'GEQP3'];
        lwork = -1;
        C = lapack(funstr,m,n,A,m,zeros(2*max(m,n),1), ...
            zeros(2*max(m,n),1),zeros(10,1),lwork,zeros(4*max(m,n),1),0);
        lwork = C{7}(1);
        C = lapack(funstr,m,n,A,m,zeros(2*max(m,n),1), ...
           zeros(2*max(m,n),1),zeros(lwork,1),lwork,zeros(4*max(m,n),1),0);
    end
else
    error('Data type of A unsupported at this time');
end

if (nargout == 1)
    varargout{1} = C;
else
    varargout{1} = C{3};
    varargout{2} = C{5};
    varargout{3} = C{6};    
end