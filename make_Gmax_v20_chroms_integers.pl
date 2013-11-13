use 5.008;      # Require at least Perl version 5.8
use strict;     # Must declare all variables before using them
use warnings;   # Emit helpful warnings
use autodie;    # Automatically throw fatal exceptions for common unrecoverable
                #   errors (e.g. trying to open a non-existent file)

while(my $line = readline){

    # Convert all chromsome and scaffold lines to just numbers
    if($line =~ m{\A > (scaffold_)? (\d+) \s }xms){
       my $chrom = $2;
       print ">$chrom\n";
    }else{
        print $line;
    }
}
