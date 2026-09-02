local fs={}

function fs:scanFiles(path)
    return nativefs.getDirectoryItems(path)
end

return fs