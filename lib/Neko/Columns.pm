package Neko::Columns;
use strict;
use warnings;
use Data::Model::Schema sugar => 'myapp';

column_sugar 'user.id'
    => int => {
        require => 1,
        unsigned => 1,
    };
column_sugar 'user.name'
    => 'varchar' => {
        require => 1,
        size => 255,
    };

1;
