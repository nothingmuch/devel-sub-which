require 5.6.0;

use ExtUtils::MakeMaker;

WriteMakefile (
	'NAME' => 'Devel::Sub::Which',
	'VERSION_FROM' => 'lib/Devel/Sub/Which.pm',
	'PREREQ_PM' => {
		'Test::Exception' => 0,
		'Test::More' => 0,
		'Sub::Identify' => 0,
	},
	'INSTALLDIRS' => 'site',
	'EXE_FILES' => [],
	'PL_FILES' => {},
	'SIGN' => 1,
);
