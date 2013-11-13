use 5.008;    # Require at least Perl version 5.8
use strict;   # Must declare all variables before using them
use warnings; # Emit helpful warnings
use autodie;  # Fatal exceptions for common unrecoverable errors (e.g. w/open)

# Testing-related modules
use Test::More;                  # provide testing functions (e.g. is, like)
use Test::LongString;            # Compare strings byte by byte
use Data::Section -setup;        # Set up labeled DATA sections
use File::Temp  qw( tempfile );  #
use File::Slurp qw( slurp    );  # Read a file into a string

# Distribution-specific modules


{
    my $input_filename  = filename_for('input');
    my $output_filename = temp_filename();
    system("perl convert_to_integers.pl $input_filename > $output_filename");
    my $result   = slurp $output_filename;
    my $expected = string_from('expected');
    is_string( $result, $expected, 'successfully created and manipulated temp files' );
}


done_testing();

sub sref_from {
    my $section = shift;

    #Scalar reference to the section text
    return __PACKAGE__->section_data($section);
}

sub string_from {
    my $section = shift;

    #Get the scalar reference
    my $sref = sref_from($section);

    #Return a string containing the entire section
    return ${$sref};
}

sub fh_from {
    my $section = shift;
    my $sref    = sref_from($section);

    #Create filehandle to the referenced scalar
    open( my $fh, '<', $sref );
    return $fh;
}

sub assign_filename_for {
    my $filename = shift;
    my $section  = shift;

    # Don't overwrite existing file
    die "'$filename' already exists." if -e $filename;

    my $string   = string_from($section);
    open(my $fh, '>', $filename);
    print {$fh} $string;
    close $fh;
    return;
}

sub filename_for {
    my $section           = shift;
    my ( $fh, $filename ) = tempfile();
    my $string            = string_from($section);
    print {$fh} $string;
    close $fh;
    return $filename;
}

sub temp_filename {
    my ($fh, $filename) = tempfile();
    close $fh;
    return $filename;
}

sub delete_temp_file {
    my $filename  = shift;
    my $delete_ok = unlink $filename;
    ok($delete_ok, "deleted temp file '$filename'");
}

#------------------------------------------------------------------------
# IMPORTANT!
#
# Each line from each section automatically ends with a newline character
#------------------------------------------------------------------------

__DATA__
__[ input ]__
>16 dna:
abcdeabcdeabcdeabcdeabcdeabcdeabcdeabcde
>scaffold_60 dna:scaffold scaffold:V1.0:scaffold_60:1:109023:1
abcde
>scaffold_69 dna:scaffold scaffold:V1.0:scaffold_69:1:114017:1
abcdeabcde
>scaffold_93 dna:scaffold scaffold:V1.0:scaffold_93:1:115332:1
abcdeabcdeabcdeabcde
>scaffold_57 dna:scaffold scaffold:V1.0:scaffold_57:1:117597:1
abcdeabcdeabcdeabcde
>scaffold_58 dna:scaffold scaffold:V1.0:scaffold_58:1:117646:1
abcdeabcdeabcdeabcde
>scaffold_56 dna:scaffold scaffold:V1.0:scaffold_56:1:122046:1
abcdeabcdeabcdeabcde
>scaffold_2067 dna:scaffold scaffold:V1.0:scaffold_2067:1:122890:1
abcdeabcdeabcdeabcde
>scaffold_104 dna:scaffold scaffold:V1.0:scaffold_104:1:123054:1
abcdeabcdeabcdeabcde
>22 danklfadjdsalfkjl
abcdeabcdeabcdeabcdeabcdeabcdeabcdeabcde
__[ expected ]__
>16
abcdeabcdeabcdeabcdeabcdeabcdeabcdeabcde
>60
abcde
>69
abcdeabcde
>93
abcdeabcdeabcdeabcde
>57
abcdeabcdeabcdeabcde
>58
abcdeabcdeabcdeabcde
>56
abcdeabcdeabcdeabcde
>2067
abcdeabcdeabcdeabcde
>104
abcdeabcdeabcdeabcde
>22
abcdeabcdeabcdeabcdeabcdeabcdeabcdeabcde
