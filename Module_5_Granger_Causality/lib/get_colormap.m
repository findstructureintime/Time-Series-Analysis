function colors = get_colormap(n)
% This function loads a set of predefined colors for visualization. 
% The predefined colors were generated from funcion distinguishable_colors by Timothy E. Holy
% 
% @param n -- the number of colors 
% 
% Reference: Tim Holy (2020). Generate maximally perceptually-distinct colors 
% (https://www.mathworks.com/matlabcentral/fileexchange/29702-generate-maximally-perceptually-distinct-colors), 
% MATLAB Central File Exchange. Retrieved March 3, 2020.

predefined_colors = [
         0         0    1.0000
         0    1.0000         0
    1.0000         0         0
    1.0000         0    1.0000
    1.0000    0.8276         0
         0    0.3448         0
    0.5172    0.5172    1.0000
    0.6207    0.3103    0.2759
         0    1.0000    0.7586
         0    0.5172    0.5862
         0         0    0.4828
    0.5862    0.8276    0.3103
    0.9655    0.6207    0.8621
    0.8276    0.0690    1.0000
    0.4828    0.1034    0.4138
    0.9655    0.0690    0.3793
    1.0000    0.7586    0.5172
    0.1379    0.1379    0.0345
    0.5517    0.6552    0.4828
    0.9655    0.5172    0.0345
    0.5172    0.4483         0
    0.4483    0.9655    1.0000
    0.6207    0.7586    1.0000
    0.4483    0.3793    0.4828
    0.6207         0         0
         0    0.3103    1.0000
         0    0.2759    0.5862
    0.8276    1.0000         0
    0.7241    0.3103    0.8276
    0.2414         0    0.1034
    0.9310    1.0000    0.6897
    1.0000    0.4828    0.3793
    0.2759    1.0000    0.4828
    0.0690    0.6552    0.3793
    0.8276    0.6552    0.6552
    0.8276    0.3103    0.5172
    0.4138         0    0.7586
    0.1724    0.3793    0.2759
         0    0.5862    0.9655
    0.0345    0.2414    0.3103
    0.6552    0.3448    0.0345
    0.4483    0.3793    0.2414
    0.0345    0.5862         0
    0.6207    0.4138    0.7241
    1.0000    1.0000    0.4483
    0.6552    0.9655    0.7931
    0.5862    0.6897    0.7241
    0.6897    0.6897    0.0345
    0.1724         0    0.3103
         0    0.7931    1.0000
    0.3103    0.1379         0
         0    0.7241    0.6552
    0.6207         0    0.2069
    0.3103    0.4828    0.6897
    0.1034    0.2759    0.7586
    0.3448    0.8276         0
    0.4483    0.5862    0.2069
    0.8966    0.6552    0.2069
    0.9655    0.5517    0.5862
    0.4138    0.0690    0.5517];
num_colors = size(predefined_colors, 1);

if nargin > 0
    if n <= 60
        colors = predefined_colors(1:n, :);
    else
        n_duplicate = floor(n/num_colors);
        n_remainder = mod(n, num_colors);
        colors = repmat(predefined_colors, n_duplicate, 1);
        colors = [colors; predefined_colors(1:n_remainder, :)];
    end
else
    colors = predefined_colors;
end

    