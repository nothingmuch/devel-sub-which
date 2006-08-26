#!/usr/bin/perl -w

use strict;

use Module::Build;

Module::Build->new(
	module_name => 'Devel::Sub::Which',
	license => 'perl',
	requires => {
		'perl'	=> '>= 5.6.0',
		'B'		=> '0',
	},
	build_requires => {
		'Test::More' => 0,
		'Test::Exception' => 0,
	},
	create_makefile_pl => 'traditional',
	sign => 1,
)->create_build_script;
