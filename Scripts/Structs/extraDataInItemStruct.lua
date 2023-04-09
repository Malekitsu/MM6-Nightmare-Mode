local oldItem = structs.f.Item
function structs.f.Item(define, ...)
    oldItem(define, ...)
    define[0x16].i2("ExtraData")
end