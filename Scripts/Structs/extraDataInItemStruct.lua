local oldItem = structs.f.Item
function structs.f.Item(define, ...)
    oldItem(define, ...)
    define[0x16].i2("ExtraData")
end

-- fix repairing items zeroing extra data
mem.asmpatch(0x41C71C ,[[
    and byte [ebx + 0x14], 0xFD ; item repaired
    or byte [ebx + 0x14], 1 ; item identified
]])