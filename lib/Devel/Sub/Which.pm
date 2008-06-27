#!/usr/bin/perl

use 5.006;

package Devel::Sub::Which;

use strict;
use warnings;

our $VERSION = "0.03";

use Sub::Identify qw(sub_fullname);
use Scalar::Util qw/reftype/;
use Carp qw/croak/;

use base qw/Exporter/;
our @EXPORT_OK = qw/which ref_to_name/;

sub import {
	my $pkg = shift;

	my $universal = undef;

	@_ = ($pkg, grep { not ($_ eq ":universal" and $universal=1) } @_);

	*UNIVERSAL::which = \&which if $universal;

	goto \&Exporter::import;
}

sub which ($;$) {
	my $obj = shift;
	my $sub = shift;

	return sub_fullname($obj) if not defined $sub; # just a sub, no object

	if (ref $sub and reftype $sub eq 'CODE'){ # this is not documented, it's for sanity.
		return sub_fullname($sub);
	} else {
		my $ref = $obj->can($sub);
		croak("$obj\->can($sub) did not return a code reference") unless ref $ref and reftype $ref eq 'CODE';
		return sub_fullname($ref);
	}
}

sub ref_to_name ($) {
	my $sub = shift;

	unless (ref $sub and reftype $sub eq 'CODE'){ # this is not documented, it's for sanity.
		croak "$sub is not a code reference";
	}

	sub_fullname($sub);
}

__PACKAGE__

__END__

=pod

=head1 NAME

Devel::Sub::Which - Name information about sub calls à la L<UNIVERSAL/can> and
<which(1)>.

=head1 SYNOPSIS

	use Devel::Sub::Which qw/:universal/;

	# elsewhere

	$obj->which("foo"); # returns the name of the sub that
	                    # will implement the "foo" method

	Devel::Sub::Which::which($code_ref); # returns the name of the ref

=head1 DESCRIPTION

I don't like the perl debugger. I'd rather print debug statements as I go
along, mostly saying "i'm going to do so and so", so I know what to look for
when stuff breaks.

Often I find myself faced with polymorphism crap flying into my. With
multiple inheritence, delegations, runtime generated classes, method calls on
non predeterminate values, and so forth, it sometimes makes sense to do:

	my $method = < blah blah blah >;

	debug("i'm going to call $method on $obj. FYI, it's going to be "
		. $obj->which($method));

	$obj->$method()

In order to figure out exactly which $method was responsible for your error, or
whatever. This helps the above debugging style by providing more deterministic
reporting.

=head1 METHODS

=over 4

=item OBJ->which( METHOD )

This method determines which subroutine reference will be executed for METHOD,
using L<UNIVERSAL::can> (or any overriding implementation), 

=back

=head1 FUNCTIONS

=over 4

=item which OBJ METHOD

=item which CODEREF

The first form has the same effect as OBJ->which(METHOD), and the second form
just delegates to L<Sub::Identify>

=back

=head1 EXPORTS

Nothing is exported by default. These parameters will have an effect:

=over 4

=item :universal

This causes C<which> to become a method in L<UNIVERSAL>, so that you can call
it on any object.

=item which

=back

=head1 ACKNOWLEGEMENTS

Yitzchak Scott-Thoennes provided the know-how needed to get the name of a sub
reference.

=head1 VERSION CONTROL

This module is maintained using Darcs. You can get the latest version from
L<http://nothingmuch.woobling.org/Devel-Sub-Which/>, and use C<darcs send> to
commit changes.

=head1 AUTHOR

Yuval Kogman <nothingmuch@woobling.org>

=head1 COPYRIGHT & LICENSE

        Copyright (c) 2004 Yuval Kogman. All rights reserved
        This program is free software; you can redistribute
        it and/or modify it under the same terms as Perl itself.

=head1 SEE ALSO

L<Sub::Identify>, L<DB>, L<perldebug>, L<UNIVERSAL>, L<B>

=cut
