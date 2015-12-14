function s = BlockOMP(A, y, group, k)

c = max(group);
s = zeros(size(A,2),1);
r(:,1) = y; L = []; Psi = [];
for j = 1:c
    g{j} = find(group == j);
end

for i = 1:k
    l = A'*r(:,i);
    [~, IX] = sort(abs(l),'descend');
    I = g{group(IX(1))};
    L = [L' I']';
    Psi = A(:,L);
    x = Psi\y;
    r(:,i+1) = y - Psi*x;
    i = i + 1;
end

s(L) = x;