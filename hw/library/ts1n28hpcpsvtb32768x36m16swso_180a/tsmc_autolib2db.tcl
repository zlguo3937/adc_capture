set enable_write_db_mode True

foreach libfile [glob NLDM/*.lib] {
    regsub {\.lib} $libfile "" pre
    regsub {NLDM\/} $pre "" pre
    set dbname "${pre}.db"
    regsub {180a} $pre "" pre
    puts "HQQ_INFO: prename-$pre"
    read_lib $libfile
    write_lib -format db $pre -output NLDM/${dbname}
    remove_lib $pre
}

exit
