function txt = displayCoordinates(~,info)
    x = info.Position(1);
    y = info.Position(2);
    txt = ['(' num2str(x) ', ' num2str(y) ')'];
end