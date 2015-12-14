function x = OMP(A, y, s)

x = zeros(size(A,2),1);
r = y; %residue

supp = zeros(1,s); %support
for i=1:s
    [~, IX] = sort(abs(r'*A),'descend');
    supp(i) = IX(1);   
    Ai = A(:,supp(1:i));
    b = (Ai'*Ai)\Ai'*y; %least squares
    r = y - Ai*b; %residue update
end
x(supp) = b;
end