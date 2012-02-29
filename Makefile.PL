use inc::Module::Install;
name 'Time-Piece-Sketchy-Japanese';
all_from 'lib/Time/Piece/Sketchy/Japanese.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
