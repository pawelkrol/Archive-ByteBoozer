#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "cruncher.h"

MODULE = Archive::ByteBoozer  PACKAGE = Archive::ByteBoozer
PROTOTYPES: ENABLE

# my $source = bb_source($data, $size);

File*
bb_source(data, size)
        unsigned char *data
        size_t         size
    CODE:
        File *source;
        Newxz(source, 1, File);
        if (source == NULL)
            XSRETURN_UNDEF;
        source->size = size;
        source->data = (byte *)data;
        RETVAL = source;
    OUTPUT:
        RETVAL

# my $target = bb_crunch($source, $start_address);

File*
bb_crunch(source, start_address)
        File         *source
        unsigned int  start_address
    CODE:
        File *target;
        Newxz(target, 1, File);

        decruncherType theDecrType = noDecr;
        if (start_address > 0)
          theDecrType = normalDecr;

        boolean isRelocated = false;

        if (target == NULL)
            XSRETURN_UNDEF;
        if (!crunch(source, target, start_address, theDecrType, isRelocated))
            XSRETURN_UNDEF;
        RETVAL = target;
    OUTPUT:
        RETVAL

# my $data = bb_data($file);

SV*
bb_data(file)
        File *file
    PPCODE:
        mXPUSHs(newSVpv(file->data, file->size));

# my $size = bb_size($file);

unsigned int
bb_size(file)
        File *file
    PPCODE:
        mXPUSHs(newSViv(file->size));

# bb_free($source, $target);

SV*
bb_free(source, target)
        File *source
        File *target
    CODE:
        Safefree(source);
        Safefree(target);
        XSRETURN_UNDEF;
